(load "./src/ch3/table/memoize.scm")

; O(n^2)

(define (fib n)
  (cond ((= n 0) 0)
        ((= n 1) 1)
        (else (+ (fib (- n 1))
                 (fib (- n 2))))))

(fib 10)

; O(n)

(define memo-fib
  (memoize 
   (lambda (n)
     (cond ((= n 0) 0)
           ((= n 1) 1)
           (else 
            (+ (memo-fib (- n 1))
               (memo-fib (- n 2))))))))

(memo-fib 10)

(define memo-fib-2 (memoize fib))

(memo-fib-2 10)
