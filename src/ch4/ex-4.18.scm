(define (solve f y0 dt)
  (define y (integral (delay dy) y0 dt))
  (define dy (stream-map f y))
  y)

; scan-out-defines 방식들

; (lambda ⟨vars⟩
;   (let ((u '*unassigned*)
;         (v '*unassigned*))
;     (set! u ⟨e1⟩)
;     (set! v ⟨e2⟩)
;     ⟨e3⟩))

(lambda (f y0 dt)
  (let ((y '*unassigned*)
        (dy '*unassigned*))
    (set! y (integral (delay dy) y0 dt))
    (set! dy (stream-map f y))
    y))

; (lambda ⟨vars⟩
;   (let ((u '*unassigned*)
;         (v '*unassigned*))
;     (let ((a ⟨e1⟩)
;           (b ⟨e2⟩))
;       (set! u a)
;       (set! v b))
;     ⟨e3⟩))

(lambda (f y0 dt)
  (let ((y '*unassigned*)
        (dy '*unassigned*))
    (let ((a (integral (delay dy) y0 dt))
          (b (stream-map f y)))  ; error! 'Unassigned variable y
      (set! y a)
      (set! dy b)
      y)))

; [참고답안]

; This won't work. because, in (let ((a <e1>) (b <e2>))), when compute e2, it depends y, but we only have a not y. For the same reason, the solution in text will work. 
