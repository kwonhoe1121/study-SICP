; [참고답안] - permanent-set?

;; In analyze adds
((permanent-set? expr) (analyze-permanent-set expr))

;; add those code.
(define (permanent-set? expr) (tagged-list? expr 'permanent-set!))

(define (analyze-permanent-set expr)
  (let ((var (assignment-variable expr))
        (vproc (analyze (assignment-value expr))))
       (lambda (env succeed fail)
               (vproc env
                      (lambda (val fail2)
                              (set-variable-value! var val env)
                              (succeed 'ok  fail2))
                      fail))))
