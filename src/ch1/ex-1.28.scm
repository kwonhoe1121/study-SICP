(load "./src/lib/util.scm")
(load "./src/ch1/ex-1.22.scm")

(define (miller-rabin-expmod base exp m)
  (define (squaremod-with-check x)
    (define (check-nontrivial-sqrt1 x square)
      (if (and (= square 1)
               (not (= x 1))
               (not (= x (- m 1))))
          0
          square))
    (check-nontrivial-sqrt1 x (remainder (square x) m)))
  (cond ((= exp 0) 1)
        ((even? exp)
         (squaremod-with-check
                      (miller-rabin-expmod base (/ exp 2) m)))
        (else
         (remainder (* base (miller-rabin-expmod base (- exp 1) m))
                    m))))
 
(define (miller-rabin-test n)
  (define (try-it a)
    (define (check-it x)
      (and (not (= x 0)) (= x 1)))
    (check-it (miller-rabin-expmod a (- n 1) n)))
  (try-it (+ 1 (random (- n 1)))))
 
(define (fast-prime? n times)
  (cond ((= times 0) true)
        ((miller-rabin-test n) (fast-prime? n (- times 1))) ; 밀러-라빈 검사로 변경
        (else false)))

; (search-for-primes 10)
; 11 *** 1
; 13 *** 0
; 17 *** 0

; (search-for-primes 1000)
; 1009 *** 2
; 1013 *** 1
; 1019 *** 1

; (search-for-primes 10000)
; 10007 *** 2
; 10009 *** 1
; 10037 *** 1

; (search-for-primes 100000)
; 100003 *** 5
; 100019 *** 3
; 100043 *** 3

; (search-for-primes 1000000)
; 1000003 *** 14
; 1000033 *** 9
; 1000037 *** 9

; (search-for-primes 10000000)
; 10000019 *** 35
; 10000079 *** 35
; 10000103 *** 34

; (search-for-primes 100000000)
; 100000007 *** 105
; 100000037 *** 99
; 100000039 *** 99
