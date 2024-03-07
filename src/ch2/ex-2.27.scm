(load "./src/lib/util.scm")

(define (deep-reverse items)
  (cond ((null? items) nil)
        ((not (pair? items)) items)
        (else
          (append (deep-reverse (cdr items))
                  (cons (deep-reverse (car items)) nil)))))

(define x (list (list 1 2) (list 3 4)))

; (display (reverse x)) ; ((3 4) (1 2))
; (display (deep-reverse x)) ; ((4 3) (2 1))
