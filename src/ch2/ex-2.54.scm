(load "./src/lib/util.scm")

(define (equal? xs ys)
  (if (pair? xs)
    (and (pair? ys)
         (equal? (car xs) (car ys))
         (equal? (cdr xs) (cdr ys)))
    (eq? xs ys)))

; (equal? '(this is a list) 
;         '(this is a list))

; (equal? '(this is a list) 
;         '(this (is a) list))
