(load "./src/lib/util.scm")

(define (tan-cf x k)
  (cont-frac (lambda (i)
               (if (= i 1)
                 x
                 (- (square x))))
             (lambda (i) (- (* 2 i) 1))
             k))

; (tan-cf 45.0 100)
