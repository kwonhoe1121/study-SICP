(load "./src/lib/util.scm")

(define (nth-root n)
  (lambda (x)
    (fixed-point-of-transform
      (lambda (y) (/ x (expt y (- n 1))))
      (repeated average-damp (floor (log n 2)))
      1.0)))

; ((nth-root 2) 4)
; (sqrt 4)
