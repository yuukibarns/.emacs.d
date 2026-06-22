;;; zotero-completion.el --- Zotero annotation and PDF completion via Vertico -*- lexical-binding: t; -*-

;;; Commentary:
;;
;; Complete Zotero annotations and PDF files in Markdown buffers using Vertico.
;;
;; Usage:
;;   1. Keep Zotero Desktop running.
;;   2. Run `M-x my-zotero-insert-annotation` (or bind it to a preferred key).
;;   3. Select a candidate in Vertico to insert its Markdown link at point.
;;
;; Suggested Keybinding:
;;   (keymap-set markdown-mode-map "C-c z" #'my-zotero-insert-annotation)
;;
;; Commands:
;;   M-x my-zotero-annotations-refresh
;;   M-x my-zotero-annotations-clear-cache
;;
;; This module talks to Zotero's local HTTP API and caches metadata locally to disk.

;;; Code:

(require 'cl-lib)
(require 'json)
(require 'subr-x)
(require 'url)
(require 'url-http)

(defgroup my-zotero-completion nil
  "Completion of Zotero annotations and PDFs at point."
  :group 'completion
  :prefix "my-zotero-")

(defcustom my-zotero-api-base-url "http://127.0.0.1:23119/api"
  "Base URL of Zotero's local API."
  :type 'string)

(defcustom my-zotero-annotation-limit 10000
  "Maximum number of recently modified items to retrieve."
  :type 'integer)

(defcustom my-zotero-request-timeout 5
  "Timeout in seconds for calls to Zotero's local API."
  :type 'number)

(defcustom my-zotero-cache-file
  (locate-user-emacs-file "zotero-completion-cache.eld")
  "File path where Zotero completion cache is persisted."
  :type 'file)

(defvar my-zotero-annotations-cache nil
  "Cached normalized Zotero annotations and PDFs.")

(defvar my-zotero-annotations-cache-time nil
  "Time at which `my-zotero-annotations-cache' was populated.")

(defvar my-zotero--candidate-table (make-hash-table :test #'equal)
  "Map displayed completion candidates to item plists.")

(defun my-zotero--api-url (type)
  "Return the URL used to retrieve recent items of TYPE (e.g. annotation or attachment)."
  (format
   (concat "%s/users/0/items"
           "?itemType=%s"
           "&limit=%d"
           "&sort=dateModified"
           "&direction=desc")
   (string-remove-suffix "/" my-zotero-api-base-url)
   type
   my-zotero-annotation-limit))

(defun my-zotero--top-items-url ()
  "Return the URL used to retrieve top-level library items."
  (format
   (concat "%s/users/0/items/top"
           "?limit=%d"
           "&sort=dateModified"
           "&direction=desc")
   (string-remove-suffix "/" my-zotero-api-base-url)
   my-zotero-annotation-limit))

(defun my-zotero--read-json-url (url)
  "Retrieve URL synchronously and return parsed JSON.

Signal a user-facing error when Zotero cannot be contacted."
  (let ((url-request-extra-headers
         '(("Zotero-API-Version" . "3")))
        buffer)
    (condition-case err
        (setq buffer
              (url-retrieve-synchronously
               url 'silent 'inhibit-cookies my-zotero-request-timeout))
      (error
       (user-error "Could not contact Zotero: %s"
                   (error-message-string err))))
    (unless (buffer-live-p buffer)
      (user-error
       "Could not contact Zotero at %s; is Zotero Desktop running?"
       my-zotero-api-base-url))
    (unwind-protect
        (with-current-buffer buffer
          (goto-char (point-min))
          (unless (re-search-forward "\r?\n\r?\n" nil t)
            (user-error "Zotero returned an invalid HTTP response"))
          (when (boundp 'url-http-response-status)
            (unless (and url-http-response-status
                         (<= 200 url-http-response-status)
                         (< url-http-response-status 300))
              (user-error "Zotero API returned HTTP %s"
                          url-http-response-status)))
          (json-parse-buffer
           :object-type 'alist
           :array-type 'list
           :null-object nil
           :false-object nil))
      (kill-buffer buffer))))

(defun my-zotero--data (item)
  "Return ITEM's Zotero data object."
  (alist-get 'data item))

(defun my-zotero--format-creators (creators)
  "Format list of CREATORS into a citation author string."
  (let* ((authors (cl-loop for creator in creators
                           when (string= (alist-get 'creatorType creator) "author")
                           collect (or (alist-get 'lastName creator)
                                       (alist-get 'name creator)
                                       "")))
         (authors (if authors authors
                    (cl-loop for creator in creators
                             collect (or (alist-get 'lastName creator)
                                         (alist-get 'name creator)
                                         "")))))
    (cond
     ((null authors) "Unknown")
     ((= (length authors) 1) (car authors))
     ((= (length authors) 2) (format "%s & %s" (car authors) (cadr authors)))
     (t (format "%s et al." (car authors))))))

(defun my-zotero--format-year (date)
  "Extract a 4-digit year from DATE string or number."
  (let ((date-str (cond ((stringp date) date)
                        ((numberp date) (number-to-string date))
                        (t ""))))
    (if (string-match "\\([0-9]\\{4\\}\\)" date-str)
        (match-string 1 date-str)
      "")))

(defun my-zotero--normalize-top-item (item)
  "Extract key and citation string from top-level ITEM."
  (let* ((data (my-zotero--data item))
         (key (or (alist-get 'key data) (alist-get 'key item) ""))
         (creators (alist-get 'creators data))
         (date (alist-get 'date data))
         (author (my-zotero--format-creators creators))
         (year (my-zotero--format-year date)))
    (when (not (string-empty-p key))
      (cons key (if (string-empty-p year)
                    author
                  (format "%s, %s" author year))))))

(defun my-zotero--normalize-attachment (item)
  "Convert Zotero attachment ITEM into a completion plist."
  (let* ((data (my-zotero--data item))
         (key (or (alist-get 'key data) (alist-get 'key item) ""))
         (filename (or (alist-get 'filename data)
                       (alist-get 'title data)
                       ""))
         (parent-key (or (alist-get 'parentItem data) ""))
         (content-type (or (alist-get 'contentType data) "")))
    (when (and (not (string-empty-p key))
               (or (string-suffix-p ".pdf" filename t)
                   (string= content-type "application/pdf")))
      (list :type 'pdf
            :label filename
            :attachment-key key
            :parent-key parent-key
            :pdf-name filename))))

(defun my-zotero--normalize-annotation (item)
  "Convert Zotero annotation ITEM into a completion plist."
  (let* ((data (my-zotero--data item))
         (text
          (string-trim
           (or (alist-get 'annotationText data) "")))
         (comment
          (string-trim
           (or (alist-get 'annotationComment data) "")))
         (page
          (format "%s"
                  (or (alist-get 'annotationPageLabel data) "")))
         (attachment-key
          (or (alist-get 'parentItem data) ""))
         (annotation-key
          (or (alist-get 'key data)
              (alist-get 'key item)
              "")))
    (unless (and (string-empty-p comment)
                 (string-empty-p text))
      (list :type 'annotation
            :comment comment
            :text text
            :page page
            :attachment-key attachment-key
            :annotation-key annotation-key))))

(defun my-zotero--save-cache ()
  "Save current in-memory cache and formatted candidates to disk."
  (when (> (hash-table-count my-zotero--candidate-table) 0)
    (condition-case err
        (with-temp-file my-zotero-cache-file
          (let ((print-length nil)
                (print-level nil)
                ;; Serialize the candidate table as a lightweight association list
                (candidate-alist (cl-loop for k being the hash-keys of my-zotero--candidate-table
                                          using (hash-values v)
                                          collect (cons k v))))
            (insert ";;; -*- lexical-binding: t; -*-\n")
            (prin1 (list :time my-zotero-annotations-cache-time
                         :raw-data my-zotero-annotations-cache
                         :candidate-alist candidate-alist)
                   (current-buffer))))
      (error
       (message "Failed to save Zotero cache to disk: %s"
                (error-message-string err))))))

(defun my-zotero--load-cache ()
  "Attempt to load pre-built candidates directly from cache file.

Returns non-nil if loaded successfully."
  (when (file-exists-p my-zotero-cache-file)
    (condition-case err
        (with-temp-buffer
          (insert-file-contents my-zotero-cache-file)
          (goto-char (point-min))
          (let ((loaded (read (current-buffer))))
            (setq my-zotero-annotations-cache-time (plist-get loaded :time)
                  my-zotero-annotations-cache (plist-get loaded :raw-data))
            ;; Populate the hash-table instantly using the pre-formatted alist
            (clrhash my-zotero--candidate-table)
            (dolist (pair (plist-get loaded :candidate-alist))
              (puthash (car pair) (cdr pair) my-zotero--candidate-table))
            t))
      (error
       (message "Failed to load Zotero cache from disk: %s"
                (error-message-string err))
       nil))))

(defun my-zotero-annotations-refresh ()
  "Refresh the annotation, PDF, and citation cache from Zotero Desktop."
  (interactive)
  (let* ((annotation-items (my-zotero--read-json-url (my-zotero--api-url "annotation")))
         (attachment-items (my-zotero--read-json-url (my-zotero--api-url "attachment")))
         (top-items (my-zotero--read-json-url (my-zotero--top-items-url)))
         (top-map (make-hash-table :test #'equal))
         (attachment-map (make-hash-table :test #'equal)))
    (dolist (item top-items)
      (when-let ((normalized (my-zotero--normalize-top-item item)))
        (puthash (car normalized) (cdr normalized) top-map)))
    (let ((pdfs (delq nil
                      (mapcar (lambda (item)
                                (when-let ((normalized (my-zotero--normalize-attachment item)))
                                  (let* ((parent-key (plist-get normalized :parent-key))
                                         (citation (gethash parent-key top-map "Unknown Citation")))
                                    (plist-put normalized :citation citation)
                                    (puthash (plist-get normalized :attachment-key)
                                             citation
                                             attachment-map)
                                    normalized)))
                              attachment-items)))
          (annotations (delq nil
                             (mapcar (lambda (item)
                                       (when-let ((normalized (my-zotero--normalize-annotation item)))
                                         (let* ((att-key (plist-get normalized :attachment-key))
                                                (citation (gethash att-key attachment-map "Unknown Citation")))
                                           (plist-put normalized :citation citation))
                                         normalized))
                                     annotation-items))))
      (setq my-zotero-annotations-cache (append pdfs annotations)
            my-zotero-annotations-cache-time (current-time))
      ;; Generate string keys during refresh *only*
      (my-zotero--build-candidates)
      (my-zotero--save-cache)
      (when (called-interactively-p 'interactive)
        (message "Loaded %d PDFs and %d Zotero annotations with citation metadata"
                 (length pdfs) (length annotations)))
      my-zotero-annotations-cache)))

(defun my-zotero-annotations-clear-cache ()
  "Clear cached Zotero annotations from memory and disk."
  (interactive)
  (setq my-zotero-annotations-cache nil
        my-zotero-annotations-cache-time nil)
  (clrhash my-zotero--candidate-table)
  (when (file-exists-p my-zotero-cache-file)
    (condition-case nil
        (delete-file my-zotero-cache-file)
      (error nil)))
  (message "Cleared Zotero annotation cache (memory and disk)"))

(defun my-zotero--one-line (string)
  "Collapse whitespace in STRING to a single line."
  (replace-regexp-in-string
   "[[:space:]\n\r]+" " " (string-trim (or string ""))))

(defun my-zotero--preferred-text (annotation)
  "Return ANNOTATION's comment, falling back to highlighted text."
  (let ((comment (plist-get annotation :comment))
        (text (plist-get annotation :text)))
    (if (string-empty-p comment)
        text
      comment)))

(defun my-zotero--truncate (string width)
  "Return STRING truncated to WIDTH columns."
  (truncate-string-to-width string width nil nil "…"))

(defun my-zotero--candidate-label (item index)
  "Create a unique completion label for ITEM and INDEX."
  (let ((type (plist-get item :type)))
    (if (eq type 'pdf)
        (format "%s  #%d"
                (plist-get item :citation)
                index)
      (let ((body (my-zotero--preferred-text item))
            (page (plist-get item :page)))
        (format "%s%s  #%d"
                (my-zotero--truncate (my-zotero--one-line body) 40)
                (if (string-empty-p page)
                    ""
                  (format "  [p. %s]" page))
                index)))))

(defun my-zotero--build-candidates ()
  "Build completion candidates from the current cache."
  (clrhash my-zotero--candidate-table)
  (cl-loop
   for item in my-zotero-annotations-cache
   for index from 1
   for candidate = (my-zotero--candidate-label item index)
   do (puthash candidate item my-zotero--candidate-table))
  (hash-table-keys my-zotero--candidate-table))

(defun my-zotero--candidate-annotation (candidate)
  "Return a short annotation suffix for CANDIDATE."
  (when-let* ((clean-candidate (substring-no-properties candidate))
              (item (gethash clean-candidate my-zotero--candidate-table))
              (type (plist-get item :type)))
    (if (eq type 'pdf)
        (format "  [%s]" (my-zotero--truncate (plist-get item :pdf-name) 40))
      (let ((citation (plist-get item :citation)))
        (unless (string-empty-p citation)
          (format "  [%s]" citation))))))

(defun my-zotero--completion-table (candidates)
  "Return a completion table around CANDIDATES for `completing-read'."
  (lambda (string pred action)
    (if (eq action 'metadata)
        '(metadata
          (category . zotero-annotation)
          (annotation-function . my-zotero--candidate-annotation)
          (display-sort-function . identity)
          (cycle-sort-function . identity))
      (complete-with-action action candidates string pred))))

(defun my-zotero--inserted-text (item)
  "Format ITEM as a Markdown link."
  (let ((type (plist-get item :type))
        (attachment-key (plist-get item :attachment-key)))
    (if (eq type 'pdf)
        (let ((citation (plist-get item :citation)))
          (format "[%s](zotero://open-pdf/library/items/%s)"
                  citation
                  attachment-key))
      (let ((label (my-zotero--preferred-text item))
            (page (plist-get item :page)))
        (if (string-empty-p page)
            (format "[%s](zotero://open-pdf/library/items/%s)"
                    label
                    attachment-key)
          (format "[%s](zotero://open-pdf/library/items/%s?page=%s)"
                  label
                  attachment-key
                  page))))))

;;;###autoload
(defun my-zotero-insert-annotation ()
  "Select a Zotero annotation or PDF using minibuffer completion and insert it.

Bypasses formatting calculations entirely if cached data is already on disk."
  (interactive)
  ;; Only trigger loading if the candidate hash-table is empty.
  (unless (> (hash-table-count my-zotero--candidate-table) 0)
    (unless (my-zotero--load-cache)
      (condition-case err
          (my-zotero-annotations-refresh)
        (error
         (user-error "Failed to retrieve data from Zotero: %s"
                     (error-message-string err))))))
  (let* ((candidates (hash-table-keys my-zotero--candidate-table))
         (table (my-zotero--completion-table candidates))
         (choice (completing-read "Zotero item: " table nil t))
         (item (gethash (substring-no-properties choice) my-zotero--candidate-table)))
    (when item
      (insert (my-zotero--inserted-text item)))))

(provide 'zotero-completion)
;;; zotero-completion.el ends here
