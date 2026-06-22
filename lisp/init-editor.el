;;; init-editor.el --- Core editing variables & paths -*- lexical-binding: t; -*-

;; Path settings helper
(defun my/add-to-path (path)
  "Expand PATH and prepend it to the system PATH env and Emacs exec-path."
  (let ((expanded (expand-file-name path)))
    (setenv "PATH" (concat expanded ":" (getenv "PATH")))
    (add-to-list 'exec-path expanded)))

;; Add binaries to PATH
(my/add-to-path "~/.local/bin")
(my/add-to-path "~/.nvm/versions/node/v22.12.0/bin")
(my/add-to-path "~/.cargo/bin")

;; Create folders if they don't exist
(make-directory (expand-file-name "backups/" user-emacs-directory) t)
(make-directory (expand-file-name "auto-saves/" user-emacs-directory) t)

;; Redirect backups (file~) to a central directory
(setq backup-directory-alist
      `(("." . ,(expand-file-name "backups/" user-emacs-directory))))

;; Redirect auto-saves (#file#) to a central directory
(setq auto-save-file-name-transforms
      `((".*" ,(expand-file-name "auto-saves/" user-emacs-directory) t)))

;; Prevent Emacs from creating lockfiles (.#file) in your project directories
(setq create-lockfiles nil)

;; Minibuffer utility
(add-hook 'minibuffer-setup-hook
          (lambda ()
            (local-set-key (kbd "C-v") #'yank)))

;; Undo limits
(setq undo-limit 67108864)        ; 64 MB
(setq undo-strong-limit 100663296) ; 96 MB
(setq undo-outer-limit 1006632960) ; 960 MB

(use-package undo-fu)

(use-package undo-fu-session
  :after undo-fu
  :config
  (setq undo-fu-session-directory
        (expand-file-name "undo-fu-session" user-emacs-directory))
  (undo-fu-session-global-mode 1))

;; General utility commands
(defun indent-buffer ()
  "Indent the entire buffer."
  (interactive)
  (indent-region (point-min) (point-max)))

(provide 'init-editor)
;;; init-editor.el ends here
