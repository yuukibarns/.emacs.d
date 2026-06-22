;;; init-evil.el --- Vim emulation setup -*- lexical-binding: t; -*-

(use-package evil
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-vsplit-window-right t)
  (setq evil-split-window-below t)
  (setq evil-want-C-u-scroll t)
  (setq evil-want-C-i-jump t)
  (setq evil-ex-complete-emacs-commands t)
  (setq evil--jumps-buffer-targets "\\*\\(new\\|scratch\\|eww.*\\)\\*")

  :custom
  (evil-undo-system 'undo-fu)

  :config
  (evil-mode 1)

  ;; Normal/Insert map overrides
  (define-key evil-normal-state-map (kbd "C-s") #'save-buffer)
  (define-key evil-insert-state-map (kbd "C-s") #'save-buffer)
  (define-key evil-normal-state-map (kbd "-") #'dired-jump)

  ;; Better visual line movement
  (define-key evil-motion-state-map (kbd "j") 'evil-next-visual-line)
  (define-key evil-motion-state-map (kbd "k") 'evil-previous-visual-line)

  ;; Tab manipulation in Evil
  (define-key evil-normal-state-map (kbd "C-t") 'tab-new)
  (define-key evil-normal-state-map (kbd "C-q") 'evil-quit)

  ;; Bind Ctrl-Backspace in Insert State
  (define-key evil-insert-state-map (kbd "<C-backspace>") #'evil-delete-backward-word)
  (define-key evil-insert-state-map (kbd "C-<backspace>") #'evil-delete-backward-word)

  ;; Fallback Emacs states
  (dolist (mode '(custom-mode eshell-mode term-mode))
    (add-to-list (quote evil-emacs-state-modes) mode)))

(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

(use-package evil-surround
  :after evil
  :config
  (global-evil-surround-mode 1))

(use-package evil-commentary
  :ensure t
  :after evil
  :config
  (evil-commentary-mode))

(provide 'init-evil)
;;; init-evil.el ends here
