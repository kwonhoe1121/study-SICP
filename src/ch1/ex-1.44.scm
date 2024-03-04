(load "./src/lib/util.scm")

(define (smooth f)
  (define dx 0.00001)
  (lambda (x)
    (/ (+ (f (- x dx))
          (f x)
          (f (+ x dx)))
       3)))

(define (smooth-nth f n)
  ((repeated smooth n) f))
