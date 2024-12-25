;; -*- lexical-binding: t -*-
;; default indentation settings (no TABs) - other settings on a per-mode basis
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)

;; abbreviation settings
;; expand abbreviation upon exiting insert stat
(add-hook 'evil-insert-state-exit-hook #'expand-abbrev)
(setq save-abbrevs 'silently)

;; mode associations
(push '(".gitignore" . prog-mode) auto-mode-alist)

;; syntax checking
(use-package flymake
  :hook ((go-mode python-mode) . °init-flymake)
  :config
  (evil-collection-flymake-setup)
  (setq flymake-fringe-indicator-position 'right-fringe)
  (mapc #'evil-declare-not-repeat #'(flymake-goto-next-error flymake-goto-prev-error))

  (defun °init-flymake ()
    (make-local-variable 'evil-insert-state-exit-hook)
    (make-local-variable 'evil-insert-state-entry-hook)
    (add-hook 'evil-insert-state-exit-hook
              (lambda ()
                (flymake-mode 1)))
    (add-hook 'evil-insert-state-entry-hook
              (lambda ()
                (flymake-mode -1))))
  (flymake-mode)
  (flymake-start))

(use-package yasnippet
  :hook ((go-mode fish-mode snippet-mode python-mode mu4e-compose-mode) . yas-minor-mode)
  :general
  (:keymaps         '(yas-keymap yas/keymap)
   "M-j"            'yas-next-field-or-maybe-expand
   "M-k"            'yas-prev-field
   "M-S-j"          'yas-skip-and-clear-field)
  (general-leader
    :states         'normal
    :keymaps        'snippet-mode-map
    "YY"            'yas-load-snippet-buffer-and-close
    "Yy"            'yas-load-snippet-buffer)
  (general-leader
    :keymaps        '(go-mode-map fish-mode-map python-mode-map mu4e-compose-mode-map)
    :states         'normal
    "Yn"            'yas-new-snippet
    "Ye"            'yas-visit-snippet-file
    "Yi"            'yas-insert-snippet
    "Yt"            'yas-describe-tables)

  :config
  (yas-reload-all)
  ;; bind this here because yas-maybe-expand needs to be loaded first
  (general-def
    :states         'insert
    :keymaps        'yas-minor-mode-map
    "SPC"           yas-maybe-expand
    "<return>"      yas-maybe-expand)  

  ;; expansion for some python snippets
  (general-def
   :keymaps         'python-mode-map
   :states          'insert
   ":"              yas-maybe-expand)

  ;; yas related functions
  (defun °yas-choose-greeting (name lang)
    "Create a list of possible greetings from NAME and LANG and call
yas-choose-value on it."
    (setq name (capitalize (or name "")))
    (cl-flet
        ((ncat (x) (concat x " " (°last-name name))))
      (let
          ((name-list (pcase lang
                        ('de `(,@(mapcar #'ncat '("Liebe Frau" "Lieber Herr"))
                               ,(concat "Guten Tag " name)
                               "Guten Tag"))
                        ('en `(,@(mapcar #'ncat '("Dear Ms." "Dear Mr."))
                               ,(concat "Dear " name)
                               ,(concat "Dear " (car (split-string name)))
                               "Hello")))))
        (yas-choose-value (cl-remove-duplicates name-list :test #'equal)))))

  (defun °yas-content (snippet)
    "Return plain-text content of SNIPPET."
    (yas--template-content (yas-lookup-snippet snippet)))

  (defun °yas-func-padding (count &optional down)
    "Add COUNT empty lines above current position.

If DOWN is non-nil, then add lines below instead."
    (let ((counter count)
          (non-break t)
          (fillstr "")
          (direction (if down 1 -1))
          (current-line (line-number-at-pos)))
      ;; do nothing if we're already at the end or beginning of the file
      (unless (or
               (= current-line 1)
               (>= current-line (- (line-number-at-pos (buffer-end 1)) 1)))
        (save-excursion
          (while (and (> counter 0) non-break)
            (forward-line direction)
            (if (string= "" (°get-line))
                (setq counter (1- counter))
              (setq non-break nil)))
          (make-string counter ?\n)))))

  (defun °yas-indented-p (line)
    "Return t if LINE is indented, else return nil."
    (if (string-match-p "^\s" line) t nil))

  (defun °yas-snippet-key ()
    "Retrieve the key of the snippet that's currently being edited."
    (save-excursion
      (goto-char 0)
      (search-forward-regexp "# key:[[:space:]]*")
      (thing-at-point 'symbol t)))

  (defun °yas-python-class-field-splitter (arg-string)
    "Return ARG-STRING as a conventional Python class field assignment block."
    (if (= (length arg-string) 0)
        ""
      (let ((clean-string)
            (field-list))
        (setq clean-string
              (string-trim-left (replace-regexp-in-string " ?[:=][^,]+" "" arg-string) ", "))
        (setq field-list (split-string clean-string ", +"))
        (string-join (mapcar (lambda (s) (concat "self." s " = " s "\n")) field-list)))))

  (defun °yas-python-doc-wrapper (docstring side)
    "Wrap DOCSTRING in quotes on either left or right SIDE."
    (let* ((line-length (+ (python-indent-calculate-indentation) 6 (length docstring)))
           (nl ""))
      (when (> (+ (python-indent-calculate-indentation) 6 (length docstring)) fill-column)
        (setq nl "\n"))
      (apply 'concat
             (cond ((eq side 'left)
                    `("\"\"\"" ,nl))
                   ((eq side 'right)
                    `(,nl "\"\"\"")))))))

;; language server (eglot)
(setq eglot-workspace-configuration
      '(:pyright (:plugins (:pycodestyle (:enabled nil)))))
(dolist (mode '(python go))
  (add-hook
    (°concat-symbols mode '-mode-hook)
    (lambda ()
      (call-interactively #'eglot)
      (setq flymake-diagnostic-functions (list #'eglot-flymake-backend)))))

;; autocompletion
(use-package company
  :hook ((prog-mode . company-mode)
         (company-mode . company-tng-mode))
  :general
  (:keymaps         'company-tng-map
   "<return>"       (general-l
                      (unless (company-tooltip-visible-p)
                        (company-complete)
                        (company-pseudo-tooltip-hide))
                      (newline 1 t))
   "M-<return>"     (general-l
                      (company-abort)
                      (newline 1 t)))
  (:states          'insert
   :keymaps         'company-search-map
   "<return>"       (general-l
                      (company-complete)
                      (company-pseudo-tooltip-hide)
                      (newline 1 t)))
  
  :config
  (evil-collection-company-setup)
  (setq company-minimum-prefix-length 3
        company-selection-wrap-around t
        company-idle-delay 0.01
        company-echo-delay 0.5)

  (mapc #'evil-declare-not-repeat #'(°company-select-next °company-select-previous)))

(use-package company-quickhelp
  :after company
  :config
  (company-quickhelp-mode)
  (setq company-quickhelp-delay .2))

(use-package magit
  :hook ((magit-mode . °source-ssh-env)
         (with-editor-mode . evil-insert-state))
  :general
  (general-goleader
    :states         'normal
    "G"             'magit-status)

  :config
  (evil-collection-magit-setup)
  (defun °force-git-access ()
    (interactive)
    (let ((index-file (°join-path nil
                       (project-root (project-current)) (file-name-as-directory ".git") "index.lock")))
      (when (yes-or-no-p (concat "Really delete " index-file "?"))
        (delete-file index-file)))))

(use-package quickrun
  :general
  (general-leader
    :keymaps        'normal
    "RET"           'quickrun)
  (general-leader
    :keymaps        'visual
    "RET"           'quickrun-region)
  (:states          'normal
   :keymaps         'quickrun--mode-map
   "q"              'quit-window)

  :config
  (setq quickrun-focus-p nil))


(provide 'general-programming)
