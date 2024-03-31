; eval 프로시저를 데이터 지향적으로 변경 - wishful thinking

(define (eval exp env)
  (cond ((get 'eval (operator exp))
         ((operands exp)
          env))
        (else
          (error "Unknown expression
                 type: EVAL" exp))))

(define (operator exp) (car exp))
(define (operands exp) (cdr exp))

(define (install-eval-package)
  (define (eval-self exp) exp)
  (define (eval-variable exp env) (lookup-variable-value exp env))
  (define (eval-quoted exp env) (text-of-quotation exp))
  (define (eval-assignment exp env) (eval-assignment exp env))
  (define (eval-definition exp env) (eval-definition exp env))
  (define (eval-if exp env) (eval-if exp env))
  (define (eval-lambda exp env)
    (make-procedure
      (lambda-parameters exp)
      (lambda-body exp)
      env))
  (define (eval-sequence exp env)
    (eval-sequence
      (begin-actions exp)
      env))
  (define (eval-application exp env)
    (apply (eval (operator exp) env)
           (list-of-values
             (operands exp)
             env)) )

  (put 'eval 'self eval-self)
  (put 'eval 'variable eval-variable)
  (put 'eval 'quoted eval-quoted)
  (put 'eval 'assignment eval-assignment)
  (put 'eval 'definition eval-definition)
  (put 'eval 'if eval-if)
  (put 'eval 'lambda eval-lambda)
  (put 'eval 'begin eval-begin)
  (put 'eval 'cond eval-cond)
  (put 'eval 'application eval-application)
  'done)

; [참고답안]

(define operation-table make-table)
(define get (operation-table 'lookup-proc))
(define put (operation-table 'insert-proc))

(put 'op 'quote text-of-quotation)
(put 'op 'set! eval-assignment)
(put 'op 'define eval-definition)
(put 'op 'if eval-if)
(put 'op 'lambda (lambda (x y)
                         (make-procedure (lambda-parameters x) (lambda-body x) y)))
(put 'op 'begin (lambda (x y)
                        (eval-sequence (begin-sequence x) y)))
(put 'op 'cond (lambda (x y)
                       (evaln (cond->if x) y)))

(define (eval expr env)
  (cond ((self-evaluating? expr) expr)
        ((variable? expr) (lookup-variable-value expr env))
        ((get 'op (operator expr)) ((get 'op (operator expr)) expr env))
        ((application? expr)
         (apply (eval (operator expr) env)
                (list-of-values (operands expr) env)))
        (else (error "Unknown expression type -- EVAL" expr))))
