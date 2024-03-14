(load "./src/ch2/ex-2.56.scm")

(define (augend s)
  (fold-right
    make-sum
    0
    (cddr s)))

(define (multiplicand p)
  (fold-right
    make-product
    1
    (cddr p)))

; (display (deriv '(* x y (+ x 3)) 'x))
