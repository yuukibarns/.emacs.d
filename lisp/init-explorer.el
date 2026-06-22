;;; init-explorer.el --- File managers (Dired & Dirvish) -*- lexical-binding: t; -*-

(use-package nerd-icons)

(use-package dirvish
  :init
  (dirvish-override-dired-mode 1)
  :config
  (setq dirvish-attributes
        '(vc-state subtree-state nerd-icons collapse file-size))
  (setq dirvish-subtree-state-style 'nerd))

(require 'dired-x)

(setq dired-omit-files
      (concat dired-omit-files "\\|^\\..+$"))

(add-hook 'dired-mode-hook #'dired-omit-mode)

(with-eval-after-load 'dired
  (evil-define-key 'normal dired-mode-map
    (kbd "g.") #'dired-omit-mode))

(provide 'init-explorer)
;;; init-explorer.el ends here
