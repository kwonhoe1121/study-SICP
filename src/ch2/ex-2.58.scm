(load "./src/ch2/symbolic-differentiation.scm")

; (a)

(define (make-sum a1 a2)
  (cond ((=number? a1 0) a2)
        ((=number? a2 0) a1)
        ((and (number? a1) (number? a2))
         (+ a1 a2))
        (else (list a1 '+  a2)))) ; infix form
(define (make-product m1 m2)
  (cond ((or (=number? m1 0) 
             (=number? m2 0)) 
         0)
        ((=number? m1 1) m2)
        ((=number? m2 1) m1)
        ((and (number? m1) (number? m2)) 
         (* m1 m2))
        (else (list m1 '* m2)))) ; infix form
(define (sum? x)
  (and (pair? x) (eq? (cadr x) '+)))
(define (product? x)
  (and (pair? x) (eq? (cadr x) '*)))
(define (addend s) (car s))
(define (multiplier p) (car p))

; (display (deriv (list 'x '+ (list 3 '* (list 'x '+ (list 'y '+ 2)))) 'x))

; (b)

; (define (items-before-first op s)
;   (if (eq? (car s) op)
;     nil
;     (cons (car s)
;           (items-before-first op (cdr s)))))
; (define (items-after-first op s)
;   (if (eq? (car s) op)
;     (cdr s)
;     (items-after-first op (cdr s))))
; (define (sum? x) (and (pair? x) (not (null? (memq '+ x)))))
; (define (addend s) (items-before-first '+ s))
; (define (augend s) (items-after-first '+ s))
; (define (product? x) (and (pair? x) (null? (memq '+ x))))
; (define (multiplier p) (items-before-first '* s))
; (define (multiplicand s) (items-after-first '* s))

; (display (deriv (list 'x '* 4) 'x))
; (display (deriv (list 'x '+ 3 '* (list 'x 'y '+ 2)) 'x))
