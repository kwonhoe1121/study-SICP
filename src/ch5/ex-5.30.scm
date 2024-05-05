; 시스템 에러 처리

; (a) - 계산 프로세스에서 나타날 수 있는 에러
;; lookup 연산을 고쳐 식별할 수 있는 조건 코드를 리턴하도록 할 수 있다.
;; ex) - unbounded variable

;; if the variable is unbounded, cons 'unbound with it;
;; otherwise, cons 'bounded with it. then we can use
;; car to judge it's bounded or not.
(define (lookup-variable-value var env)
  (define (env-loop env)
    (define (scan vars vals)
      (cond ((null? vars)
             (env-loop (enclosing-environment env)))
            ((eq? var (car vars))
             (cons 'bounded (car vals)))              ;; ****
            (else (scan (cdr vars) (cdr vals)))))
    (if (eq? env the-empty-environment)
        (cons 'unbounded '())                        ;; ***
        (let ((frame (first-frame env)))
             (scan (frame-variables frame)
                   (frame-values frame)))))
  (env-loop env))
(define (bound-variable? var)
  (and (pair? var) (eq? (car var) 'bounded)))
(define (extract-variable-value var)
  (cdr var))
  
ev-variable 
 (assign val (op lookup-variable-value) (reg exp) (reg env)) 
 (test (op bound-variable?) (reg val)) 
 (branch (label bound-variable)) 
 (assign val (const unbounded-variable-error)) 
 (goto (label signal-error))  
bound-variable 
 (assign val (op extract-variable-value) (reg val)) 
 (goto (reg continue)) 

; (b) - 기본 프로시저의 적용 시 나타날 수 있는 에러
;; 각 기본 프로시저에 대한 적용 가능성을 검사하고 실패 시 알맞은 조건 코드를 리턴하도록 레지스터 기계 시뮬레이터를 설정할 수 있다.
;; ex) - 0으로 나누는 경우, 기호에서 car를 가져오는 것 등.

(define safe-primitives (list car cdr /))

(define (apply-primitive-procedure proc args)
  (let ((primitive (primitive-implementation proc)))
       (if (member primitive safe-primitives)
           (safe-apply primitive args)     ; ex 5.30 b
           (apply-in-underlying-scheme
             primitive args))))

(define (safe-apply proc args)          ; ex 5.30 b
  (cond ((or (eq? proc car)
             (eq? proc cdr))
         (safe-car-cdr proc args))
        ((eq? proc /)
         (safe-division proc args))
        (else
          (list 'primitive-error proc args))))

(define (primitive-error? val)          ; ex 5.30 b
  (tagged-list? val 'primitive-error))

(define (safe-car-cdr proc args)        ; ex 5.30 b
  (if (not (pair? (car args)))          ; args is a list (args '())
      (list 'primitive-error 'arg-not-pair)
      (apply-in-underlying-scheme proc args)))
(define (safe-division proc args)       ; ex 5.30 b
  (if (= 0 (cadr args))
      (cons 'primitive-error 'division-by-zero)
      (apply-in-underlying-scheme proc args)))

; and this is added to the evaluator.

primitive-apply
  (assign val (op apply-primitive-procedure) (reg proc) (reg argl))
  (test (op primitive-error?) (reg val)) ; ex 5.30 b
  (branch (label primitive-error))
  (restore continue)
  (goto (reg continue))
primitive-error
  (restore continue)               ; clean up stack from apply-dispatch
  (goto (label signal-error))
