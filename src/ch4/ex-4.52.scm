; [참고답안] - if-fail

;; add this in analyze
((if-fail? expr) (analyze-if-fail expr))

;; add those to amb evaluator
(define (if-fail? expr) (tagged-list? expr 'if-fail))

(define (analyze-if-fail expr)
  (let ((first (analyze (cadr expr)))
        (second (analyze (caddr expr))))
       (lambda (env succeed fail)
               (first env
                      (lambda (value fail2)
                              (succeed value fail2))
                      (lambda ()
                              (second env succeed fail))))))
