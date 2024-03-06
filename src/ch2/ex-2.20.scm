(load "./src/lib/util.scm")

; (define (same-parity . items)
;   (let ((filter (if (even? (car items)) even? odd?)))
;     (define (iter rest result)
;       (if (null? rest)
;         result
;         (if (filter (car rest))
;           (iter (cdr rest) (append result (list (car rest))))
;           (iter (cdr rest) result))))
;     (iter items '())))

(define (same-parity head . rest)
  (let ((filter (if (even? head) even? odd?)))
    (define (iter rest result)
      (if (null? rest)
        result
        (if (filter (car rest))
          (iter (cdr rest) (append result (list (car rest))))
          (iter (cdr rest) result))))
    (iter (cons head rest) '())))

; (display (same-parity 1 2 3 4 5 6 7))
; (display (same-parity 2 3 4 5 6 7))
