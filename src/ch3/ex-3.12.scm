; immutable

(define (append x y)
  (if (null? x)
      y
      (cons (car x) (append (cdr x) y))))

; mutable

(define (append! x y)
  (set-cdr! (last-pair x) y)
  x)

(define (last-pair x)
  (if (null? (cdr x))
      x
      (last-pair (cdr x))))

(define x (list 'a 'b))
(define y (list 'c 'd))
(define z (append x y))

(display (cdr x)) ; (b)

(define w (append! x y))

(display (cdr x)) ; (b c d)
