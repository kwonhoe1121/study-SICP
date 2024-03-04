(load "./src/lib/util.scm")

; x |-> 1 + 1/x
(define (phi)
  (fixed-point
    (lambda (x) (+ 1 (/ 1 x)))
    1.0))

(define (phi)
  (fixed-point
    (lambda (x) (average x (+ 1 (/ 1 x)))) ; average damping
    1.0))

(phi) ; 1.6180327868852458
