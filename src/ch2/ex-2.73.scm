(load "./src/ch2/symbolic-differentiation.scm")

(define (deriv exp var)
   (cond ((number? exp) 0)
         ((variable? exp) 
           (if (same-variable? exp var) 
               1 
               0))
         (else ((get 'deriv (operator exp)) 
                (operands exp) 
                var))))

(define (operator exp) (car exp))
(define (operands exp) (cdr exp))

(define (install-deriv-package)
  (define (deriv-sum operands variable)
    (make-sum
      (deriv (addend operands) variable)
      (deriv (augend operands) variable)))

  (define (deriv-product operands variable)
    (make-sum
      (make-product
        (multiplier operands)
        (deriv ((multiplicand operands) variable)))
      (make-product
        (deriv ((multiplier operands) variable))
        (multiplicand operands))))

  (define (deriv-exponentiation operands variable)
    (let ((b (base operands))
          (e (exponent operands)))
      (make-product
        e
        (make-product
          (make-exponentiation b (make-sum e (- 1)))
          (deriv b variable)))))

  (put 'deriv '+ deriv-sum)
  (put 'deriv '* deriv-product)
  (put 'deriv '** deriv-exponentiation)

  'done)
