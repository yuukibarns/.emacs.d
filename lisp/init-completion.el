;;; init-completion.el --- In-buffer & minibuffer completions -*- lexical-binding: t; -*-

;; Enable auto-pairing globally
(electric-pair-mode 1)

(use-package orderless
  :ensure t
  :custom
  (completion-styles '(orderless basic))
  (completion-category-defaults nil)
  (completion-category-overrides
   '((file (styles partial-completion)))))

;; Tab priorities
(defun my-corfu-tab ()
  "Call `cdlatex-tab' or `org-cycle' if CDLaTeX is enabled, otherwise complete with Corfu."
  (interactive)
  (cond
   ((and (bound-and-true-p cdlatex-mode)
         (fboundp 'cdlatex-tab))
    (call-interactively #'cdlatex-tab))
   ((and (bound-and-true-p org-cdlatex-mode)
         (fboundp 'org-cycle))
    (call-interactively #'org-cycle))
   (t
    (call-interactively #'corfu-complete))))

;; Corfu Popups
(use-package corfu
  :ensure t
  :init
  (global-corfu-mode 1)
  :custom
  (corfu-auto t)
  (corfu-auto-delay 0.2)
  (corfu-auto-prefix 1)
  (corfu-cycle t)
  ;; (corfu-quit-at-boundary t)
  (corfu-quit-no-match 'separator)
  (global-corfu-minibuffer nil)
  :hook
  (minibuffer-setup . (lambda () (corfu-mode -1)))
  :bind
  (:map corfu-map
        ("TAB" . my-corfu-tab)
        ("<tab>" . my-corfu-tab)
        ("C-n" . corfu-next)
        ("C-p" . corfu-previous)))

(use-package kind-icon
  :ensure t
  :after corfu
  :custom
  (kind-icon-default-face 'corfu-default) ; to blend background colors correctly
  :config
  (add-to-list 'corfu-margin-formatters #'kind-icon-margin-formatter))

;; Disable the slow built-in ispell completion function
(setopt text-mode-ispell-word-completion nil)

(use-package cape
  :ensure t
  :init
  (setq cape-dict-file "/usr/share/dict/words")
  
  ;; Order matters: First item added goes to the front unless appended
  (add-to-list 'completion-at-point-functions #'cape-file)
  (add-to-list 'completion-at-point-functions #'cape-dabbrev)

  (defun my-cape-dict-conditional ()
    "Run `cape-dict' only in markdown-mode or inside code comments."
    (when (or (derived-mode-p 'markdown-mode)
              (nth 4 (syntax-ppss)))
      (cape-dict)))

  ;; Pushes this to the very bottom of the priority pool
  (add-to-list 'completion-at-point-functions #'my-cape-dict-conditional t))

;; Vertico UI
(use-package vertico
  :ensure t
  :init
  (vertico-mode 1)
  :custom
  (vertico-cycle t))

(use-package marginalia
  :ensure t
  :init
  (marginalia-mode 1))

(use-package savehist
  :init
  (savehist-mode 1))

;; Consult Pickers
(use-package consult
  :ensure t
  :bind (("C-x b" . consult-buffer)                
         ("C-x 4 b" . consult-buffer-other-window) 
         ("C-x 5 b" . consult-buffer-other-frame)  
         ("C-x r b" . consult-bookmark)            
         ("C-x p b" . consult-project-buffer)      

         ("M-y" . consult-yank-pop)                
         
         ("M-g g" . consult-goto-line)             
         ("M-g M-g" . consult-goto-line)           
         ("M-g o" . consult-outline)               
         ("M-g i" . consult-imenu)                 
         ("M-g I" . consult-imenu-multi)           

         ("M-s d" . consult-find)                  
         ("M-s D" . consult-locate)                
         ("M-s g" . consult-grep)                  
         ("M-s r" . consult-ripgrep)               
         ("M-s l" . consult-line)                  
         ("M-s L" . consult-line-multi)            
         ("M-s k" . consult-keep-lines)            
         ("M-s u" . consult-focus-lines)           

         :map isearch-mode-map
         ("M-e" . consult-isearch-history)         
         ("M-s l" . consult-line)                  
         ("M-s L" . consult-line-multi))           

  :init
  (setq register-preview-delay 0.5
        register-preview-function #'consult-register-format)
  (advice-add #'register-preview :override #'consult-register-window)

  :custom
  (completion-in-region-function #'consult-completion-in-region)
  (consult-preview-key 'any))

;; Embark Actions
(use-package embark
  :ensure t
  :bind
  (("C-." . embark-act)         
   ("C-;" . embark-dwim)        
   ("C-h B" . embark-bindings)) 

  :init
  (setq prefix-help-command #'embark-prefix-help-command))

(use-package embark-consult
  :ensure t
  :after (embark consult)
  :demand t 
  :hook
  (embark-collect-mode . consult-preview-at-point-mode))

(with-eval-after-load 'embark
  (keymap-set embark-file-map "t" #'find-file-other-tab)
  (keymap-set embark-buffer-map "t" #'switch-to-buffer-other-tab))

(with-eval-after-load 'evil
  (keymap-set evil-normal-state-map "C-." nil))

(use-package wgrep
  :ensure t
  :custom
  (wgrep-auto-save t))

(provide 'init-completion)
;;; init-completion.el ends here
