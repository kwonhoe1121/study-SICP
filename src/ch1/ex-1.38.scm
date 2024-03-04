(load "./src/ch1/ex-1.37.scm")

; e = 2 + cont-frac(k)
(define (e-euler k)
  (+ 2.0
     (cont-frac (lambda (i) 1.0)
                (lambda (i)
                  (if (= (remainder i 3) 2)
                    (/ (+ i 1) 1.5)
                    1.0))
                k)))

; (e-euler 1000) ; 2.7182818284590455
