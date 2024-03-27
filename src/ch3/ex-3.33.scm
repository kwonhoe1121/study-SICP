(load "./src/ch3/constraint-propagation/connector.scm")
(load "./src/ch3/constraint-propagation/primitive-constraint.scm")

; (a + b) / 2 = c
; a + b = 2 * c

(define (averager a b c)
  (let ((u (make-connector))
        (v (make-connector)))
    (adder a b u)
    (multiplier c v u)
    (constant 2 v)
    'ok))


(define A (make-connector)) 
(define B (make-connector)) 
(define C (make-connector)) 

(averager A B C) 

(probe 'C C)
  
(set-value! A 100 'user) 

(set-value! B 0 'user)
