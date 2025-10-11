;; -*- lexical-binding: t -*-
;; GUI and Highlighting settings
(setq inhibit-startup-message t
      echo-keystrokes .01
      show-paren-delay 0
      scroll-step 1
      ring-bell-function #'ignore)
(fringe-mode '(0 . 8))
(scroll-bar-mode -1)
(tool-bar-mode -1)
(menu-bar-mode -1)
(show-paren-mode 1)
(blink-cursor-mode 0)
(setq-default fill-column 80
              cursor-in-non-selected-windows nil)
(dolist (hook '(prog text conf))
  (add-hook
   (+concat-symbols hook '-mode-hook)
   #'hl-line-mode))

;; window splitting settings --> REMOVE?
(setq split-window-preferred-function '+split-window-sensibly)

;; keep track of window layout changes
(defun ++first-push-to-window-layout-stack (&rest args)
  (unless (eql (count-windows) 1)
    (++window-layout-stack-push)))
;; only add this advice to high-level functions to avoid infinite recursion
(advice-add #'delete-other-windows :before #'++first-push-to-window-layout-stack)
(advice-add #'evil-window-delete :before #'++first-push-to-window-layout-stack)

(dolist (hook '(prog-mode-hook text-mode-hook conf-mode-hook))
  (add-hook hook (lambda ()
                   (setq display-line-numbers 'relative
                         display-line-numbers-widen t
                         display-line-numbers-current-absolute t))))

;; delimiter highlighting and matching
(setq electric-pair-open-newline-between-pairs t)
(dolist (hook '(prog-mode-hook text-mode-hook))
  (add-hook hook #'electric-pair-local-mode))

(use-package dimmer
  :config
  (defun +dimmer-config-change-handler ()
    "Advise to only force process if no predicate is truthy."
    (let ((ignore (cl-some (lambda (f) (and (fboundp f) (funcall f)))
                           dimmer-prevent-dimming-predicates)))
      (unless ignore
        (when (fboundp 'dimmer-process-all)
          (dimmer-process-all t)))))

  (defun +corfu-frame-p ()
    (string-match-p "^ \\*corfu\\(-popupinfo\\)?\\*$" (buffer-name)))

  (advice-add 'dimmer-config-change-handler :override #'+dimmer-config-change-handler)
  (add-to-list 'dimmer-prevent-dimming-predicates #'+corfu-frame-p)
  (dimmer-mode 1))

;; modeline
(use-package telephone-line
  :init
  (require 'project)
  (telephone-line-defsegment +telephone-line-buffer-modified-segment ()
    (unless buffer-read-only
      (if (buffer-modified-p)
          (telephone-line-raw "!")
        (telephone-line-raw "-"))))

  (telephone-line-defsegment
   +telephone-line-project-segment ()
   (unless (file-remote-p default-directory)
       (file-name-nondirectory (directory-file-name (project-root (project-current))))))
  
  (setq telephone-line-lhs
        '((evil     .   (+telephone-line-buffer-modified-segment
                         telephone-line-evil-tag-segment))
          (accent   .   (+telephone-line-project-segment))
          (nil      .   (telephone-line-buffer-name-segment)))
        telephone-line-rhs
        '((nil      .   (telephone-line-misc-info-segment))
          (accent   .   (telephone-line-simple-major-mode-segment))
          (evil     .   (telephone-line-position-segment)))

        telephone-line-primary-left-separator 'telephone-line-halfsin-left
        telephone-line-secondary-left-separator 'telephone-line-halfsin-hollow-left
        telephone-line-primary-right-separator 'telephone-line-halfsin-right
        telephone-line-secondary-right-separator 'telephone-line-halfsin-hollow-right

        telephone-line-height 24)
  :config
  (telephone-line-mode 1)
  (column-number-mode 1))

;;; theme settings
(push (expand-file-name "themes" user-emacs-directory) custom-theme-load-path)
(use-package base16-theme
  :demand
  :config
  (load-theme 'base16-env t)
  ;; override cursor color
  (set-face-attribute 'cursor nil :background (plist-get base16-env-theme-colors :base06)))

(push `(font . ,(concat (or (getenv "FONT_MONO") "Monospace"))) default-frame-alist)

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package shackle
  :config
  (shackle-mode 1)
  :custom (shackle-rules
           '(("*eshell*"
              :regexp t :select t :popup t :align below :size 0.2)
             ("^\\*ansi-term.*"
              :regexp t :select t :popup t :align below :size 0.2)
             ('inferior-python-mode
              :select t :popup t :align below :size 0.2)
             ("*ielm*"
              :select t :popup t :align below :size 0.35)
             ("*vterm*"
              :regexp t :select t :popup t :align below :size 0.2))))

(provide 'gui-setup)
