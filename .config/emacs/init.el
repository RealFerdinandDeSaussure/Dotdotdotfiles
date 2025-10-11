;; -*- lexical-binding: t -*-

(require 'package-management)

;; require essential custom functions
(require 'my-essential-functions)

;; setup gui early to avoid modeline troubles
(require 'gui-setup)

(require 'evil-general)

;; set up autoloads for all non-essential custom functions
(setq generated-autoload-file (expand-file-name "custom-autoloads.el" emacs-subinit-dir))
(defun +update-my-function-autoloads ()
  (loaddefs-generate emacs-subinit-dir generated-autoload-file))
(add-hook 'kill-emacs-hook #'+update-my-function-autoloads)
;; if the autoloads file doesn't exist yet, create it
(unless (file-exists-p generated-autoload-file)
  (+update-my-function-autoloads)
  (kill-buffer (find-buffer-visiting generated-autoload-file)))
;; and now load it
(load generated-autoload-file)

;; load up org-mode with workarounds
(require 'org-mode)

;; mu4e (lazily so emacs still runs without it)
(unless (require 'mu4e-setup nil t)
  (message "Error loading mu4e."))

(require 'general-programming)

(require 'language-specific)

(require 'emacs-extensions)

(require 'additional-keybinds)

;; load custom file aat the end of init so it can rely on all settings to be available
(setq custom-file (expand-file-name "custom.el" emacs-subinit-dir))
(when (file-exists-p custom-file)
  (load custom-file))
