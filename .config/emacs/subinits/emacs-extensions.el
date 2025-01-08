;; -*- lexical-binding: t -*-
;; don't pop up buffer for compilation warnings
(setq native-comp-async-report-warnings-errors 'silent)

;; carry history variables across sessions
(savehist-mode)

;; set up default browser
(setq browse-url-generic-program "qutebrowser")
(setq browse-url-browser-function 'browse-url-generic)

;; ewwwwwwwwwwwwwwwwwww settings
(use-package eww
  :general
  (:keymaps         'override
   "<f1>"           'eww
   "S-<f1>"         (general-l (°split-window-and-do (call-interactively 'eww))))
  :config
  (evil-collection-eww-setup))

;; spellchecking settings
(setq ispell-program-name "hunspell")
(defvar °ispell-dicts-in-use
  '("de_DE" "en_AU")
  "List of dicts to cycle through by using °ispell-cycle-dicts.")

;; use more conservative sentence definition
(setq sentence-end-double-space nil)

;; tramp settings
(setq tramp-default-method "ssh")
(add-hook 'find-file-hook
          (lambda ()
            (when (file-remote-p default-directory)
              (°source-ssh-env))))

;; use pass or an encrypted file for auth-sources
(use-package auth-source-pass
  :config
  (auth-source-pass-enable))

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
  :general-config
  (:states          'motion
   "M-H"            'helpful-kill-buffers)
  (:keymaps         'helpful-mode-map
   :states          'normal
   "q"              'delete-window)
  :config
  (evil-collection-helpful-setup)
  (setq helpful-switch-buffer-function #'°display-buffer-pop-up-if-not-helpful)
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
  :init
  (setq vterm-shell (concat "/" (°join-path nil "usr" "bin" "fish") " -C __vterm_setup"))
  ;; use locally installed package (from AUR) of emacs-vterm
  :straight nil
  :general
  (:keymaps         'override
   :states          '(motion emacs)
   "C-¼"            '°vterm)
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


(provide 'emacs-extensions)
