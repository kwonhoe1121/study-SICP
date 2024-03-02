(load "./src/ch1/ex-1.3.scm")

(define (even? n)
  (= (remainder n 2) 0))

(define (expt b n)
  (if (= n 0)
    1
    (* b (expt b (- n 1)))))

(define (expt-iter b n)
  (define (iter b counter product)
    (if (= counter 0)
      product
      (iter b
            (- counter 1)
            (* b product))))
  (iter b n))

(define (fast-expt b n)
  (cond ((= n 0) 1)
        ((even? n) (square (fast-expt b (/ n 2))))
        (else (* b (fast-expt b (- n 1))))))

(define (fast-expt-iter b n)
  (define (iter a e count)
    (cond ((> count n) a)
          ((even? count) (iter (* (square b) e)
                               (* (square b) e)
                               (+ count 1)))
          (else (iter (* a b)
                      e
                      (+ count 1)))))
  (iter 1 1 1))
