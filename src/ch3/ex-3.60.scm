(load "./src/ch3/stream/stream.scm")

(define (mul-series s1 s2)
  (cons-stream
    (* (stream-car s1) (stream-car s2))
    (add-streams
      (mul-series (stream-cdr s1) s2)
      (scale-stream (stream-cdr s2) (stream-car s1)))))
