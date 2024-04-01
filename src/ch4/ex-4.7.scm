; (let* ((x 3)
;        (y (+ x 2))
;        (z (+ x y 5)))
;   (* x z))

; (let ((x 3))
;   (let ((y (+ x 2)))
;     (let ((z (+ x y 5)))
;       (* x z))))

; ((((lambda (x)
;            (lambda (y)
;                    (lambda (z)
;                            (* x z))))
;    3)
;   (+ x 2))
;  (+ x y 5))

; [참고답안]

;; let* expression
(define (let*? expr) (tagged-list? expr 'let*))
(define (let*-body expr) (caddr expr))
(define (let*-inits expr) (cadr expr))
(define (let*->nested-lets expr)
  (let ((inits (let*-inits expr))
        (body (let*-body expr)))
       (define (make-lets exprs)
         (if (null? exprs)
             body
             (list 'let (list (car exprs)) (make-lets (cdr exprs)))))
       (make-lets inits)))
