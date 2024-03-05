; 점

(define (make-point x y) (cons x y))
(define (x-point point) (car point))
(define (y-point point) (cdr point))

(define (mid-point p1 p2)
  (make-point
    (/ (+ (x-point p1) (x-point p2)) 2)
    (/ (+ (y-point p1) (y-point p2)) 2)))


; 선

(define (make-segment start end) (cons start end))
(define (start-segment segment) (car segment))
(define (end-segment segment) (cdr segment))

(define (print-point p)
  (newline)
  (display "(")
  (display (x-point p))
  (display ",")
  (display (y-point p))
  (display ")"))

(define (midpoint-segment segment)
  (let ((start (start-segment segment))
        (end (end-segment segment)))
    (mid-point start end)))

; (define start (make-point 1 2))
; (define end (make-point 5 6))
; (define segment (make-segment start end))

; (print-point (midpoint-segment segment))
