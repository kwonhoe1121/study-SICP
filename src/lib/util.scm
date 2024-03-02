(define (square n)
  (* n n))

(define (even? n)
  (= (remainder n 2) 0))

(define (expt b n)
  (cond ((= n 0) 1)
        ((even? n) (square (expt b (/ n 2))))
        (else (* b (expt b (- n 1))))))

(define (double x) (+ x x)) 
(define (halve x) (/ x 2))

; gcd(a, b) = gcd(b, r)
(define (gcd a b)
  (if (= b 0)
    a
    (gcd b (remainder a b))))
