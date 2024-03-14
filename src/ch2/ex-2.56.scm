(load "./src/ch2/symbolic-differentiation.scm")

(define (deriv exp var)
  (cond ((number? exp) 0)
        ((variable? exp)
         (if (same-variable? exp var) 1 0))
        ((sum? exp)
         (make-sum (deriv (addend exp) var)
                   (deriv (augend exp) var)))
        ((product? exp)
         (make-sum
          (make-product 
           (multiplier exp)
           (deriv (multiplicand exp) var))
          (make-product 
           (deriv (multiplier exp) var)
           (multiplicand exp))))
        ((exponentiation? exp)
         (make-product
           (make-product (exponent exp)
                         (make-exponentiation (base exp)
                                              (- (exponent exp) 1)))
           (deriv (base exp) var)))
        (else (error "unknown expression 
                      type: DERIV" exp))))

; (define (make-exponentiation base exponent) (list '** base exponent))
(define (make-exponentiation base exponent)
  (cond ((=number? exponent 1) base)
        ((=number? exponent 0) 1)
        (else (list '** base exponent))))
(define (exponentiation? x) (and (pair? x) (eq? (car x) '**)))
(define (base x) (cadr x))
(define (exponent x) (caddr x))

; (display (deriv (list '** 'x 4) 'x)) ;(* 4 (** x 3))
