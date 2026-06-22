;;; init-tools.el --- Outer integrations, Git, Shells & AI -*- lexical-binding: t; -*-

;; Git Setup
(use-package magit
  :ensure t
  :bind ("C-x g" . magit-status))

(use-package diff-hl
  :ensure t
  :custom
  (diff-hl-show-staged-changes nil)
  :hook
  ((after-init . global-diff-hl-mode)
   (dired-mode . diff-hl-dired-mode))
  :config
  ;; Refresh signs after Magit operations such as stage, unstage, or commit.
  (with-eval-after-load 'magit
    (add-hook 'magit-post-refresh-hook
              #'diff-hl-magit-post-refresh))

  ;; Update signs while editing, rather than only after saving.
  (diff-hl-flydiff-mode 1))

;; Modern Ediff
(setq ediff-window-setup-function 'ediff-setup-windows-plain)
(setq ediff-split-window-function 'split-window-horizontally)

;; My Ediff (Buffer vs Index)
(defun my-ediff-current-buffer-with-git-index ()
  "Compare the current buffer with the version in the Git index using Ediff.

This command retrieves the staged version of the file from the Git index
via `git show :0:<file>`. It copies the content into a temporary buffer
using the same major mode, then starts an `ediff-buffers` session.
Upon quitting Ediff, the temporary buffer is automatically killed."
  (interactive)
  (let ((file (buffer-file-name)))
    (unless file
      (user-error "Current buffer is not visiting a file"))
    (let ((git-root (vc-git-root file)))
      (unless git-root
        (user-error "File is not in a Git repository"))
      (let* ((rel-file (file-relative-name file git-root))
             ;; Create a temporary buffer to hold the index version
             (index-buffer (get-buffer-create (format "*git-index: %s*" (file-name-nondirectory file))))
             (current-buf (current-buffer))
             (orig-mode major-mode))
        ;; Fetch and populate the index buffer
        (with-current-buffer index-buffer
          (let ((inhibit-read-only t)
                (default-directory git-root))
            (erase-buffer)
            ;; Run "git show :0:relative-path" synchronously
            (let ((exit-code (call-process "git" nil t nil "show" (concat ":0:" rel-file))))
              (if (/= exit-code 0)
                  (progn
                    (kill-buffer index-buffer)
                    (user-error "Could not retrieve '%s' from the Git index (is it untracked?)" rel-file))
                ;; Match the original major mode for syntax highlighting
                (funcall orig-mode)
                (set-buffer-modified-p nil)
                (setq buffer-read-only t)))))
        ;; Run ediff comparing the index buffer (A) with the current buffer (B)
        (ediff-buffers
         index-buffer
         current-buf
         ;; Startup hooks executed inside the Ediff Control Buffer context
         (list
          (lambda ()
            ;; Keep a local reference to the temporary index buffer
            (setq-local my-ediff-temp-index-buffer index-buffer)
            ;; Attach a buffer-local cleanup hook to kill the temp buffer upon quitting
            (add-hook 'ediff-cleanup-hook
                      (lambda ()
                        (when (buffer-live-p my-ediff-temp-index-buffer)
                          (kill-buffer my-ediff-temp-index-buffer)))
                      nil t))))))))

;; Terminal Emulator
(use-package vterm
  :ensure t
  :bind ("C-c t" . vterm)
  :hook (vterm-mode . (lambda () (display-line-numbers-mode -1)))
  :custom
  (vterm-max-scrollback 10000)
  (vterm-shell "/usr/bin/fish"))

(with-eval-after-load 'vterm
  (with-eval-after-load 'evil
    (evil-define-key 'insert vterm-mode-map (kbd "C-c") #'vterm--self-insert)
    (evil-define-key 'insert vterm-mode-map (kbd "C-x") #'vterm--self-insert)
    (evil-define-key 'insert vterm-mode-map (kbd "C-g") #'vterm--self-insert)
    (evil-define-key 'insert vterm-mode-map (kbd "<escape>") #'vterm--self-insert)

    (evil-define-key 'insert vterm-mode-map (kbd "C-\\") #'evil-normal-state)))

(with-eval-after-load 'vterm
  (add-to-list 'vterm-eval-cmds '("find-file-other-tab" find-file-other-tab)))

;; GPTel AI setup
(defun my/read-api-key-from-file (file-path)
  "Read the API key from FILE-PATH, trimming any whitespace or newlines."
  (let ((expanded-path (expand-file-name file-path)))
    (if (file-exists-p expanded-path)
        (with-temp-buffer
          (insert-file-contents expanded-path)
          (string-trim (buffer-string)))
      (message "Warning: API key file not found: %s" expanded-path)
      nil)))

(use-package gptel
  :custom
  (gptel-default-mode 'markdown-mode)
  :bind
  (("C-c c" . gptel)
   ("C-c g" . gptel-menu)
   ("C-c RET" . gptel-send)
   )
  :config
  (setq gptel-backend
        (gptel-make-deepseek "DeepSeek"
          :stream t
          :key (lambda () (my/read-api-key-from-file "~/.deepseek_api_key"))))

  (setq gptel-model 'deepseek-reasoner)
  (setq gptel-prompt-prefix-alist '((markdown-mode . "## 💬:\n\n")))
  (setq gptel-response-prefix-alist '((markdown-mode . "## 🤖:\n\n")))

  ;; 1. Open gptel in the current window
  (add-to-list 'display-buffer-alist
               '("\\*DeepSeek\\*" . (display-buffer-same-window)))

  ;; 2. Unbind RET and <return> from the base gptel minor mode map
  ;; (define-key gptel-mode-map (kbd "RET") nil)
  ;; (define-key gptel-mode-map (kbd "<return>") nil)

  ;; 3. Unbind RET and <return> from Evil-specific states in gptel-mode
  (with-eval-after-load 'evil
    (evil-define-key 'insert gptel-mode-map (kbd "RET") nil)
    (evil-define-key 'normal gptel-mode-map (kbd "RET") nil)
    (evil-define-key 'insert gptel-mode-map (kbd "<return>") nil)
    (evil-define-key 'normal gptel-mode-map (kbd "<return>") nil)))

(provide 'init-tools)
;;; init-tools.el ends here
