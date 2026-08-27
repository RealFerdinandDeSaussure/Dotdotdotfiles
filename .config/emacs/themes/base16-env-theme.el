;; -*- lexical-binding: t -*-
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

;; override terminal colors set in the base16 default theme
(base16-theme-set-faces
 'base16-env
 base16-env-theme-colors
 '((term                                         :foreground base05 :background base00)
   (term-color-black                             :foreground base00 :background base00)
   (term-color-white                             :foreground base06 :background base06)
   (term-color-red                               :foreground base08 :background base08)
   (term-color-yellow                            :foreground base0A :background base0A)
   (term-color-green                             :foreground base0B :background base0B)
   (term-color-cyan                              :foreground base0C :background base0C)
   (term-color-blue                              :foreground base0D :background base0D)
   (term-color-magenta                           :foreground base0E :background base0E)

   (ansi-color-black                             :foreground base00 :background base00)
   (ansi-color-white                             :foreground base06 :background base06)
   (ansi-color-red                               :foreground base08 :background base08)
   (ansi-color-yellow                            :foreground base0A :background base0A)
   (ansi-color-green                             :foreground base0B :background base0B)
   (ansi-color-cyan                              :foreground base0C :background base0C)
   (ansi-color-blue                              :foreground base0D :background base0D)
   (ansi-color-magenta                           :foreground base0E :background base0E)))

;; Add all the default faces to the theme
(base16-theme-define 'base16-env base16-env-theme-colors)
;; Mark the theme as provided
(provide-theme 'base16-env)

(provide 'base16-env-theme)

;;; base16-env-theme.el ends here
