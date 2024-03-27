(define (c+ x y)
  (let ((z (make-connector)))
    (adder x y z)
    z))

; x - y = z
; x = z + y
(define (c- x y)
  (let ((z (make-wire)))
    (adder z y x)
    z))

(define (c* x y)
  (let ((z (make-wire)))
    (multiplier x y z)
    z))

; x/y = z
; x = zy
(define (c/ x y)
  (let ((z (make-wire)))
    (multiplier z y x)
    z))

(define (cv a)
  (let ((x (make-wire)))
    (constant a x)
    x))

; 9C=5(F−32)
; (9/5)C + 32 = F
(define (celsius-fahrenheit-converter x)
  (c+ (c* (c/ (cv 9) (cv 5))
          x)
      (cv 32)))

(define C (make-connector))
(define F (celsius-fahrenheit-converter C))
