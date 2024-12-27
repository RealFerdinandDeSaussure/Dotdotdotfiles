;; -*- lexical-binding: t -*-

;; enable sourcing from init scripts in emacs.d/subinits
(defconst emacs-subinit-dir (expand-file-name "subinits" user-emacs-directory))
(add-to-list 'load-path emacs-subinit-dir)

;; custom-file handling
(setq custom-file (expand-file-name "custom.el" emacs-subinit-dir))
;; provide two custom-file hooks for different init stages
(defvar °pre-init-custom-hook nil)
(defvar °post-init-custom-hook nil)
(when (file-exists-p custom-file)
  (load custom-file))

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
