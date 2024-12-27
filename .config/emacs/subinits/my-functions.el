;; -*- lexical-binding: t -*-

(require 'cl-lib)

;; macros
;;;###autoload
(defmacro °flet (bindings &rest body)
  "Like flet but using cl-letf and therefore not deprecated."
  `(cl-letf ,(mapcar
              (lambda (binding)
                `((symbol-function (quote ,(car binding)))
                  ,@(cdr binding)))
              bindings)
     ,@body))

;;;###autoload
(defmacro °split-window-and-do (&rest funcs)
  `(progn
     (ignore-errors
       (select-window (funcall split-window-preferred-function)))
     ,@funcs))

;;;###autoload
(defmacro °nillify-func (&rest funcs)
  "Return a function that runs FUNCS but always returns nil."
  `(lambda ()
     ,@funcs
     nil))

;;;###autoload
(defmacro °defun-newline-paste (func-name &rest open-funcs)
  "Create a function that pastes after opening lines with OPEN-FUNCS."
  `(defun ,func-name (count)
     (interactive "p")
     (evil-with-single-undo
       (while (> (setq count (1- count)) -1)
         (evil-save-state
           ,@open-funcs)
         (evil-paste-after 1)
         (indent-according-to-mode)))))

;; evil related-functions
;;;###autoload
(defun °evil-dry-open-below (count)
  "Open LINE number of lines below but stay in current line."
  (interactive "p")
  (save-excursion
    (end-of-line)
    (open-line count)))

;;;###autoload
(defun °evil-dry-open-above (count)
  "Open LINE number of lines above but stay in current line."
  (interactive "p")
  ;; this does not work with save-excursion if it's done at the beginning of
  ;; the buffer
  (let ((col (current-column)))
    (beginning-of-line)
    (open-line count)
    (forward-line count)
    (move-to-column col)))

;;;###autoload
(defun °evil-search-visual-selection (direction count)
  "Search for visually selected text in buffer.
DIRECTION can be forward or backward.  Don't know what COUNT does."
  (when (> (mark) (point))
    (exchange-point-and-mark))
  (when (eq direction 'backward)
    (setq count (+ (or count 1) 1)))
  (let ((regex (format "\\<%s\\>" (regexp-quote (buffer-substring (mark) (point))))))
    (setq evil-ex-search-count count
          evil-ex-search-direction direction
          evil-ex-search-pattern
          (evil-ex-make-search-pattern regex)
          evil-ex-search-offset nil
          evil-ex-last-was-search t)
    ;; update search history unless this pattern equals the
    ;; previous pattern
    (unless (equal (car-safe evil-ex-search-history) regex)
      (push regex evil-ex-search-history))
    (evil-push-search-history regex (eq direction 'forward))
    (evil-ex-delete-hl 'evil-ex-search)
    (evil-exit-visual-state)
    (when (fboundp 'evil-ex-search-next)
      (evil-ex-search-next count))))

;;;###autoload (autoload '°evil-paste-with-newline-above "my-functions")
(°defun-newline-paste
 °evil-paste-with-newline-above
 (evil-open-above 1))

;;;###autoload (autoload '°evil-paste-with-newline-below "my-functions")
(°defun-newline-paste
 °evil-paste-with-newline-below
 (evil-open-below 1))

;;;###autoload (autoload '°evil-lisp-paste-with-newline-above "my-functions")
(°defun-newline-paste
 °evil-lisp-paste-with-newline-above
 (°evil-lisp-open-above 1))

;;;###autoload (autoload '°evil-lisp-paste-with-newline-below "my-functions")
(°defun-newline-paste
 °evil-lisp-paste-with-newline-below
 (°evil-lisp-open-below 1))

;; lisp related functions
;;;###autoload
(defun °evil-lisp-append-line (count)
  (interactive "p")
  (°°evil-lisp-end-of-depth-in-line)
  (evil-insert count))

(defun °°evil-lisp-end-of-depth-in-line ()
  "Go to last point of current syntax depth on the current line."
  ;; if we're on a parens move into its scope
  (unless (eq (length (°get-line)) 0) ; don't move if on empty line
    (let ((depth (°°syntax-depth))
          (line-end (save-excursion
                      (end-of-line)
                      (point))))

      (when
          (catch 'end-of-depth
            (while (< (point) line-end)
              (forward-char)
              (when (< (°°syntax-depth) depth)
                (throw 'end-of-depth t))))
        (backward-char)))))

;;;###autoload
(defun °evil-lisp-insert-line (count)
  (interactive "p")
  (°°evil-lisp-beginning-of-depth-in-line)
  (when (looking-at "\s")
    (°evil-lisp-first-non-blank))
  (evil-insert count))

;;;###autoload
(defun °evil-lisp-first-non-blank ()
    (interactive)
  (evil-first-non-blank)
  (while (and (equal (thing-at-point 'char) "(")
              (not (°°in-string-p)))
    (evil-forward-char)))

;;;###autoload
(defun °evil-lisp-open-above (count)
  (interactive "p")
  (°°evil-lisp-beginning-of-depth-in-line)
  (save-excursion
    (newline 1)
    (indent-according-to-mode))
  (indent-according-to-mode)
  (setq evil-insert-count count
        evil-insert-lines t)
  (evil-insert-state 1))

;;;###autoload
(defun °evil-lisp-open-below (count)
  (interactive "p")
  (°°evil-lisp-end-of-depth-in-line)
  (newline 1)
  (indent-according-to-mode)
  (setq evil-insert-count count
        evil-insert-lines t)
  (evil-insert-state 1))

(defun °°evil-lisp-beginning-of-depth-in-line ()
  "Go to first point of current syntax depth on the current line."
  (let ((depth (°°syntax-depth))
        (line-beginning (save-excursion
                      (beginning-of-line)
                      (point))))

    (when
        (catch 'beginning-of-depth
          (while (> (point) line-beginning)
            (backward-char)
            (when (< (°°syntax-depth) depth)
              (throw 'beginning-of-depth t))))
      (forward-char))))

;; functions related to other packages
;;;###autoload
(defun °dired-mark-toggle ()
  "Toggle mark for currently selected file."
  (interactive)
  (let ((inhibit-read-only t))
    (when (not (dired-between-files))
      (save-excursion
        (beginning-of-line)
        (apply 'subst-char-in-region
               (point) (1+ (point))
               (if (eq (following-char) ?\040)
                   (list ?\040 dired-marker-char)
                 (list dired-marker-char ?\040)))))))

;;;###autoload
(defun °eshell ()
  "Hide or show eshell window.
Start eshell if it isn't running already."
  (interactive)
  (if (get-buffer-window "*eshell*")
      (progn
        (select-window (get-buffer-window "*eshell*"))
        (delete-window))
    (eshell)))

;;;###autoload
(defun °ispell-cycle-dicts ()
  "Cycle through the dicts in `°ispell-dicts-in-use'."
  (interactive)
  (ispell-change-dictionary
   (catch 'dict
     (while t
       (nconc °ispell-dicts-in-use (list (pop °ispell-dicts-in-use)))
       (unless (string= ispell-current-dictionary (car °ispell-dicts-in-use))
         (throw 'dict (car °ispell-dicts-in-use)))))))

;;;###autoload
(defun °python-remove-breakpoints ()
  "Remove all breakpoint declarations in buffer."
  (interactive)
  (let ((counter 0))
    (save-excursion
      (goto-char 0)
      (while (re-search-forward "^[[:space:]]*breakpoint()[[:space:]]*\n" nil t)
        (replace-match "")
        (setq counter (1+ counter))))
    (message "%s breakpoint%s removed." counter (if (= counter 1) "" "s"))))

;;;###autoload
(defun °python-test ()
  "Run pytest."
  (interactive)
  (let ((old-py-path (getenv "PYTHONPATH"))
        (new-py-path (project-root (project-current))))
    (setenv "PYTHONPATH" new-py-path)
    (quickrun :source `((:command . "pytest")
                        (:default-directory . ,new-py-path)
                        (:exec . ("pytest"))))
    (setenv "PYTHONPATH" old-py-path)))

;;;###autoload
(defun °straight-update ()
  "Fetch, merge and rebuild all straight packages."
  (interactive)
  (when (y-or-n-p "Fetch package remotes and rebuild modified packages? ")
    (straight-pull-all)
    (straight-check-all)
    (restart-emacs)))

;; general functions
;;;###autoload
(defun °add-hook-to-mode (hook function mode &optional depth)
  "Add FUNCTION to HOOK but limit it to MODE.  See `add-hook' for option DEPTH."
  (add-hook (°concat-symbols mode '-hook)
            (lambda ()
              (add-hook hook function depth t))))

(defun °delete-this-file ()
  "Delete file in current buffer."
  (interactive)
  (let* ((buf (current-buffer))
         (file (buffer-file-name buf)))
    (when (yes-or-no-p (concat "Delete file " file "? "))
      (kill-buffer buf)
      (delete-file file))))

;;;###autoload
(defun °eval-visual-region ()
  "Evaluate region."
  (interactive)
  (when (> (mark) (point))
    (exchange-point-and-mark))
  (eval-region (mark) (point) t)
  (ignore-errors
   (evil-normal-state)))

;;;###autoload
(defun °eval-line ()
  "Evaluate current line."
  (interactive)
  (save-excursion
    (end-of-line)
    (eval-last-sexp nil)))

;;;###autoload
(defun °eval-at-point ()
  "Move out to closest sexp and evaluate."
  (interactive)
  (let ((point-char (thing-at-point 'char))
        (reg-start)
        (reg-end))
    (save-excursion
      (while (not (or (string= point-char "(")
                      (string= point-char ")")))
        (ignore-errors
            (backward-sexp))
          (backward-char)
        (setq point-char (thing-at-point 'char)))
      (if (string= point-char "(")
          (setq reg-start (point))
        (setq reg-end (+ (point) 1)))
      (evil-jump-item)
      (if reg-start
          (setq reg-end (+ (point) 1))
        (setq reg-start (point))))
    (eval-region reg-start reg-end t)))

;;;###autoload
(defun °get-line ()
  "Uniform way to get content of current line."
  (buffer-substring-no-properties (line-beginning-position) (line-end-position)))

(defun °°in-string-p ()
  "Returns t if point is within a string according to syntax-ppss.  Otherwise nil."
  (not (eq (nth 3 (syntax-ppss)) nil)))

;;;###autoload
(defun °join-path (folders-only &rest elements)
  "Join ELEMENTS to create a path. The last element should be the name of a file
unless FOLDERS-ONLY is non-nil."
  (let* ((file (unless folders-only (car (last elements))))
        (folders (cl-remove file elements :test #'equal :count 1 :from-end t)))
    (apply #'concat `(,@(mapcar #'file-name-as-directory folders) ,file))))

;;;###autoload
(defun °last-name (name)
  "Return the last name portion of NAME."
  (when (string-to-list name)
    (setq name (string-join
                (reverse
                 (mapcar #'string-trim (split-string name ",")))
                " ")) ; to accomodate for comma-separated last names at the beginning
    (let* ((nlist (reverse (split-string (downcase name))))
           (lname (capitalize (pop nlist)))
           (pres (mapcar #'downcase °last-name-prefixes))
           (pre (pop nlist))
           (rpre (cl-position pre pres :test #'string=)))
      (if rpre
          (concat (nth rpre °last-name-prefixes) " " lname)
        lname))))

;;;###autoload
(defun °restore-window-layout ()
  "Restore window layout that is on top of `°°window-layout-stack'."
  (interactive)
  (let ((layout (pop °°window-layout-stack)))
    (when layout
      (set-window-configuration layout))))

;;;###autoload
(defun °select-printer ()
  (interactive)
  (let* ((stdout (string-trim (shell-command-to-string "lpstat -a 2>/dev/null")))
         (lines (if (string= stdout "")
                    nil
                  (split-string stdout "[\n]+")))
         (printers (mapcar (lambda (line) (car (split-string line))) lines))
         (sel-printer (ivy-read "Select printer: " printers)))
    (setq printer-name sel-printer)
    (message (format "`printer-name' set to \"%s\"" printer-name))))

;;;###autoload
(defun °source-ssh-env ()
  "Read environment variables for the ssh environment from '~/.ssh/environment'."
  (let (pos1 pos2 (var-strs '("SSH_AUTH_SOCK" "SSH_AGENT_PID")))
    (unless (cl-some 'getenv var-strs)
      (with-temp-buffer
        (ignore-errors
          (insert-file-contents "~/.ssh/environment")
          (mapc
           (lambda (var-str)
             (goto-char 0)
             (search-forward var-str)
             (setq pos1 (+ (point) 1))
             (search-forward ";")
             (setq pos2 (- (point) 1))
             (setenv var-str (buffer-substring-no-properties pos1 pos2)))
           var-strs))))))

;;;###autoload
(defun °split-window-sensibly (&optional window)
  "Prefer horizontal splits for state-of-the-art widescreen monitors. Also don't
  split when there's 3 or more windows open."
  (if (or
       (>= (count-windows) 3)
       (> (length (get-buffer-window-list)) 1))
      nil
    (let* ((window (or window (selected-window)))
           (window-size-h (window-size window))
           (window-size-w (window-size window t))
           (frame-size-h (window-size (frame-root-window)))
           (frame-size-w (window-size (frame-root-window) t)))
      (or
       (and
        (> window-size-w split-width-threshold)
        (eq frame-size-w window-size-w)
        (with-selected-window window
          (split-window-right)))
       (and
        (eq frame-size-h window-size-h)
        (with-selected-window window
          (split-window-below)))))))


;;;###autoload
(defun °sudo-this-file ()
  "Open 'find-file' with sudo prefix on current buffer."
  (interactive)
  (find-file (°join-path nil "/sudo::/" (buffer-file-name))))

(defun °°syntax-depth ()
  "Return depth at point within syntax tree. "
  (nth 0 (syntax-ppss)))

;;;###autoload
(defun °toggle-scratch-buffer ()
  "Go back and forth between scratch buffer and most recent other buffer."
  (interactive)
  (if (string= (buffer-name) "*scratch*")
      (evil-switch-to-windows-last-buffer)
    (switch-to-buffer "*scratch*")))

;;;###autoload
(defun °window-clear-side ()
  "Clear selected pane from vertically split windows."
  (interactive)
  (cl-flet ((clear
             (direction)
             (while
                 (ignore-errors
                   (funcall (°concat-symbols 'windmove- direction)))
               (delete-window))))
    (mapc #'clear '(up down))))

(defun °°window-layout-stack-push ()
  (push (current-window-configuration) °°window-layout-stack))

;; variables
(defvar °last-name-prefixes '("von" "de" "van" "Al")
  "List of possible last name prefixes for `°last-name' to consider.")

(defvar °°window-layout-stack nil
  "Stack of recently recorded layout changes.")

(provide 'my-functions.el)
