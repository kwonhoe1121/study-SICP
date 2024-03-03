(load "./src/lib/util.scm")
(load "./src/ch1/ex-1.16.scm")
(load "./src/ch1/ex-1.25.scm")

(define (expmod base exp m)
  (remainder (fast-expt base exp) m)) ; 변경 사항

; 부분식에서 remainder 연산자들이 적용되지 않고 최종적으로 한번 적용된다.
; 원래 expmod 구현의 나머지 연산은 원시성 m에 대해 테스트된 숫자보다 작은 제곱을 유지하지만, fast-except는 a^m 크기의 큰 숫자를 제곱합니다.
; 계산 비용이 증가한다.

; (search-for-primes 10)
; (search-for-primes 1000)
; (search-for-primes 10000)
; (search-for-primes 100000)
; (search-for-primes 1000000)
; (search-for-primes 10000000)
; (search-for-primes 100000000)
