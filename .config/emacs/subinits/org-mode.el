;; -*- lexical-binding: t -*-
(use-package org
  :ensure nil
  :hook (org-mode . +init-org-mode)
  :custom
  (org-log-done 'time)
  (org-adapt-indentation t)
  (org-cycle-separator-lines -1)
  (org-priority-default ?C)
  (org-startup-folded 'content)
  (org-agenda-custom-commands '(("G" "Overview by urgency"
                                 ((tags-todo "+PRIORITY=\"A\"+TODO=\"TODO\"")
                                  (agenda "")
                                  (tags-todo "-PRIORITY=\"A\"-SCHEDULED={.+}+TODO=\"TODO\""
                                             ((org-agenda-sorting-strategy '(priority-down))))
                                  (tags-todo "TODO=\"WAIT\""
                                             ((org-agenda-sorting-strategy '(priority-down))))))))
  :general
  (general-goleader
    :states         'motion
    "O"             (general-l
                      (find-file +org-home)))
  :general-config
  (:states          'normal
   :keymaps         'org-mode-map
   "{"              '+org-prev-element
   "}"              '+org-next-element
   "o"              '+org-meta-open-below
   "O"              '+org-meta-open-above)
  (:states         'insert
   :keymaps         'org-mode-map
   "M-L"            'org-metaright
   "M-H"            'org-metaleft)
  (general-leader
    :states         'normal
    :keymaps        'org-mode-map
    "o"             'evil-open-below
    "O"             'evil-open-above
    "t"             'org-todo
    "d"             'org-deadline
    "s"             'org-schedule
    "H"             'org-metaleft
    "L"             'org-metaright
    "J"             'org-metadown
    "K"             'org-metaup
    "x"             'org-toggle-checkbox
    "X"             '+org-toggle-checkbox-presence
    "+"             'org-set-property
    "#"             'org-priority
    "D"             (general-l
                      (end-of-line)
                      (org-insert-drawer))
    ":"             'org-set-tags-command)
  (general-goleader
    :states         'motion
    :keymaps        'org-mode-map
    "A"             'org-agenda
    "o"             '+org-meta-ctrl-open-below
    "O"             '+org-meta-ctrl-open-above
    "L"             'org-toggle-link-display
    "0"             '+org-overview-realign)
  ;; keybindings for agenda-view
  (:states          'normal
   :keymaps         'org-agenda-mode-map
   "j"              'org-agenda-next-line
   "k"              'org-agenda-previous-line
   "("              'org-agenda-earlier
   ")"              'org-agenda-later
   "r"              'org-agenda-redo
   "q"              'org-agenda-quit
   "RET"            (general-l (org-agenda-show-1 3)))
  (general-leader
    :states         'normal
    :keymaps        'org-agenda-mode-map
    "t"             'org-agenda-todo
    ":"             'org-agenda-set-tags)
  :config
  (evil-set-initial-state 'org-agenda-mode 'normal)
  (evil-collection-org-setup)
  ;; add my org-home file to agenda files if variable +org-home is bound
  (when (boundp '+org-home)
    (add-to-list 'org-agenda-files +org-home))
  
  (dolist (action #'(org-forward-sentence
                     org-backward-sentence
                     +org-prev-element
                     +org-next-element
                     org-cycle))
    (evil-declare-not-repeat action))
  
  (+add-hook-to-mode 'before-save-hook
                     (lambda () (org-align-tags t))
                     'org-mode)
  
  (defun +init-org-mode ()
    (setq-local line-spacing 0.4)
    (++org-visual-line-mode))
  
  (defun +org-prev-element ()
    (interactive)
    (if (> (or (org-current-level) 0) 1)
        (org-up-element)
      (org-backward-element)))

  (defun +org-next-element ()
    (interactive)
    (when (> (or (org-current-level) 0) 1)
      (org-up-element))
    (org-forward-element))

  (defun +org-meta-open-below ()
    (interactive)
    (let ((context-func (cond ((org-at-table-p)
                               (call-interactively #'org-table-end-of-field)
                               #'org-table-wrap-region)
                              ((org-at-item-p)
                               (org-end-of-item)
                               (unless (org-at-item-p)
                                 (previous-line)
                                 (end-of-line))
                               #'org-insert-item)
                              ((org-at-heading-p)
                               (org-end-of-line)
                               #'org-insert-heading)
                              (t
                               (lambda () (interactive) (evil-insert-newline-below))))))
      (while (org-fold-folded-p)
        (forward-char))
      (call-interactively context-func)
      (indent-according-to-mode)
      (evil-insert 1)))

  (defun +org-meta-open-above ()
    (interactive)
    (let ((context-func
           (cond ((org-at-table-p)
                  (call-interactively #'org-table-beginning-of-field)
                  #'org-table-insert-row)
                 ((org-at-item-p)
                  (org-beginning-of-item)
                  #'org-insert-item)
                 (t
                  (org-beginning-of-line)
                  #'org-meta-return))))
      (call-interactively context-func)
      (evil-insert 1)))

  (defun +org-meta-ctrl-open-below ()
    (interactive)
    (evil-with-single-undo
      (+org-meta-open-below)
      (when (org-at-heading-p)
        (++org-insert-todo-keyword))))
  
  (defun +org-meta-ctrl-open-above ()
    (interactive)
    (evil-with-single-undo
      (+org-meta-open-above)
      (when (org-at-heading-p)
        (++org-insert-todo-keyword))))

  (defun ++org-insert-todo-keyword ()
    (org-todo (if (member "TODO" org-todo-keywords-1)
                  "TODO"
                (car org-todo-keywords-1))))

  (defun ++org-undone-children-at-point-p (&optional no-children)
    "Return t if we are at a heading with children that are not in the
`org-done-keywords' list. If NO-CHILDREN is non-nil, also return t if there are
no children at all."
    (save-excursion
      (catch 'childless
        (and
         (org-at-heading-p)
         (if (org-goto-first-child)
             t
           (throw 'childless no-children))
         (let ((level (org-current-level)))
           (while (and
                   (member (org-get-todo-state) org-done-keywords)
                   (org-get-next-sibling)))
           (>= (org-current-level) level))))))
  
  (defun +org-process-done?-headings ()
    (interactive)
    (org-map-entries (lambda ()
                       (when (not (++org-undone-children-at-point-p t))
                         (org-todo)))
                     (concat "/" (string-join org-not-done-keywords "|"))))

  (defun +org-move-done-headings-to-archive (prefix)
    (interactive "P")
    (let ((count 0))
      (org-map-entries
       (if prefix
           (lambda ()
             (setq count (++org-archive-heading-if-all-done count t)))
         (lambda ()
           (setq count (++org-archive-heading-if-all-done count))))
       (concat "/" (string-join org-done-keywords "|")))
      (message "%s subtrees archived." count)))

  (defun ++org-archive-heading-if-all-done (count &optional confirm)
    (unless (++org-undone-children-at-point-p)
      (setq org-map-continue-from (org-element-property :begin (org-element-at-point)))
      (unless (and confirm (not (y-or-n-p (concat (org-get-heading) " - archive this entry? "))))
        (org-archive-subtree-default)
        (+ count 1))))
  
  (defun +org-overview-realign ()
    (interactive)
    (org-overview)
    (save-excursion
      (goto-line 0)
      (recenter)))

  (defun +org-toggle-checkbox-presence ()
    (interactive)
    (let ((current-prefix-arg '(4)))
      (call-interactively #'org-toggle-checkbox)))

  (defun ++org-visual-line-mode ()
    (visual-line-mode)
    (setq-local display-line-numbers 'visual)))

(provide 'org-mode)
