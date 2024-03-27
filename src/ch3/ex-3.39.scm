(define x 10)
(define s (make-serializer))

(parallel-execute 
  (lambda () 
    (set! x ((s (lambda () (* x x))))))
  (s (lambda () (set! x (+ x 1)))))

; (lambda (0) (* x x)) := a
; (lambda () (set! x (+ x 1))) := b
; (set! x ...) := c

; a -> b -> c := 10
; b -> a -> c := 121
; a -> c -> b := 101
; a, b -> c -> b := 11
