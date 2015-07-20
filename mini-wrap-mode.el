;;; mini-wrap-mode.el --- define the minor mode mini-wrap-mode
;;
;; 07/20/2015: init commit
;;
;; TODO:
;; * add history to wrap-word used
;; * make mini-wrap-special-word customable and document it

(defvar mini-wrap-special-word (make-hash-table :test 'equal))
(puthash "(" ")" mini-wrap-special-word)
(puthash "<" ">" mini-wrap-special-word)
(puthash "/*" "*/" mini-wrap-special-word)

(defun mini-wrap-word-or-region (wrap-symb)
  " wrap a word with WRAP-SYMB"
  (interactive
   (list (read-string "wrap symbol ?: ")))
  (save-excursion
    (if (not (region-active-p))
        (progn
          (let (
                (word-to-wrap (current-word))
                )
            (backward-word)
            ;; check if we are still on the right word
            (if (not (string-equal (current-word) word-to-wrap))
                (progn
                  (forward-word)
                  (forward-word)
                  (backward-word)
                  )))
          (push-mark)
          (forward-word)))
    (progn
      (if (> (point) (mark)) (exchange-point-and-mark))
      (insert wrap-symb)
      (exchange-point-and-mark)
      (let ((special-warp-word (gethash wrap-symb mini-wrap-special-word nil)) )
        (if special-warp-word
            (insert special-warp-word)
          (insert wrap-symb))))))

(define-minor-mode mini-wrap-mode
  "wrap a word with any string you want. If you choose to a
special string define in hash's keys of `mini-wrap-special-word,
it is automatically wrap the word with the word key and value"
  :lighter " mini-wrap"
  :global t
  :keymap (let ((map (make-sparse-keymap)))
            (define-key map (kbd "C-c C-w") 'mini-wrap-word-or-region)
            map))

(add-hook 'text-mode-hook 'mini-wrap-mode)

(provide 'mini-wrap-mode)

;; mini-wrap-mode.el ends here
