(load "./src/ch3/stream/stream.scm")

; // i <= j 이고 i+j 가 소수인 모든 정수 쌍 (i, j)의 스트림을 산출하는 함수

(define int-pairs (pairs integers integers))

(define (prime-sum-pairs)
  (stream-filter 
     (lambda (pair)
       (prime? (+ (car pair) (cadr pair))))
     int-pairs))

