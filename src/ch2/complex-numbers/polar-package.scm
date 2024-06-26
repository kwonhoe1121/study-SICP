(load "./src/lib/util.scm")

(define (install-polar-package)
  ;; internal procedures
  (define (magnitude z) (car z))
  (define (angle z) (cdr z))
  (define (make-from-mag-ang r a) (cons r a))
  (define (real-part z)
    (* (magnitude z) (cos (angle z))))
  (define (imag-part z)
    (* (magnitude z) (sin (angle z))))
  (define (make-from-real-imag x y)
    (cons (sqrt (+ (square x) (square y)))
          (atan y x)))
  (define (polar-polar-equ? z1 z2)
    (and (= (magnitude z1) (magnitude z2))
         (= (angle z1) (angle z2))))
  (define (polar-rectangular-equ? z1 z2)
    (and (= (real-part z1) ((get 'real-part 'rectangular) z2))
         (= (imag-part z1) ((get 'imag-part 'rectangular) z2))))
  (define (rectangular-polar-equ? z1 z2)
    (and (= ((get 'real-part 'rectangular) z1) (real-part z2))
         (= ((get 'imag-part 'rectangular) z1) (imag-part z2))))
  (define (=zero? x)
    (and (= (magnitude x) 0)
         (= (angle x) 0)))
  ;; interface to the rest of the system
  (define (tag x) (attach-tag 'polar x))
  (put 'real-part '(polar) real-part)
  (put 'imag-part '(polar) imag-part)
  (put 'magnitude '(polar) magnitude)
  (put 'angle '(polar) angle)
  (put 'equ? '(polar polar) polar-polar-equ?)
  (put 'equ? '(polar rectangular) polar-rectangular-equ?)
  (put 'equ? '(rectangular polar) rectangular-polar-equ?)
  (put '=zero? '(polar) =zero?)
  (put 'make-from-real-imag 'polar
       (lambda (x y) 
         (tag (make-from-real-imag x y))))
  (put 'make-from-mag-ang 'polar
       (lambda (r a) 
         (tag (make-from-mag-ang r a))))
  'done)
