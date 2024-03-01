(define (f n)
  (if (< n 3)
    n
    (+ (f (- n 1))
       (* 2 (f (- n 2)))
       (* 3 (f (- n 3))))))

(define (f-iter n)
  (define (iter a b c count)
    (cond ((< n 3) n)
          ((= count 0) a)
          (else (iter (+ a (* 2 b) (* 3 c))
                      a
                      b
                      (- count 1)))))
  (iter 2 1 0 (- n 2)))

(f-iter 10) ; 1892
