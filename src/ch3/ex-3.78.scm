; /*
;      d^2 y       dy
;     ------- - a ---- - by = 0
;      d t^2       dt
; */

(define (solve-2nd a b dy0 y0 dt)
  (define y (integral (delay dy) y0 dt))
  (define dy (integral (delay ddy) dy0 dt))
  (define ddy (add-streams (scale-stream dy a)
                           (scale-stream y b)))
  y)
