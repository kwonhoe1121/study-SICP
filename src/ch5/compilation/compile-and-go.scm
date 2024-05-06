(load "./../explicit-control-evaluator/eceval.scm")
(load "./../register-machine-simulator/assembler.scm")
(load "./compile.scm")

(define (compile-and-go expression)
  (let ((instructions
         (assemble 
          (statements
           (compile 
            expression 'val 'return))
          eceval)))
    (set! the-global-environment (setup-environment))
    (set-register-contents! eceval 'val instructions)
    (set-register-contents! eceval 'flag true)
    (start eceval)))
