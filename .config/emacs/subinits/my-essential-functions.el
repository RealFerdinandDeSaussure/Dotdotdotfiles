;; -*- lexical-binding: t -*-

;; this includes all functions that need to be available right away and not via
;; autoload

(defun +concat-symbols (&rest symbols)
  "Concatenate SYMBOLS together to form a single symbol."
  (intern (apply #'concat (mapcar #'symbol-name symbols))))

(provide 'my-essential-functions)
