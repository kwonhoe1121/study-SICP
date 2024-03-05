(load "./src/ch2/ex-2.2.scm")

; 사각형

(define (make-rectangular width height) (cons width height))
(define (width-rectangular x) (car x))
(define (height-rectangular x) (cdr x))

(define (perimeter-rectangular x)
  (let ((width (width-rectangular x))
        (height (height-rectangular x)))
    (+ (double (distance-segment width))
       (double (distance-segment height)))))

(define (area-rectangular x)
  (let ((width (width-rectangular x))
        (height (height-rectangular x)))
    (* (distance-segment width)
       (distance-segment height))))

; (define width (make-segment (make-point 0 0)
;                             (make-point 5 0)))
; (define height (make-segment (make-point 0 0)
;                              (make-point 3 0)))
; (define rectangular (make-rectangular width height))

; (perimeter-rectangular rectangular)
; (area-rectangular rectangular)
