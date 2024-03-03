(load "./src/lib/util.scm")
(load "./src/ch1/ex-1.22.scm")

(define (next n)
  (cond ((= n 2) 3)
        (else (+ n 2))))

(define (find-divisor n test-divisor)
  (cond ((> (square test-divisor) n) n)
        ((divides? test-divisor n) test-divisor)
        (else (find-divisor 
               n 
               (next test-divisor))))) ; 변경 사항

; --> 변경사항으로 2배 빨라졌는가? 아니오! 약 1.25배 빨라짐.

;(search-for-primes 10)
; 11 *** 1
; 13 *** 0
; 17 *** 0

;(search-for-primes 1000)
; 1009 *** 2
; 1013 *** 1
; 1019 *** 0

;(search-for-primes 10000)
; 10007 *** 2
; 10009 *** 1
; 10037 *** 1

;(search-for-primes 100000)
; 100003 *** 4
; 100019 *** 3
; 100043 *** 2

;(search-for-primes 1000000)
; 1000003 *** 11
; 1000033 *** 8
; 1000037 *** 7

;(search-for-primes 10000000)
; 10000019 *** 27
; 10000079 *** 29
; 10000103 *** 30

;(search-for-primes 100000000)
; 100000007 *** 88
; 100000037 *** 79
; 100000039 *** 79
