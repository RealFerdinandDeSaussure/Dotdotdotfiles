;; -*- lexical-binding: t -*-
;; don't pop up buffer for compilation warnings
(setq native-comp-async-report-warnings-errors 'silent)

;; carry history variables across sessions
(savehist-mode)

;; set up default browser
(setq browse-url-generic-program "qutebrowser")
(setq browse-url-browser-function 'browse-url-generic)

;; spellchecking settings
(setq ispell-program-name "hunspell")
(defvar °ispell-dicts-in-use
  '("de_DE" "en_AU")
  "List of dicts to cycle through by using °ispell-cycle-dicts.")

;; use more conservative sentence definition
(setq sentence-end-double-space nil)

;; authentication/security settings
(use-package password-cache
  :straight (:type built-in)
  :defer t
  :custom
  (password-cache-expiry 3600 "Cache passwords for 60 minutes."))

;; use pass auth-sources
(use-package auth-source-pass
  :config
  (auth-source-pass-enable))

;; tramp settings
(use-package tramp
  :straight (:type built-in)
  :defer t
  :custom
  (tramp-default-method "ssh")
  (vc-ignore-remote t)
  (remote-file-name-inhibit-locks t)
  (vc-ignore-dir-regexp (format "%s\\|%s" vc-ignore-dir-regexp tramp-file-name-regexp))
  (remote-file-name-inhibit-locks t)
  (tramp-use-connection-share nil)
  :config
  (add-hook 'find-file-hook (lambda ()
                              (when (file-remote-p default-directory)
                                (°source-ssh-env)))))

;; ewwwwwwwwwwwwwwwwwww settings
(use-package eww
  :general
  (:keymaps         'override
   "<f1>"           'eww
   "S-<f1>"         (general-l (°split-window-and-do (call-interactively 'eww))))
  :config
  (evil-collection-eww-setup))

;; sexier builtin help
(use-package helpful
  :init
  (defun °helpful-previous-buffer ()
    (interactive)
    (let ((switch-to-prev-buffer-skip
           (lambda (window buffer bury-or-kill)
             (message (buffer-name buffer))
             (not (string-match-p "^*helpful" (buffer-name buffer))))))
      (call-interactively #'previous-buffer)
      (helpful-update)))
  :general
  (general-goleader
    :states         'motion
    "hx"            'helpful-at-point
    "hf"            'helpful-callable
    "hF"            'helpful-command
    "hv"            'helpful-variable
    "hk"            'helpful-key)
  (:keymaps         '(evil-ex-completion-map
                      evil-ex-search-keymapread-expression-map
                      minibuffer-local-map)
   "C-h k"          'helpful-key)
  :custom
  (helpful-switch-buffer-function #'°display-buffer-pop-up-if-not-helpful)
  :general-config
  (:states          'motion
   "M-H"            'helpful-kill-buffers)
  (:keymaps         'helpful-mode-map
   :states          'normal
   "q"              'delete-window)
  :config
  (evil-collection-helpful-setup)
  (defun °display-buffer-pop-up-if-not-helpful (buf)
    "Display BUF in current window if it is in helpful-mode. Pop up a new window
    otherwise."
    (let ((helpful-win nil))
      (walk-window-tree
       (lambda (win)
         (unless helpful-win
           (when (eq (buffer-local-value 'major-mode (window-buffer win)) 'helpful-mode)
             (setq helpful-win win)))))
    (if helpful-win
        (set-window-buffer helpful-win buf t)
      (display-buffer buf #'display-buffer-pop-up-window 0)))))

;; vimperator-style link-hints
(use-package link-hint
  :general
  (:states          'motion
   "C-l"            'link-hint-open-link
   "C-S-l"          'link-hint-copy-link))

;; use recentf mode to keep file visiting history
(use-package recentf
  :general
  (general-leader
    :states         'normal
    "rf"            'consult-recent-file)
  :init
  (recentf-mode))

(use-package restart-emacs
  :general
  (:keymaps         'override
   "M-<f12>"        'restart-emacs
   "S-M-<f12>"      (general-l
                      (shell-command "merge-configs")
                      (restart-emacs))))

(use-package pcre2el
  :after visual-regexp-steroids)

(use-package visual-regexp)

(use-package visual-regexp-steroids
  :general
  (general-goleader
    :states         'normal
    "C-s"           'vr/replace
    "C-S-s"         'vr/query-replace)
  :general-config
  (:keymaps         'vr/minibuffer-keymap
   "<escape>"       'minibuffer-keyboard-quit))

(use-package vterm
  ;; use locally installed package (from AUR) of emacs-vterm
  :straight nil
  :general
  (:keymaps         'override
   :states          '(motion emacs insert)
   "C-¼"            '°vterm)
  :custom
  (vterm-shell (concat "/" (file-name-concat "usr" "bin" "fish") " -C __vterm_setup"))
  :general-config
  (:states          'emacs
   :keymaps         'vterm-mode-map
   "C-h k"          'helpful-key
   "C-c $"          '°vterm)
  (:keymaps         'vterm-mode-map
   "M-:"            'eval-expression)

  :config
  (evil-collection-vterm-setup)

  (defun °vterm ()
    "Hide or show vterm window.
Start terminal if it isn't running already."
    (interactive)
    (let* ((vterm-buf "*vterm*")
           (vterm-win (get-buffer-window vterm-buf)))
      (if vterm-win
          (progn
            (select-window vterm-win)
            (delete-window))
        (if (get-buffer vterm-buf)
            (pop-to-buffer vterm-buf)
          (vterm-other-window)))))

  ;; delete vterm window on exit
  (add-hook 'vterm-exit-functions
            (lambda (buf event)
              (delete-window (get-buffer-window buf)))))


(use-package vertico
  :init
  (setq completion-ignore-case t
        read-buffer-completion-ignore-case t)
  (vertico-mode)
  :custom
  (read-file-name-completion-ignore-case t)
  :general-config
  (:keymaps         'vertico-map
    "M-k"           'previous-history-element
    "M-j"           'next-history-element)
  :config
  (evil-collection-vertico-setup))

(use-package embark
  :general
  (:keymaps         '(motion emacs evil-ex-completion-map
                             evil-ex-search-keymap read-expression-map
                             minibuffer-local-map)
   "C-,"            'embark-act
   "C-;"            'embark-dwim)
  :custom
  (embark-quit-after-action nil)
  :config
  (evil-collection-embark-setup))

(use-package consult
  :general
  (general-leader
    :keymaps        'normal
    "b"             '°consult-file-buffers
    "B"             'consult-buffer
    "I"             'consult-imenu
    "M"             'consult-flymake
    "g"             'consult-grep
    "G"             'consult-git-grep)
  :custom
  (completion-in-region-function #'consult-completion-in-region)
  :config
  (defvar °°consult--source-file-buffers
    (list :state #'consult--buffer-state
          :history 'buffer-name-history
          :items (lambda () (mapcar #'buffer-name (seq-filter #'buffer-file-name (buffer-list))))))

  (defun °consult-file-buffers ()
    "Consult menu to switch to file buffers only."
    (interactive)
    (consult-buffer '(°°consult--source-file-buffers)))

  (evil-collection-consult-setup))

(use-package marginalia
  :after vertico
  :config
  (marginalia-mode))

(use-package embark-consult
  :after (consult embark))

(use-package hotfuzz
  :defer t
  :init
  (setq completion-styles '(hotfuzz)))

(use-package xdg
  :straight (:type built-in)
  :commands xdg-user-dir)

(provide 'emacs-extensions)
