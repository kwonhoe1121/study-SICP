(load "./src/ch1/ex-1.42.scm")

(define (repeated f n)
  (if (= n 1)
    f
    (compose f (repeated f (- n 1)))))

; ((repeated square 2) 5) ; 625
