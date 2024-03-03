(load "./src/lib/util.scm")

(define (timed-prime-test n)
  (newline)
  (display n)
  (start-prime-test n (runtime)))

(define (start-prime-test n start-time)
  (if (fast-prime? n 100)
      (report-prime (- (runtime) 
                       start-time))))

(define (report-prime elapsed-time)
  (display " *** ")
  (display elapsed-time))

(define (search-for-primes lower)
  (define (iter n count)
    (cond ((= count 3) (newline))
          ((fast-prime? n 100) ; O(log(n))
           (timed-prime-test n)
           (iter (+ n 1) (+ count 1)))
          (else
            (iter (+ n 1) count))))
  (iter lower 0))

; --> O(log(n)) 배 증가함을 확인할 수 있음
; ex) n: 1,000 -> 1,000,000
;     ratio: log(10^6)/log(10^3) ~> 2배

; (search-for-primes 10)
; 11 *** 19
; 13 *** 15
; 17 *** 15

; (search-for-primes 1000)
; 1009 *** 34
; 1013 *** 39
; 1019 *** 42

; (search-for-primes 10000)
; 10007 *** 45
; 10009 *** 45
; 10037 *** 47

; (search-for-primes 100000)
; 100003 *** 65
; 100019 *** 68
; 100043 *** 51

; (search-for-primes 1000000)
; 1000003 *** 61
; 1000033 *** 63
; 1000037 *** 63

; (search-for-primes 10000000)
; 10000019 *** 82
; 10000079 *** 76
; 10000103 *** 77

; (search-for-primes 100000000)
; 100000007 *** 95
; 100000037 *** 87
; 100000039 *** 90
