;; -*- lexical-binding: t -*-

;; language specific major modes and their settings
;; elisp helpers
(use-package edebug
  :general-config
  (:states          'emacs
   :keymaps         'edebug-mode-map
   "SPC"            'edebug-step-mode))

(use-package evil-cleverparens
  :after evil-surround
  :general
  ;; include other lisp-specific evil bindings that don't belong to cleverparens
  ;; here as well
  (:states          'normal
   :keymaps         'lisp-mode-shared-map
   "D"              'evil-cp-delete-line
   "C"              'evil-cp-change-line
   "c"              'evil-cp-change
   "d"              'evil-cp-delete
   "S"              'evil-cp-change-whole-line
   "^"              '°evil-lisp-first-non-blank
   "A"              '°evil-lisp-append-line
   "I"              '°evil-lisp-insert-line
   "o"              '°evil-lisp-open-below
   "O"              '°evil-lisp-open-above
   "C-<"            'evil-cp-<
   "C->"            'evil-cp->)
  (:states          'visual
   :keymaps         'lisp-mode-shared-map
   "c"              'evil-cp-change)
  (general-leader
    :states         'normal
    :keymaps        'lisp-mode-shared-map
    "A"             'evil-append-line
    "I"             'evil-insert-line
    "^"             'evil-first-non-blank
    "o"             'evil-open-below
    "O"             'evil-open-above
    "p"             '°evil-lisp-paste-with-newline-below
    "P"             '°evil-lisp-paste-with-newline-above)
  :config
  (evil-cp--enable-surround-operators))

(use-package suggest
  :commands suggest)

;; properly allign keyword lists (by Fuco1)
(eval-after-load "lisp-mode"
  '(defun lisp-indent-function (indent-point state)
     "Override of lisp-indent-function.  See original file for documentation"
     (let ((normal-indent (current-column))
           (orig-point (point)))
       (goto-char (1+ (elt state 1)))
       (parse-partial-sexp (point) calculate-lisp-indent-last-sexp 0 t)
       (cond
        ((and (elt state 2)
              (or (not (looking-at "\\sw\\|\\s_"))
                  (looking-at ":")))
         (if (not (> (save-excursion (forward-line 1) (point))
                     calculate-lisp-indent-last-sexp))
             (progn (goto-char calculate-lisp-indent-last-sexp)
                    (beginning-of-line)
                    (parse-partial-sexp (point)
                                        calculate-lisp-indent-last-sexp 0 t)))
         (backward-prefix-chars)
         (current-column))
        ((and (save-excursion
                (goto-char indent-point)
                (skip-syntax-forward " ")
                (not (looking-at ":")))
              (save-excursion
                (goto-char orig-point)
                (looking-at ":")))
         (save-excursion
           (goto-char (+ 2 (elt state 1)))
           (current-column)))
        (t
         (let ((function (buffer-substring (point)
                                           (progn (forward-sexp 1) (point))))
               method)
           (setq method (or (function-get (intern-soft function)
                                          'lisp-indent-function)
                            (get (intern-soft function) 'lisp-indent-hook)))
           (cond ((or (eq method 'defun)
                      (and (null method)
                           (> (length function) 3)
                           (string-match "\\`def" function)))
                  (lisp-indent-defform state indent-point))
                 ((integerp method)
                  (lisp-indent-specform method state
                                        indent-point normal-indent))
                 (method
                  (funcall method indent-point state)))))))))

;; shell scripting
;; make shell scripts executable after save if they include a shebang
(add-hook 'after-save-hook #'executable-make-buffer-file-executable-if-script-p)
(use-package sh-script
  :straight (:type built-in)
  :hook (sh-mode . bash-ts-mode))

(use-package fish-mode
  :defer t
  :custom
  (fish-enable-auto-indent t)
  :general-config
  (general-leader
    :states         'normal
    :keymaps        'fish-mode-map
    "hx"            'man-follow))

(use-package pkgbuild-mode
  :commands pkgbuild-mode)

;; latex
(use-package tex
  :straight auctex
  :defer t
  :custom
  (TeX-auto-save t)
  (TeX-parse-self t)
  (TeX-master nil)
  :config
  (add-hook 'LaTeX-mode-hook 'visual-line-mode)
  (add-hook 'LaTeX-mode-hook 'company-mode))

;; markdown
(use-package markdown-mode
  :commands markdown-mode
  :config
  (evil-collection-markdown-mode-setup))

(use-package flymd
  :after markdown-mode
  :custom
  (flymd-output-directory temporary-file-directory)
  :general-config
  (general-leader
    :states         'normal
    :keymaps        'flymd-map
    "RET"           'flymd-flyit))

;; python settings
(use-package python
  :straight (:type built-in)
  :hook (python-mode . python-ts-mode)
  :custom
  (python-fill-docstring-style 'symmetric)
  :config
  ;; auto-fill
  (auto-fill-mode)
  (setq-local comment-auto-fill-only-comments t
              ;; width settings
              fill-column 79
              column-enforce-column 79
              electric-pair-open-newline-between-pairs nil)

  ;; test creation function
  (defun °python-ts-create-test-for-defun-at-point ()
    "Create or jump to a test function for the Python function at point.
Creates a test_{function_name} in a corresponding test file in the tests directory.
If the test function already exists, jumps to it instead of creating a new one."
    (interactive)
    (when-let* ((func-name (treesit-defun-name (treesit-defun-at-point)))
                (buf-name (file-name-base buffer-file-name))
                (base-dir (or (bound-and-true-p °python-test-dir)
                              (project-root (project-current))
                              (file-name-directory buffer-file-name)))
                (test-dir (file-name-concat base-dir "tests")))
      ;; create a "tests" directory, ignoring any errors (I assume this would
      ;; mean the directory already exists)
      (ignore-errors (make-directory-internal test-dir))

      (find-file-other-window (file-name-concat test-dir (concat "test_" buf-name ".py")))
      (if-let
          ;; search for function test_{func-name} here
          ((t-n-list (treesit-query-capture
                      (car (treesit-parser-list))
                      `(((function_definition name: (identifier) @fname)
                         (:equal @fname ,(concat "test_" func-name))))))
           (test-node (car (assoc 'fname t-n-list)))
           (t-n-pos (treesit-node-start test-node)))
          ;; finally move to test_{func-name}'s node starting position if it was found
          (goto-char t-n-pos)
        ;; if we were unable to find an existing test function, append a new one to the file instead
        (end-of-buffer)
        (unless (bolp) ; ensure proper whitespace padding
          (insert "\n"))
        (unless (looking-back "\n\n" (- (point) 2)) ; dito
          (insert "\n")) 
        (insert (format "def test_%s():\n" func-name))))))

(use-package blacken
  :hook (python-ts-mode . blacken-mode))

;; golang settings
(use-package go-mode
  :straight (:type built-in)
  :hook (go-mode . go-ts-mode)
  :config
  (evil-collection-go-mode-setup)
  (add-hook
   'go-mode-hook
   (lambda ()
     (make-local-variable 'write-file-functions)
     (add-to-list 'write-file-functions (°nillify-func (eglot-format-buffer))))))

(use-package go-eldoc
  :hook (go-ts-mode . go-eldoc-setup))

(provide 'language-specific)
