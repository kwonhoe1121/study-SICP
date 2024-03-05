; cons := (a, b) => 2^a*3^b

(define (cons a b) (lambda (f) (f (* a a) (* b b b))))
(define (car f) (f (lambda (a, _) a)))
(define (cdr f) (f (lambda (_, b) b)))

; (car (cons a b))
; (car (lambda (f) (f (* a a) (* b b b))))
; ((lambda (f) (f (* a a) (* b b b))) (lambda (a, _) a))
; ((lambda (a, _) a) (* a a) (* b b b))
; (* a a)

; (cdr (cons a b))
; (cdr (lambda (f) (f (* a a) (* b b b))))
; ((lambda (f) (f (* a a) (* b b b))) (lambda (_, b) b))
; ((lambda (_, b) b) (* a a) (* b b b))
; (* b b b)
