(load "./src/ch3/ch3-sample-code.scm")

(define (random-in-range low high)
  (let ((range (- high low)))
    (+ low (random range))))

(define (estimate-integral p x1 x2 y1 y2 trials)
  (let ((area-rect (* (- x2 x1) (- y2 y1))))
    (* area-rect
       (monte-carlo trials (lambda ()
                             (p (random-in-range x1 x2)
                                (random-in-range y1 y2)))))))

(define (inside-unit-circle? x y)
  (<= (+ (square x) (square y))
      1))

; (display (estimate-integral inside-unit-circle? -1 1 -1 1 1000000))
