(load "./src/lib/util.scm")

(define (timed-prime-test n)
  (newline)
  (display n)
  (start-prime-test n (runtime)))

(define (start-prime-test n start-time)
  (if (prime? n)
      (report-prime (- (runtime) 
                       start-time))))

(define (report-prime elapsed-time)
  (display " *** ")
  (display elapsed-time))

(define (search-for-primes lower)
  (define (iter n count)
    (cond ((= count 3) (newline))
          ((prime? n) ; O(√n)
           (timed-prime-test n)
           (iter (+ n 1) (+ count 1)))
          (else
            (iter (+ n 1) count))))
  (iter lower 0))

; --> √(10) 배 ~= 3.1622776601683795

;(search-for-primes 10)
; 11 *** 1
; 13 *** 0
; 17 *** 0

;(search-for-primes 1000)
; 1009 *** 1
; 1013 *** 0
; 1019 *** 1

;(search-for-primes 10000)
; 10007 *** 2
; 10009 *** 2
; 10037 *** 1

;(search-for-primes 100000)
; 100003 *** 5
; 100019 *** 3
; 100043 *** 3

;(search-for-primes 1000000)
; 1000003 *** 14
; 1000033 *** 10
; 1000037 *** 10

;(search-for-primes 10000000)
; 10000019 *** 37
; 10000079 *** 30
; 10000103 *** 29

;(search-for-primes 100000000)
; 100000007 *** 98
; 100000037 *** 98
; 100000039 *** 99
