;; -*- lexical-binding: t -*-
(use-package evil
  :init
  (setq evil-search-module 'evil-search
        evil-want-integration t
        evil-want-keybinding nil
        evil-echo-state nil
        evil-symbol-word-search t
        evil-want-Y-yank-to-eol t)
  :config
  (evil-mode 1)
  ;; workaround for view-mode keybinding behavior
  (add-hook 'view-mode-hook (lambda ()
                              (general-define-key :states 'normal :keymaps 'local
                                "q" nil)))
  
  ;; set undo backend to undo-fu
  (evil-set-undo-system 'undo-fu)
  
  ;; set initial states for specific modes
  (dolist (modestate '((edebug-mode . emacs)
                       (vterm-mode . emacs)))
    (evil-set-initial-state (car modestate) (cdr modestate)))
  (add-hook 'evil-insert-state-entry-hook (lambda () (blink-cursor-mode 1)))
  (add-hook 'evil-insert-state-exit-hook (lambda () (blink-cursor-mode -1)))
  (add-hook 'window-state-change-hook (lambda () (if (eq evil-state 'insert)
                                                     (blink-cursor-mode 1)
                                                   (blink-cursor-mode -1))))

  ;; evil commands and ex-commands
  (evil-define-command °mv-buf-and-file (new-filename)
    "Renames both current buffer and file it's visiting to NEW-NAME."
    (interactive "<a>")
    (let ((name (buffer-name))
          (filename (buffer-file-name)))
      (if (not filename)
          (message "Buffer '%s' is not visiting a file!" name)
        (if (get-buffer new-filename)
            (message "A buffer named '%s' already exists!" new-filename)
          (progn
            (rename-file filename new-filename 1)
            (rename-buffer new-filename)
            (set-visited-file-name new-filename)
            (set-buffer-modified-p nil))))))

  (evil-ex-define-cmd "mv" '°mv-buf-and-file))

(use-package evil-collection
  :after evil)

;; initial general.el setup here, all keybinds in the respective packages or in
;; additional.el
(use-package general
  :init
  (setq general-override-states '(insert emacs hybrid normal visual motion operator replace))
  :config
  (general-auto-unbind-keys)
  (general-create-definer general-leader
    :prefix "SPC")
  (general-create-definer general-goleader
    :prefix "g")
  (general-override-mode))

(use-package undo-fu
  :commands (evil-undo evil-redo))

(use-package vertigo
  :general
  (:states          'motion
   "SPC SPC"        'vertigo-set-digit-argument)
  (:states          'operator
   "SPC SPC"       'vertigo-evil-set-digit-argument)
  :general-config
  (:states          'motion
   "<C-S-SPC>"      '°vertigo-reuse-last-arg)
  :custom
  (vertigo-home-row '(?a ?s ?d ?f ?g ?h ?j ?k ?l ?ö))
  (vertigo-cut-off 9)
  :config
  (evil-define-motion vertigo-evil-set-digit-argument (count)
    "Evil vertigo motion. Count has no effect."
    (let (cmd)
      (setq cmd
            (evil-read-motion nil (vertigo--run (lambda (x) x) "Set digit arg: " t)))
      (funcall (car cmd) (nth 1 cmd))))

  (evil-declare-motion #'vertigo-set-digit-argument)
  (evil-add-command-properties #'vertigo-set-digit-argument :jump t)
  (defun °vertigo--remember-arg (func num)
    (setq-local °vertigo--last-arg num)
    (funcall func num))
  (advice-add #'vertigo--set-digit-argument :around #'°vertigo--remember-arg)
  (defun °vertigo-reuse-last-arg ()
    (interactive)
    (if (boundp '°vertigo--last-arg)
        (vertigo--set-digit-argument °vertigo--last-arg)
      (message "No previously used vertigo."))))

(use-package evil-commentary
  :general
  (general-goleader
    :states         'normal
    "c"             'evil-commentary))

(use-package evil-surround
  :after evil
  :config
  (global-evil-surround-mode 1))

(use-package evil-replace-with-register
  :general
  (general-goleader
    :states         'normal
    "r"             'evil-replace-with-register))

(use-package evil-goggles
  :hook (after-init . evil-goggles-mode)
  :custom
  (evil-goggles-duration 0.500)
  (evil-goggles-blocking-duration 0.001)
  (evil-goggles-enable-shift nil)
  (evil-goggles-enable-undo nil)
  (evil-goggles-enable-paste nil)
  (evil-goggles-enable-commentary nil)
  (evil-goggles-enable-surround nil)
  (evil-goggles-enable-delete nil))

(use-package evil-mc
  :custom
  (evil-mc-custom-known-commands
   '((indent-relative ((:default . evil-mc-execute-default-call)))))
  :config
  (evil-collection-evil-mc-setup)
  (global-evil-mc-mode 1))

(use-package evil-numbers
  :general
  (:states          'normal
   "C-a"            'evil-numbers/inc-at-pt
   "C-x"            'evil-numbers/dec-at-pt))

(use-package evil-textobj-tree-sitter
  :general
  (:keymaps     'evil-outer-text-objects-map
   "f"          (evil-textobj-tree-sitter-get-textobj "function.outer")
   "C"          (evil-textobj-tree-sitter-get-textobj "class.outer"))
  (:keymaps     'evil-inner-text-objects-map
   "f"          (evil-textobj-tree-sitter-get-textobj "function.inner")
   "C"          (evil-textobj-tree-sitter-get-textobj "class.inner")))

(provide 'evil-general)
