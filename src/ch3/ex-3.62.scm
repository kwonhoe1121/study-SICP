(load "./src/ch3/stream/stream-infinite.scm")

; [참고답안]

(define (div-series s1 s2)
  (let ((c (stream-car s2)))
    (if (= c 0)
        (error "constant term of s2 can't be 0!")
        (scale-stream
          (mul-series
            s1
            (invert-unit-series
              (scale-stream
                s2
                (/ 1 c))))
          (/ 1 c)))))

(define tangent-series
  (div-series sine-series cosine-series))
