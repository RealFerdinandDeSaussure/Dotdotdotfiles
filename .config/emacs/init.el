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

(require 'package-management)

(run-hooks '°pre-init-custom-hook) ; everything even earlier can go directly into custom-file

;; require essential custom functions
(require 'my-essential-functions)

;; setup gui early to avoid modeline troubles
(require 'gui-setup)

(require 'evil-general)

;; set up autoloads for all non-essential custom functions
(setq generated-autoload-file (expand-file-name "custom-autoloads.el" emacs-subinit-dir))
(defun °update-my-function-autoloads ()
  (loaddefs-generate emacs-subinit-dir generated-autoload-file))
(add-hook 'kill-emacs-hook #'°update-my-function-autoloads)
;; if the autoloads file doesn't exist yet, create it
(unless (file-exists-p generated-autoload-file)
  (°update-my-function-autoloads)
  (kill-buffer (find-buffer-visiting generated-autoload-file)))
;; and now load it
(load generated-autoload-file)

;; load up org-mode with workarounds
(require 'org-mode)

;; mu4e (lazily so emacs still runs without it)
(unless (require 'init-mu4e nil t)
  (message "Error loading mu4e."))

(require 'completion)

(require 'general-programming)

(require 'language-specific)

(require 'emacs-extensions)

(require 'additional-keybinds)

(run-hooks '°post-init-custom-hook)
