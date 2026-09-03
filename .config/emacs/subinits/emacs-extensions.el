;; -*- lexical-binding: t -*-
;; run garbage collector when idle
(run-with-idle-timer 1.2 t #'garbage-collect)
;; apart from that set the threshold pretty high
(setq gc-cons-threshold 100000000)
;; REMEMBER to get rid of these settings should the igc branch get merged

;; don't pop up buffer for compilation warnings
(setq native-comp-async-report-warnings-errors 'silent)

;; carry history variables across sessions
(savehist-mode)

;; set up default browser
(setq browse-url-generic-program    "qutebrowser"
      browse-url-browser-function   'browse-url-generic)

;; spellchecking settings
(setq ispell-program-name "hunspell")
(defvar +ispell-dicts-in-use
  '("de_DE" "en_AU")
  "List of dicts to cycle through by using +ispell-cycle-dicts.")

;; use more conservative sentence definition
(setq sentence-end-double-space nil)

;; clipboard settings
(setq save-interprogram-paste-before-kill t)

;; tree-sitter settings
(defvar +treesit-supported-languages
  '((bash sh-mode bash-ts-mode sh-mode-hook "https://github.com/tree-sitter/tree-sitter-bash")
    (go go-mode go-ts-mode go-mode-hook "https://github.com/tree-sitter/tree-sitter-go")
    (lua lua-mode lua-ts-mode lua-mode-hook "https://github.com/tree-sitter-grammars/tree-sitter-lua")
    (markdown markdown-mode markdown-ts-mode markdown-mode-hook "https://github.com/tree-sitter-grammars/tree-sitter-markdown")
    (python python-mode python-ts-mode python-mode-hook "https://github.com/tree-sitter/tree-sitter-python")
    (yaml yaml-mode yaml-ts-mode yaml-mode-hook "https://github.com/tree-sitter-grammars/tree-sitter-yaml")))

(setq treesit-language-source-alist
      (mapcar (lambda (x) (list (car x) (nth 4 x))) +treesit-supported-languages))

;; automatically switch to tree-sitter modes for all supported languages
(dolist (lang +treesit-supported-languages)
  (add-hook (nth 3 lang) #'+treesit-mode-switch))

;; get a more recent version of compat from ELPA in case any packages require it
(when (featurep 'compat)
  (unload-feature 'compat t))
(use-package compat
  :ensure (:source "ELPA"))

;; authentication/security settings
(use-package password-cache
  :ensure nil
  :defer t
  :custom
  (password-cache-expiry 3600 "Cache passwords for 60 minutes."))

;; use pass auth-sources
(use-package auth-source-pass
  :ensure nil
  :config
  (auth-source-pass-enable))

;; dired settings
(use-package dirvish
  :general-config
  (:states           'motion
   "M-ü"             'dirvish-dwim)
  (:keymaps          'dirvish-mode-map
   :states           '(motion normal)
   "T"               'dired-toggle-marks
   "q"               'dirvish-quit)
  :config
  (dirvish-override-dired-mode)
  (evil-collection-dired-setup))

;; tramp settings
(use-package tramp
  :ensure nil
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
                                (+source-ssh-env)))))

;; ewwwwwwwwwwwwwwwwwww settings
(use-package eww
  :ensure nil
  :general
  (:keymaps         'override
   "<f1>"           'eww
   "S-<f1>"         (general-l (+split-window-and-do (call-interactively 'eww))))
  :config
  (evil-collection-eww-setup))

;; sexier builtin help
(use-package helpful
  :init
  (defun +helpful-previous-buffer ()
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
  (helpful-switch-buffer-function #'+display-buffer-pop-up-if-not-helpful)
  :config
  (evil-collection-helpful-setup)
  (defun +display-buffer-pop-up-if-not-helpful (buf)
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

;; ielm settings
(use-package ielm
  :ensure nil
  :general
  (:keymaps 'override
   :states  '(motion insert)
   "C-¹"    '+ielm-toggle)
  :custom
  (ielm-header "")
  :config
  (dolist (func #'(eldoc-mode corfu-mode))
    (add-hook 'ielm-mode-hook func))

  (defun +ielm-toggle ()
    "Hide or show ielm."
    (interactive)
    (let* ((ielm-buf "*ielm*")
           (ielm-win (get-buffer-window ielm-buf)))
      (if ielm-win
          (quit-window nil ielm-win)
        (if (get-buffer ielm-buf)
            (pop-to-buffer ielm-buf)
          (ielm))))))

;; vimperator-style link-hints
(use-package link-hint
  :general
  (:states          'motion
   "C-l"            'link-hint-open-link
   "C-S-l"          'link-hint-copy-link))

(use-package pcre2el
  :after visual-regexp-steroids)

;; use recentf mode to keep file visiting history
(use-package recentf
  :ensure nil
  :general
  (general-goleader
    :states         'motion
    "ü"             'consult-recent-file)
  :init
  (recentf-mode))

(use-package saveplace
  :ensure nil
  :init
  (save-place-mode))

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

(use-package mistty
  :general
  (:keymaps         'override
   :states          '(motion emacs insert)
   "C-¼"            '+mistty-toggle)
  :general-config
  (:states          'insert
   :keymaps         'mistty-mode-map
   "C-c"            'mistty-self-insert
   "C-p"            'mistty-send-C-p
   "C-n"            'mistty-send-C-n
   "C-r"            'mistty-send-C-r
   "S-<escape>"     (+mistty-send-key-function "<ESC>"))

  :config
  (defvar +mistty--fish-to-emacs-kbds-alist
    '(("space" . "<SPC>")
      ("backspace" . "<DEL>")
      ("return" . "<RET>"))
    "A list of keys that should be replaced with their associated values when
    converting fish to Emacs keybindings.")

  (defmacro +mistty-send-key-function (key)
    "Return an interactive function named +mistty-send-KEY that sends KEY to the
mistty process."
    `(defun ,(intern (concat "mistty-send-" key)) (&optional n)
       (interactive "p")
       (mistty-send-key n ,(kbd key))))

  (defun +mistty-toggle ()
    "Hide or show mistty window.
Start terminal if it isn't running already."
    (interactive)
    (let* ((mistty-buf "*mistty*")
           (mistty-win (get-buffer-window mistty-buf)))
      (if mistty-win
          (quit-window nil mistty-win)
        (if (get-buffer mistty-buf)
            (pop-to-buffer mistty-buf)
          (mistty-other-window)))))

  (defun +mistty--fish-to-emacs-kbd (binding)
    "Convert the fish keybind BINDING to an Emacs kbd style keybinding and
    return it."
    (let ((repls '(("ctrl" . "C")
                   ("alt" . "M")
                   ("shift" . "S")))
          (last-key (car (last (string-split binding "-")))))
      (dolist (r repls)
        (setq binding (string-replace (car r) (cdr r) binding)))
      (unless (length= last-key 1)
        (cl-dolist (r +mistty--fish-to-emacs-kbds-alist)
          (when (string= last-key (car r))
            (setq binding
                  (concat
                   (substring binding 0 (- (length binding) (length last-key)))
                   (cdr r)))
            (cl-return))))
      (kbd binding)))

  (iter-defun +mistty--generate-fish-keybindings (str)
    ;; retrieve fish keybindings from str and generate emacs kbd
    ;; representations for each of them
    (let ((keybd-needle (rx "-M insert"
                            (+ space)
                            (group-n 1 (+ (not space))))))
      (dolist (line (string-split str "\n"))
        (when (string-match keybd-needle line)
          (iter-yield
           (+mistty--fish-to-emacs-kbd
            (match-string 1 line)))))))
  
  (defun +mistty-clear-insert-fish-keybds ()
    "Clear all keybindings defined for fish's insert mode in mistty's insert
    state with the exception of escape."
    (iter-do (fish-kbd (+mistty--generate-fish-keybindings
                        (shell-command-to-string "fish -C fish_user_key_bindings -c 'bind -M insert'")))
      (evil-define-key 'insert mistty-mode-map fish-kbd #'mistty-self-insert)))

  (+mistty-clear-insert-fish-keybds)
  ;; delete mistty window on exit
  (add-hook 'mistty-after-process-end-hook #'mistty-kill-buffer-and-window)
  (add-hook 'mistty-mode-hook #'evil-insert-state))


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
  :config
  (evil-collection-embark-setup)
  ;; don't ask for confirmation when killing a buffer with embark
  (setf (alist-get 'kill-buffer embark-pre-action-hooks) nil)
  
  ;; use which-key integration for embark (copied from https://github.com/oantolin/embark/wiki/Additional-Configuration)
  (defun +embark-which-key-indicator ()
    "An embark indicator that displays keymaps using which-key.
The which-key help message will show the type and value of the
current target followed by an ellipsis if there are further
targets."
    (lambda (&optional keymap targets prefix)
      (if (null keymap)
          (which-key--hide-popup-ignore-command)
        (which-key--show-keymap
         (if (eq (plist-get (car targets) :type) 'embark-become)
             "Become"
           (format "Act on %s '%s'%s"
                   (plist-get (car targets) :type)
                   (embark--truncate-target (plist-get (car targets) :target))
                   (if (cdr targets) "…" "")))
         (if prefix
             (pcase (lookup-key keymap prefix 'accept-default)
               ((and (pred keymapp) km) km)
               (_ (key-binding prefix 'accept-default)))
           keymap)
         nil nil t (lambda (binding)
                     (not (string-suffix-p "-argument" (cdr binding))))))))

  (setq embark-indicators
        '(+embark-which-key-indicator
          embark-highlight-indicator
          embark-isearch-highlight-indicator))

  (defun +embark-hide-which-key-indicator (fn &rest args)
    "Hide the which-key indicator immediately when using the completing-read prompter."
    (which-key--hide-popup-ignore-command)
    (let ((embark-indicators
           (remq #'+embark-which-key-indicator embark-indicators)))
      (apply fn args)))

  (advice-add #'embark-completing-read-prompter
              :around #'+embark-hide-which-key-indicator))

(use-package consult
  :general
  (general-leader
    :keymaps        'normal
    "b"             '+consult-file-buffers
    "B"             'consult-buffer
    "I"             'consult-imenu
    "M"             'consult-flymake)
  (general-goleader
    :keymaps        'motion
    "r"             'consult-grep
    "R"             'consult-git-grep
    "Ü"             'consult-find)
  :custom
  (completion-in-region-function #'consult-completion-in-region)
  (consult-find-args "find -P . \( -path '*/Steam' -o -path '*/.cache' -o -path '*/.git' \) -prune -o -true")
  :config
  (defun +consult-file-buffers ()
    "Consult menu to switch to file buffers only."
    (interactive)
    (consult--read
     (mapcar #'buffer-name (seq-filter #'buffer-file-name (buffer-list)))
     :prompt "Switch to: "
     :category 'buffer
     :state (consult--buffer-state)
     :require-match (confirm-nonexistent-file-or-buffer)
     :history 'consult--buffer-history
     :sort 'visibility))

  (evil-collection-consult-setup))

(use-package marginalia
  :after vertico
  :config
  (marginalia-mode))

(use-package embark-consult
  :after (consult embark))

(use-package fzf-native
  :ensure (:type git
           :host github
           :repo "dangduc/fzf-native"
           :files (:defaults "bin"))
  :after (:any corfu consult)
  :init
  (setq fzf-native-always-compile-module t)
  :config
  (fzf-native-load-dyn))

(use-package fussy
  :after fzf-native
  :config
  (fussy-setup-fzf)
  (fussy-eglot-setup))

(use-package which-key
  :ensure nil
  :custom
  (which-key-max-description-length .45)
  (which-key-add-column-padding 2)
  :init
  (which-key-mode))

(use-package xdg
  :ensure nil
  :commands xdg-user-dir)

(provide 'emacs-extensions)
