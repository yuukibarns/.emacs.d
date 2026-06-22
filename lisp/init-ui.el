;;; init-ui.el --- Look & Feel, Basic Keybinds -*- lexical-binding: t; -*-

(set-face-attribute 'default nil :height 105)

(defun my/increase-opacity ()
  "Increase the background opacity (make it less transparent)."
  (interactive)
  (let* ((current (or (frame-parameter nil 'alpha-background) 100))
         (new (min 100 (+ current 5))))
    (set-frame-parameter nil 'alpha-background new)
    (setf (alist-get 'alpha-background default-frame-alist) new)
    (message "Background opacity: %d%%" new)))

(defun my/decrease-opacity ()
  "Decrease the background opacity (make it more transparent)."
  (interactive)
  (let* ((current (or (frame-parameter nil 'alpha-background) 100))
         ;; Keep it at least 10% opaque so the window doesn't completely vanish
         (new (max 10 (- current 5))))
    (set-frame-parameter nil 'alpha-background new)
    (setf (alist-get 'alpha-background default-frame-alist) new)
    (message "Background opacity: %d%%" new)))

(global-set-key (kbd "C-M-=") 'my/increase-opacity)
(global-set-key (kbd "C-M--") 'my/decrease-opacity)

;; Hide interface bars
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

;; Interface configurations
(setq display-line-numbers-type 'relative)
(global-display-line-numbers-mode 1)
(column-number-mode 1)
(setq column-number-indicator-zero-based nil)

(recentf-mode 1)
(setq recentf-max-saved-items 200)

(use-package which-key
  :config
  (which-key-mode))

;; Tab bar
(tab-bar-mode 1)

;; Scaling keys
(global-set-key (kbd "C-=") #'text-scale-increase)
(global-set-key (kbd "C--") #'text-scale-decrease)

;; Basic Global Keybindings
(global-set-key (kbd "C-s") #'save-buffer)
(global-set-key (kbd "<C-backspace>") #'backward-kill-word)
(global-set-key (kbd "C-<backspace>") #'backward-kill-word)

(global-set-key
 (kbd "<f5>")
 (lambda ()
   (interactive)
   (load-file user-init-file)))

;; Themes
(load-theme 'modus-vivendi-tinted t)
(setopt modus-themes-to-toggle '(modus-operandi-tinted modus-vivendi-tinted))

(provide 'init-ui)
;;; init-ui.el ends here
