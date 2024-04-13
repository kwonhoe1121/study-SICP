; [참고답안]

;; '(a b c) is equal to (quote (a b c)). so we should change the code in text-of-quotation like this. 

(define prev-eval eval)

(define (eval expr env)
  (if (quoted? expr)
      (text-of-quotation expr env)
      (prev-eval expr env)))

(define (quoted? expr) (tagged-list? expr 'quote))

(define (text-of-quotation expr env)
  (let ((text (cadr expr)))
       (if (pair? text)
           (evaln (make-list text) env)
           text)))

(define (make-list expr)
  (if (null? expr)
      (list 'quote '())
      (list 'cons
            (list 'quote (car expr))
            (make-list (cdr expr)))))
