; 생성된 변수는 어휘순 범위를 따르고 현재 프레임에 생성되기 때문에, 현재 프레임에서만 찾으면 된다.

; [참고답안]

(define (make-unbound! var env)
  (let* ((frame (first-frame env))
         (vars (frame-variables frame))
         (vals (frame-values frame)))
        (define (scan pre-vars pre-vals vars vals)
          (if (not (null? vars))
              (if (eq? var (car vars))
                  (begin (set-cdr! pre-vars (cdr vars))
                         (set-cdr! pre-vals (cdr vals)))
                  (scan vars vals (cdr vars) (cdr vals)))))
        (if (not (null? vars))
            (if (eq? var (car vars))
                (begin (set-car! frame (cdr vars))
                       (set-cdr! frame (cdr vals)))
                (scan vars vals (cdr vars) (cdr vals))))))


;; unbound variable in current frame
(define (unbound? expr) (tagged-list? expr 'unbound))
(define (unbind-variable expr env) (make-unbound (cadr expr) env))
(define (make-unbound variable env)
  (let ((vars (frame-variables (first-frame env)))
        (vals (frame-values (first-frame env))))
       (define (unbound vars vals new-vars new-vals)
         (cond ((null? vars)
                (error "variable is not in the environment -- MAKE-UNBOUND"

                       variable))
               ((eq? (car vars) variable)
                (set-car! env
                          (cons (append new-vars (cdr vars))
                                (append new-vals (cdr vals)))))
               (else (unbound (cdr vars) (cdr vals)
                              (cons (car vars) new-vars)
                              (cons (car vals) new-vals)))))
       (unbound vars vals '() '())))

;; add this in eval
((unbound? expr) (unbind-variable expr env))
