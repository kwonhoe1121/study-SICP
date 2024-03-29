(load "./src/ch3/ex-3.60.scm")

; X는 상수항이 1이고 그 이후의 항들은 S_R 곱하기 X의 음수인 멱급수이다.

(define (invert-unit-series s)
  (cons-stream
    1
    (stream-map
      (lambda (x) (- x))
      (mul-series
        (stream-cdr s)
        (invert-unit-series s)))))

; [참고답안]

; S = 1 + S_R
; X = 1 - S_R * X

(define (invert-unit-series series)
  (define inverted-unit-series
    (cons-stream 1 (scale-stream (mul-streams (stream-cdr series)
                                              inverted-unit-series)
                                 -1)))
  inverted-unit-series)
