;; base16-env-theme.el -- A base16 colorscheme

;;; Commentary:
;; Base16: (https://github.com/tinted-theming/home)

;;; Authors:
;; Template: Kaleb Elwert <belak@coded.io>

;;; Code:

(require 'base16-theme)

(defvar base16-env-theme-colors
  `(:base00 ,(concat "#" (getenv "__BASE00"))
    :base01 ,(concat "#" (getenv "__BASE01"))
    :base02 ,(concat "#" (getenv "__BASE02"))
    :base03 ,(concat "#" (getenv "__BASE03"))
    :base04 ,(concat "#" (getenv "__BASE04"))
    :base05 ,(concat "#" (getenv "__BASE05"))
    :base06 ,(concat "#" (getenv "__BASE06"))
    :base07 ,(concat "#" (getenv "__BASE07"))
    :base08 ,(concat "#" (getenv "__BASE08"))
    :base09 ,(concat "#" (getenv "__BASE09"))
    :base0A ,(concat "#" (getenv "__BASE0A"))
    :base0B ,(concat "#" (getenv "__BASE0B"))
    :base0C ,(concat "#" (getenv "__BASE0C"))
    :base0D ,(concat "#" (getenv "__BASE0D"))
    :base0E ,(concat "#" (getenv "__BASE0E"))
    :base0F ,(concat "#" (getenv "__BASE0F")))
  "All colors for Base16 pulled from environment variables.")

;; Define the theme
(deftheme base16-env)

;; Add all the faces to the theme
(base16-theme-define 'base16-env base16-env-theme-colors)

;; Mark the theme as provided
(provide-theme 'base16-env)

(provide 'base16-env-theme)

;;; base16-env-theme.el ends here
