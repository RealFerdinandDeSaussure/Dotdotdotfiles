;; -*- lexical-binding: t -*-

;; enable sourcing from init scripts in emacs.d/subinits
(defconst emacs-subinit-dir (expand-file-name "subinits" user-emacs-directory))
(add-to-list 'load-path emacs-subinit-dir)

;; set up a separate location for backup and temp files
(defconst emacs-tmp-dir (expand-file-name "auto-save" user-emacs-directory))
(setq backup-directory-alist
      `((".*" . ,emacs-tmp-dir)))
(setq auto-save-file-name-transforms
      `((".*" ,(concat emacs-tmp-dir "/\\1") t)))
    (setq auto-save-list-file-prefix
      emacs-tmp-dir)

;; package management is handled by straight.el instead of project.el
(setq package-enable-at-startup nil)

;; support loading non version controlled settings early if necessary
(let ((early-custom-file (expand-file-name "early-custom.el" user-emacs-directory)))
  (when (file-exists-p early-custom-file)
    (load early-custom-file)))
