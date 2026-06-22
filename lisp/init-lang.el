;;; init-lang.el --- Programming languages, math editing & markdown -*- lexical-binding: t; -*-

;; Markdown Setup
(use-package markdown-mode
  :mode ("\\.md\\'" . markdown-mode)
  :custom
  (markdown-enable-math t)
  :config
  (setq markdown-regex-escape nil))

;; Hide URL
(with-eval-after-load 'markdown-mode
  (let ((link-hiding-rules
         `((,markdown-regex-link-inline
            (2 '(face nil display "") prepend)   ; Hide [
            (4 '(face nil display "") prepend)   ; Hide ]
            (5 '(face nil display "") prepend)   ; Hide (
            (6 '(face nil display "") prepend)   ; Hide URL
            (7 '(face nil display "") prepend t) ; Hide optional title
            (8 '(face nil display "") prepend))))) ; Hide )
    (font-lock-add-keywords 'markdown-mode link-hiding-rules)))

(defun my-markdown-in-math-p ()
  "Return non-nil if cursor is inside LaTeX math delimiters ($...$ or $$...$$)."
  (when (require 'texmathp nil t)
    (texmathp)))

(use-package auctex
  :defer t)

;; LaTeX Math completion for Markdown Mode (AUCTeX Enabled)
(defvar my-latex-math-symbols nil
  "Cached list of LaTeX math symbols populated dynamically from AUCTeX.")

(defun my-get-latex-math-symbols ()
  "Retrieve the complete list of LaTeX math symbols, combining AUCTeX and custom lists."
  (or my-latex-math-symbols
      (setq my-latex-math-symbols
            (let (syms)
              (when (boundp 'my-latex-operator-symbols-list)
                (setq syms (append my-latex-operator-symbols-list syms)))
              (delete-dups syms)))))

(defun my-markdown-latex-math-capf ()
  "Completion-at-point function for LaTeX math in `markdown-mode`."
  (when (and (derived-mode-p 'markdown-mode)
             (fboundp 'texmathp)
             (texmathp))
    (let* ((bounds (bounds-of-thing-at-point 'symbol))
           (start (or (car bounds) (point)))
           (end (or (cdr bounds) (point)))
           ;; Populate candidates dynamically from the cached AUCTeX list
           (candidates (my-get-latex-math-symbols)))
      (list start end candidates
            :exclusive 'no
            :company-kind (lambda (_) 'function)
	    :annotation-function (lambda (cand) " Tex")
            :exit-function
            (lambda (str status)
              (when (memq status '(finished sole))
                (save-excursion
                  (goto-char (- (point) (length str)))
                  (unless (eq (char-before) ?\\)
                    (insert "\\")))))))))

;; Ensure AUCTeX is loaded when markdown-mode loads
(with-eval-after-load 'markdown-mode
  (require 'texmathp)
  (require 'latex) ; Force-loads AUCTeX's LaTeX module to define LaTeX-math-default
  (add-hook 'markdown-mode-hook
            (lambda ()
              (add-to-list 'completion-at-point-functions #'my-markdown-latex-math-capf))))

;; LaTeX and CDLaTeX Setup
(use-package cdlatex
  :hook (markdown-mode . cdlatex-mode)
  :custom
  (cdlatex-sub-super-scripts-outside-math-mode nil)
  (cdlatex-math-symbol-prefix ?\;)
  (cdlatex-paired-parens "$([{")
  :config
  (defun my-cdlatex-markdown-tab-hook ()
    "Handle TAB with `markdown-cycle` when outside math mode."
    (when (and (derived-mode-p 'markdown-mode)
               (not (my-markdown-in-math-p)))
      (call-interactively #'markdown-cycle)
      t))

  (defun my-cdlatex-delete-empty-sub-super ()
    "Delete empty `^{}` or `_{}` when pressing TAB inside them."
    (when (and (>= (point) 3)
               (eq (char-after) ?})
               (eq (char-before) ?{)
               (memq (char-before (1- (point))) '(?^ ?_)))
      (delete-char 1)
      (delete-char -2)
      t))

  (add-hook 'cdlatex-tab-hook #'my-cdlatex-delete-empty-sub-super)

  (defun my-cdlatex-math-modify-only-in-math (arg)
    "Call `cdlatex-math-modify' if inside math, otherwise insert single quote."
    (interactive "P")
    (if (and (derived-mode-p 'markdown-mode)
             (not (my-markdown-in-math-p)))
        (self-insert-command (prefix-numeric-value arg))
      (cdlatex-math-modify arg)))

  (define-key cdlatex-mode-map "'" #'my-cdlatex-math-modify-only-in-math))

(with-eval-after-load 'cdlatex
  (add-to-list 'cdlatex-math-modify-alist '(?s "\\mathscr" nil t nil nil))
  (add-to-list 'cdlatex-math-modify-alist '(?a "\\mathbb" nil t nil nil))

  (add-to-list 'cdlatex-math-symbol-alist '(?x ("\\xi")))
  (add-to-list 'cdlatex-math-symbol-alist '(?c ("\\chi")))
  (add-to-list 'cdlatex-math-symbol-alist '(?i ("\\iota")))
  (add-to-list 'cdlatex-math-symbol-alist '(?I ("\\in")))
  (add-to-list 'cdlatex-math-symbol-alist '(?< ("\\langle")))
  (add-to-list 'cdlatex-math-symbol-alist '(?> ("\\rangle")))
  (add-to-list 'cdlatex-math-symbol-alist '(?w ("\\omega")))

  (let ((new-commands
         '(("mk" "Insert inline math" "\\\(?\\\)" cdlatex-position-cursor nil t nil)
           ("dm" "Insert display math" "\\\[?\\\]" cdlatex-position-cursor nil t nil)
           ("alid" "Aligned" "\\begin{aligned}\n  ?\n\\end{aligned}" cdlatex-position-cursor nil nil t)
           ("set" "Insert literal curly braces" "\\{?\\}" cdlatex-position-cursor nil nil t))))

    (dolist (cmd new-commands)
      (add-to-list 'cdlatex-command-alist cmd)))

  (cdlatex-compute-tables))

(defun my-cdlatex-dollar-double-display (orig-fun &rest args)
  "If typed twice sequentially, expand inline math `$|$` to display math `$$|$$`."
  (if (and (not (car args))
           (eq last-command 'cdlatex-dollar)
           (eq (char-before) ?$)
           (eq (char-after) ?$))
      (progn
        (delete-char 1)
        (insert "$$$")
        (forward-char -2))
    (apply orig-fun args)))

(advice-add 'cdlatex-dollar :around #'my-cdlatex-dollar-double-display)

;; Prettify Symbols Setup
(defun my-latex-prettify-symbols-compose-p (start end match)
  "Predicate to determine if MATCH should be prettified."
  (let ((next-char (char-after end))
        (prev-char (char-before start)))
    (if (string-prefix-p "\\" match)
        (and (or (not prev-char) (not (= prev-char ?\\)))
             (or (not (string-match-p "[a-zA-Z]$" match))
                 (not (and next-char (string-match-p "[a-zA-Z]" (char-to-string next-char))))))
      (or (and (fboundp 'texmathp)
               (save-excursion
                 (goto-char start)
                 (texmathp)))
          (or (and next-char (string-match-p "[[:digit:]()[:punct:][:space:]]" (char-to-string next-char)))
              (and prev-char (string-match-p "[[:digit:]()[:punct:][:space:]]" (char-to-string prev-char)))
              (prettify-symbols-default-compose-p start end match))))))

(defun my-setup-math-prettify-symbols ()
  "Register LaTeX, amssymb, math fonts, and sub/superscript prettifications."
  ;; Defer loading the large list of symbols until this hook executes
  (require 'my-latex-prettify-symbols nil t)
  (setq-local prettify-symbols-compose-predicate #'my-latex-prettify-symbols-compose-p)
  (setq-local prettify-symbols-alist my-latex-prettify-symbols-alist)
  (prettify-symbols-mode 1))

(setq-default prettify-symbols-unprettify-at-point t)
(add-hook 'markdown-mode-hook #'my-setup-math-prettify-symbols)

;; My mathjax preview mode
(add-hook 'markdown-mode-hook (lambda () (mathjax-preview-mode 1)))

(provide 'init-lang)
;;; init-lang.el ends here
