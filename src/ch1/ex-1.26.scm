(define (expmod base exp m)
  (cond ((= exp 0) 1)
        ((even? exp)
         (remainder 
          ; * instead of square
          (* (expmod base (/ exp 2) m)
             (expmod base (/ exp 2) m))
          m))
        (else
         (remainder 
          (* base 
             (expmod base (- exp 1) m))
          m))))

; O(n)
; (* (* (expmod base (/ exp 2) m)
;       (expmod base (/ exp 2) m))
;    (* (expmod base (/ exp 2) m)
;       (expmod base (/ exp 2) m)))

; O(log(n))
; (square (square expmod base (/ exp 2) m))
