;;; init-lsp.el --- Language Server Client integration -*- lexical-binding: t; -*-

;; Increase memory threshold to 100MB to prevent frequent GC pauses
(setq gc-cons-threshold 100000000)

;; Readjust it when Emacs is idle
(setq read-process-output-max (* 1024 1024)) ;; 1mb

(add-to-list 'auto-mode-alist '("\\.lua\\'" . lua-ts-mode))
(add-to-list 'auto-mode-alist '("\\.rs\\'" . rust-ts-mode))

(add-to-list 'major-mode-remap-alist '(python-mode . python-ts-mode))
(add-to-list 'major-mode-remap-alist '(c-mode . c-ts-mode))
(add-to-list 'major-mode-remap-alist '(c++-mode . c++-ts-mode))
(add-to-list 'major-mode-remap-alist '(js-mode . js-ts-mode))

(add-hook 'prog-mode-hook #'hs-minor-mode)

(use-package eglot
  :ensure nil
  :hook
  ((python-ts-mode . eglot-ensure)
   (rust-ts-mode . eglot-ensure)
   (c-ts-mode . eglot-ensure)
   (c++-ts-mode . eglot-ensure)
   (lua-ts-mode . eglot-ensure)
   (js-ts-mode . eglot-ensure)
   )
  :config
  (add-hook 'eglot-managed-mode-hook
            (lambda ()
              (add-hook 'before-save-hook #'eglot-format-buffer nil t))))

(with-eval-after-load 'eglot
  (add-to-list 'eglot-server-programs '((python-mode python-ts-mode python-base-mode) . ("ty" "server")))
)

(use-package mason
  :ensure t
  :config
  (mason-setup))

(provide 'init-lsp)
;;; init-lsp.el ends here
