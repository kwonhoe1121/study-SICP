(load "./src/ch3/stream/stream.scm")
(load "./src/ch3/stream/stream-module.scm")

; ex-3.5 구현 방식과 비교할 것

(define (estimate-integral p x1 x2 y1 y2)
  (define (make-stream)
    (cons-stream (p (random-in-range x1 x2)
                    (random-in-range y1 y2))
                 (random-number-pairs p x1 x2 y1 y2)))
  (let ((area (* (- x2 x1) (- y2 y1)))
        (stream (make-stream)))
       (scale-stream (monte-carlo stream 0 0) area)))
