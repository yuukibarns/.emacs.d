;;; init.el --- Emacs Configuration Bootstrapper -*- lexical-binding: t; -*-

;; 1. Add the lisp/ directory to the load path so Emacs can find your files
(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))

;; 2. Core Foundation & Visuals
(require 'init-packages)                ; Load package manager/use-package first
(require 'init-ui)                      ; Set up themes, fonts, and basic UI

;; 3. Editor Behavior & Input
(require 'init-editor)                  ; Global editor tweaks, backups, etc.
(require 'init-evil)                    ; Set up your Evil-mode configuration

;; 4. Navigation & Interface
(require 'init-explorer)                ; File tree / sidebar layout
(require 'init-tools)                   ; Miscellaneous utilities (Git, terminal, etc.)

;; 5. Development & Language Setup
(require 'init-lsp)                     ; LSP client configuration
(require 'init-lang)                    ; Language-specific major modes

;; 6. Completion & Productivity Ecosystem
(require 'init-completion)              ; Minibuffer completion (Vertico/Corfu/etc.)
(require 'zotero-completion)            ; Academic research references completion

;; 7. Document Preparation & LaTeX Support
(require 'my-latex-prettify-symbols)    ; Custom math symbols formatting
(require 'mathjax-preview)              ; Real-time math equations preview

(with-eval-after-load 'markdown-mode
  (define-key markdown-mode-map (kbd "C-c z") #'my-zotero-insert-annotation))

(provide 'init)
;;; init.el ends here
