;; -*- lexical-binding: t -*-
(use-package vertico
  :init
  (setq completion-ignore-case t
        read-buffer-completion-ignore-case t
        read-file-name-completion-ignore-case t)
  (vertico-mode)
  :general-config
  (:keymaps         'vertico-map
    "M-k"           'previous-history-element
    "M-j"           'next-history-element)
  :config
  (evil-collection-vertico-setup))

(use-package embark
  :general
  (:keymaps         '(motion emacs evil-ex-completion-map
                             evil-ex-search-keymap read-expression-map
                             minibuffer-local-map)
   "C-,"            'embark-act
   "C-;"            'embark-dwim)
  :config
  (evil-collection-embark-setup))

(use-package consult
  :general
  (general-leader
    :keymaps        'normal
    "B"             'consult-buffer)
  :config
  (evil-collection-consult-setup))

(use-package marginalia
  :after vertico
  :config
  (marginalia-mode))

(use-package embark-consult
  :after (consult embark))

(use-package hotfuzz
  :defer t
  :init
  (setq completion-styles '(hotfuzz)))

(provide 'completion)
