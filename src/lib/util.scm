(define (square n)
  (* n n))

(define (even? n)
  (= (remainder n 2) 0))

(define (expt b n)
  (cond ((= n 0) 1)
        ((even? n) (square (expt b (/ n 2))))
        (else (* b (expt b (- n 1))))))
