(define (add-1 n)
  (lambda (f) (lambda (x) (f ((n f) x)))))

; (add_1 zero)
(define zero (lambda (f) (lambda (x) x)))

; (add_1 one)
(define one
  (lambda (f)
    (lambda (x) (f x))))

; (add_1 two)
(define two
  (lambda (f)
    (lambda (x) (f (f x)))))

; (plus one two) ::= (f (f (f x)))
(define (plus a b)
  (lambda (f)
    (lambda (x)
      ((a f) (b f x)))))

; (plus one two)
; (plus (lambda (f) (lambda (x) (f x)))
;       (lambda (f) (lambda (x) (f (f x)))))
; (lambda (x)
;       (((lambda (f) (lambda (x) (f x))) f) ((lambda (f) (lambda (x) (f (f x)))) f x)))
; (lambda (x) ((lambda (x) (f x)) (f (f x))))
; (lambda (x) (f (f (f x))))
