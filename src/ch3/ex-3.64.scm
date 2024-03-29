(load "./src/ch3/stream/stream.scm")

(define (stream-limit s tolerance)
  (let ((s1 (stream-ref s 0))
        (s2 (stream-ref s 1)))
    (if (< (abs (- s2 s1))
           tolerance)
      s2
      (stream-limit (stream-cdr s) tolerance))))

(define (sqrt x tolerance)
  (stream-limit (sqrt-stream x) tolerance))
