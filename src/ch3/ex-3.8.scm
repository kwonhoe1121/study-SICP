(define (make-f init)
  (let ((state init))
    (lambda (x)
      (begin
        (set! state (- x state))
        state))))

(define f (make-f 0))

; (+ (f 0) (f 1)) ; 1

; (+ (f 1) (f 0)) ; 0
