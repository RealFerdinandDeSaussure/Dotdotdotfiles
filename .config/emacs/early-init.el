;; -*- lexical-binding: t -*-

;; enable sourcing from init scripts in emacs.d/subinits
(defconst emacs-subinit-dir (expand-file-name "subinits" user-emacs-directory))
(add-to-list 'load-path emacs-subinit-dir)

;; set up a separate location for backup and temp files
(defconst emacs-backup-dir (expand-file-name "backups" user-emacs-directory))
(defconst emacs-auto-save-dir (expand-file-name "auto-save" user-emacs-directory))
(setq backup-directory-alist `(("." . ,emacs-backup-dir)))
(setq auto-save-file-name-transforms
      `(("^/\\([^/]+/\\)*\\([^/]+\\)" ,(file-name-concat emacs-auto-save-dir "\\2") t)))

;; package management is handled by straight.el instead of project.el
(setq package-enable-at-startup nil)

;; support loading non version controlled settings early if necessary
(let ((early-custom-file (expand-file-name "early-custom.el" user-emacs-directory)))
  (when (file-exists-p early-custom-file)
    (load early-custom-file)))
