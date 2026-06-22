;;; mathjax-preview.el --- Live preview of MathJax formulas -*- lexical-binding: t; -*-

(require 'mathjax)
(require 'posframe nil t) ; Try to load posframe silently

(defgroup mathjax-preview nil
  "Live preview options for MathJax formulas."
  :group 'text
  :prefix "mathjax-preview-")

(defcustom mathjax-preview-debounce-delay 0.3
  "Time in seconds of idle time to wait before updating the preview."
  :type 'number
  :group 'mathjax-preview)

(defcustom mathjax-preview-inline-popup t
  "If non-nil, display inline math previews in a floating child-frame.
If nil, display the inline math preview inline after the formula."
  :type 'boolean
  :group 'mathjax-preview)

(defvar-local mathjax-preview--timer nil
  "The idle timer used to debounce render requests.")

(defvar-local mathjax-preview--active-overlays nil
  "List of mathjax-preview overlays currently active (expanded) under point.")

(defvar mathjax-preview-mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "C-l") #'mathjax-preview-toggle-at-point)
    map)
  "Keymap for `mathjax-preview-mode'.")

(defun mathjax-preview--inline-p (ov)
  "Return non-nil if overlay OV represents inline math."
  (let* ((options (overlay-get ov 'mathjax-preview-full-options))
         (has-display (plist-member options :display))
         (display (plist-get options :display)))
    (if has-display
        (not display) ; :display t means display math, so inline is nil
      ;; Fallback: check the actual opening delimiter
      (let* ((beg (overlay-start ov))
             (op-len (overlay-get ov 'mathjax-preview-op-len)))
        (if (and beg op-len)
            (let ((delim (buffer-substring-no-properties beg (+ beg op-len))))
              (or (string= delim "$")
                  (string= delim "\\(")))
          nil)))))

(defun mathjax-preview--show-popup (pos image &optional err)
  "Display IMAGE or ERR in a floating child frame near POS, respecting active theme colors."
  (when (and (display-graphic-p) (fboundp 'posframe-show) pos)
    (let* ((bg-color (face-attribute 'default :background nil 'current))
           (fg-color (face-attribute 'default :foreground nil 'current))
           (border-color (if err "red" fg-color))
           (content (if err
                       (propertize (format " Error: %s " err) 'face 'error)
                     (propertize " " 'display image))))
      (posframe-show " *mathjax-preview-popup*"
                     :string content
                     :position pos
                     :poshandler 'posframe-poshandler-point-bottom-left-corner
                     :background-color bg-color
                     :foreground-color fg-color   ; Explicitly set foreground as well
                     :internal-border-width 1
                     :internal-border-color border-color))))

(defun mathjax-preview--hide-popup ()
  "Hide the floating child frame."
  (when (fboundp 'posframe-hide)
    (posframe-hide " *mathjax-preview-popup*")))

(defun mathjax-preview--set-active (ov active)
  "Set the active state of overlay OV.
If ACTIVE is non-nil, show the LaTeX source.
If inline and popup is enabled, show the preview in the floating popup.
Otherwise, hide the source and show only the image."
  (let ((image (overlay-get ov 'mathjax-preview-image))
        (err (overlay-get ov 'mathjax-preview-error))
        (state (overlay-get ov 'mathjax-preview-state))
        (inline (mathjax-preview--inline-p ov))
        (start-pos (overlay-start ov)))
    (unless (eq state (if active 'active 'inactive))
      (cond
       (active
        (overlay-put ov 'mathjax-preview-state 'active)
        (overlay-put ov 'display nil)
        (overlay-put ov 'face nil) ; Restore original LaTeX syntax colors when active
        (cond
         (image
          (if (and inline mathjax-preview-inline-popup)
              (progn
                (overlay-put ov 'after-string nil)
                (mathjax-preview--show-popup start-pos image))
            (overlay-put ov 'after-string
                         (if inline
                             (propertize " " 'display image 'face 'default)
                           (concat "\n" (propertize " " 'display image 'face 'default) "\n")))))
         (err
          (if (and inline mathjax-preview-inline-popup)
              (progn
                (overlay-put ov 'after-string nil)
                (mathjax-preview--show-popup start-pos nil err))
            (overlay-put ov 'after-string
                         (if inline
                             (propertize (format " Error: %s " err) 'face 'error)
                           (concat "\n" (propertize (format "Error: %s" err) 'face 'error) "\n")))))
         (t
          (overlay-put ov 'after-string nil))))
       (t
        (overlay-put ov 'mathjax-preview-state 'inactive)
        (overlay-put ov 'face 'default) ; Force normal text color on the replacement image
        (when (and inline mathjax-preview-inline-popup)
          (mathjax-preview--hide-popup))
        (cond
         (image
          (overlay-put ov 'display image)
          (overlay-put ov 'after-string nil))
         (err
          ;; If there's an error, keep the text visible and show the error
          (overlay-put ov 'display nil)
          (overlay-put ov 'after-string
                       (if inline
                           (propertize (format " Error: %s " err) 'face 'error)
                         (concat "\n" (propertize (format "Error: %s" err) 'face 'error) "\n"))))
         (t
          (overlay-put ov 'display nil)
          (overlay-put ov 'after-string nil))))))))

(defun mathjax-preview--render-overlay (ov)
  "Asynchronously render the formula inside OV and update its display."
  (let* ((beg (overlay-start ov))
         (end (overlay-end ov)))
    (when (and beg end)
      (let* ((op-len (overlay-get ov 'mathjax-preview-op-len))
             (cl-len (overlay-get ov 'mathjax-preview-cl-len))
             (math-str (buffer-substring-no-properties (+ beg op-len) (- end cl-len)))
             (fmt (overlay-get ov 'mathjax-preview-format))
             (opts (overlay-get ov 'mathjax-preview-options))
             (buffer (current-buffer))
             (req-id (1+ (or (overlay-get ov 'mathjax-preview-counter) 0))))
        (overlay-put ov 'mathjax-preview-counter req-id)
        (overlay-put ov 'mathjax-preview-math-str math-str)
        (mathjax-render
         (lambda (data)
           (when (and (buffer-live-p buffer)
                      (overlay-buffer ov)
                      (= req-id (overlay-get ov 'mathjax-preview-counter)))
             (with-current-buffer buffer
               (let (image err)
                 (if-let ((svg (alist-get 'svg data)))
                     (let* ((h (and (string-match "height=\"\\([-.0-9]+\\)" svg)
                                    (string-to-number (match-string 1 svg))))
                            (va (and (string-match "vertical-align: \\([-.0-9]+\\)" svg)
                                     (string-to-number (match-string 1 svg))))
                            (ascent (if (and h va) (round (* 100 (+ va h) (/ h))) 100)))
                       (setq image (svg-image svg :ascent ascent)))
                   (setq err (alist-get 'error data)))
                 (overlay-put ov 'mathjax-preview-image image)
                 (overlay-put ov 'mathjax-preview-error err)
                 ;; Force a visual refresh of the state
                 (let ((state (overlay-get ov 'mathjax-preview-state)))
                   (overlay-put ov 'mathjax-preview-state nil)
                   (mathjax-preview--set-active ov (eq state 'active)))))))
         math-str :format fmt :options opts)))))

(defun mathjax-preview--update-all ()
  "Update all mathjax-preview overlays based on the current point and text edits."
  (let* ((pos (point))
         (all-at-point (overlays-at pos))
         (current-ovs nil))
    
    ;; Filter overlays at point
    (dolist (ov all-at-point)
      (when (eq (overlay-get ov 'category) 'mathjax-preview)
        (push ov current-ovs)))

    ;; If inside a formula but no overlay exists yet, create one dynamically.
    (unless current-ovs
      (let* ((searchfn (if (functionp mathjax-delimiters)
                           mathjax-delimiters
                         (mathjax--math-searchfn mathjax-delimiters)))
             (beg (save-excursion (backward-paragraph) (point)))
             (end (save-excursion (forward-paragraph) (point)))
             match found)
        (save-excursion
          (goto-char beg)
          (while (and (setq match (funcall searchfn end))
                      (not found))
            (pcase-let ((`(,ostart ,istart ,iend ,oend . ,options) match))
              (when (and (<= ostart pos) (>= oend pos))
                (setq found t)
                (let ((exists nil))
                  (dolist (ov (overlays-in ostart oend))
                    (when (eq (overlay-get ov 'category) 'mathjax-preview)
                      (setq exists t)))
                  (unless exists
                    (let* ((fmt (or (plist-get options :format) 'tex))
                           (opts (plist-get options :options))
                           (m-ostart (copy-marker ostart))
                           (m-oend (copy-marker oend))
                           (ov (make-overlay m-ostart m-oend (current-buffer) t)))
                      (overlay-put ov 'category 'mathjax-preview)
                      (overlay-put ov 'evaporate t)
                      (overlay-put ov 'mathjax-preview-op-len (- istart ostart))
                      (overlay-put ov 'mathjax-preview-cl-len (- oend iend))
                      (overlay-put ov 'mathjax-preview-format fmt)
                      (overlay-put ov 'mathjax-preview-options opts)
                      (overlay-put ov 'mathjax-preview-full-options options)
                      ;; Newly typed formulas start as active so they can be written live
                      (overlay-put ov 'mathjax-preview-state 'active)
                      (push ov current-ovs)
                      (push ov mathjax-preview--active-overlays)
                      (mathjax-preview--render-overlay ov)))))
              (goto-char oend))))))

    ;; Deactivate (collapse) overlays that are no longer under point
    (let ((new-active nil))
      (dolist (ov mathjax-preview--active-overlays)
        (if (and (overlay-buffer ov) (memq ov current-ovs))
            (push ov new-active)
          (when (overlay-buffer ov)
            (mathjax-preview--set-active ov nil))))
      (setq mathjax-preview--active-overlays new-active))

    ;; For overlays that are currently active and under point, check for edits
    (dolist (ov mathjax-preview--active-overlays)
      (let* ((beg (overlay-start ov))
             (end (overlay-end ov))
             (op-len (overlay-get ov 'mathjax-preview-op-len))
             (cl-len (overlay-get ov 'mathjax-preview-cl-len)))
        (when (and beg end)
          (let ((current-math (buffer-substring-no-properties (+ beg op-len) (- end cl-len)))
                (saved-math (overlay-get ov 'mathjax-preview-math-str)))
            (unless (string= current-math saved-math)
              (mathjax-preview--render-overlay ov))))))))

(defun mathjax-preview--post-command ()
  "Post-command hook for buffer-wide previews to queue updates."
  (when mathjax-preview--timer
    (cancel-timer mathjax-preview--timer))
  (let ((buf (current-buffer)))
    (setq mathjax-preview--timer
          (run-with-idle-timer mathjax-preview-debounce-delay nil
                               (lambda ()
                                 (when (buffer-live-p buf)
                                   (with-current-buffer buf
                                     (mathjax-preview--update-all))))))))

(defun mathjax-preview--buffer ()
  "Render all formulas in the buffer and collapse them into images."
  (mathjax-preview--clear-buffer)
  (let ((user-pos (point)))
    (save-excursion
      (goto-char (point-min))
      (let* ((searchfn (if (functionp mathjax-delimiters)
                           mathjax-delimiters
                         (mathjax--math-searchfn mathjax-delimiters)))
             (end (point-max))
             match)
        (while (setq match (funcall searchfn end))
          (pcase-let ((`(,ostart ,istart ,iend ,oend . ,options) match))
            (let* ((fmt (or (plist-get options :format) 'tex))
                   (opts (plist-get options :options))
                   (m-ostart (copy-marker ostart))
                   (m-oend (copy-marker oend))
                   (ov (make-overlay m-ostart m-oend (current-buffer) t)))
              (overlay-put ov 'category 'mathjax-preview)
              (overlay-put ov 'evaporate t)
              (overlay-put ov 'mathjax-preview-op-len (- istart ostart))
              (overlay-put ov 'mathjax-preview-cl-len (- oend iend))
              (overlay-put ov 'mathjax-preview-format fmt)
              (overlay-put ov 'mathjax-preview-options opts)
              (overlay-put ov 'mathjax-preview-full-options options)
              (if (and (>= user-pos ostart) (<= user-pos oend))
                  (progn
                    (overlay-put ov 'mathjax-preview-state 'active)
                    (push ov mathjax-preview--active-overlays))
                (overlay-put ov 'mathjax-preview-state 'inactive))
              (mathjax-preview--render-overlay ov))
            (goto-char oend)))))))

(defun mathjax-preview--clear-buffer ()
  "Remove all mathjax-preview overlays from the entire buffer."
  (dolist (ov (overlays-in (point-min) (point-max)))
    (when (eq (overlay-get ov 'category) 'mathjax-preview)
      (delete-overlay ov)))
  (setq mathjax-preview--active-overlays nil))

;;;###autoload
(defun mathjax-preview-toggle-at-point ()
  "Toggle the expansion of the MathJax formula overlay under the point.
If collapsed, expand to reveal the LaTeX source. If expanded, collapse
it back to the preview image."
  (interactive)
  (let* ((pos (point))
         (ovs (overlays-at pos))
         (found-ov nil))
    (dolist (ov ovs)
      (when (eq (overlay-get ov 'category) 'mathjax-preview)
        (setq found-ov ov)))
    (if found-ov
        (let ((state (overlay-get found-ov 'mathjax-preview-state)))
          (if (eq state 'active)
              (progn
                (mathjax-preview--set-active found-ov nil)
                (setq mathjax-preview--active-overlays
                      (delq found-ov mathjax-preview--active-overlays)))
            (mathjax-preview--set-active found-ov t)
            (push found-ov mathjax-preview--active-overlays)))
      (message "No MathJax formula under point."))))

;;;###autoload
(define-minor-mode mathjax-preview-mode
  "Toggle real-time, buffer-wide MathJax previews.
Formulas are replaced by preview images. Press `C-l` on a formula
to toggle its LaTeX source code, which updates live as you edit."
  :init-value nil
  :lighter " MJ-Prev"
  :keymap mathjax-preview-mode-map
  (if mathjax-preview-mode
      (progn
        (add-hook 'post-command-hook #'mathjax-preview--post-command nil t)
        (mathjax-preview--buffer)
        (message "MathJax buffer-wide preview enabled. Press C-l to show/edit source."))
    (remove-hook 'post-command-hook #'mathjax-preview--post-command t)
    (when mathjax-preview--timer
      (cancel-timer mathjax-preview--timer)
      (setq mathjax-preview--timer nil))
    (mathjax-preview--clear-buffer)
    (mathjax-preview--hide-popup)
    (message "MathJax buffer-wide preview disabled.")))

(provide 'mathjax-preview)

;;; mathjax-preview.el ends here
