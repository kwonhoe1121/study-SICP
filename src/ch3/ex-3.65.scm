(load "./src/ch3/stream/stream.scm")

; ln2 = 1 - 1/2 + 1/3 - 1/4 + ...

; (1)

(define (natural-logarithm-summands n)
  (cons-stream
    (/ 1.0 n)
    (stream-map - (natural-logarithm-summands (+ n 1)))))

(define natural-logarithm-stream
  (partial-sums
    (natural-logarithm-summands 1)))

(display-stream natural-logarithm-stream)

; (2)

(display-stream (euler-transform natural-logarithm-stream))

; (3)

(display-stream
  (accelerated-sequence
    euler-transform
    natural-logarithm-stream))
