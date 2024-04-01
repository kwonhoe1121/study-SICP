; (⟨test⟩ => ⟨recipient⟩) 문법 구현

; (list 'arrow (test) (recipient))

; (define (arrow test recipient)
;   (if (test)
;     (recipient test)))

; (define (arrow? exp) (tagged-list? exp 'arrow))
; (define (arrow-test exp) (cadr exp))
; (define (arrow-recipient exp) (caddr exp))
; (define (arrow-make-body test recipient) (recipient test))
; (define (arrow->lambda exp)
;   (if (arrow-test exp)
;     (make-lambda (arrow-test exp)
;                  (arrow-make-body
;                    (arrow-test exp)
;                    (arrow-recipient exp)))
;     'false))

; [참고답안]

; ((cond? exp) (eval-cond exp env)) in eval procedure

(define (eval-cond exp env)
  (let ((clauses (cdr exp))
        (predicate car)
        (consequent cdr))
       (define (imply-clause? clause) (eq? (cadr clause)  '=>))
       (define (else-clause?  clause) (eq? (car clause) 'else))
       (define (rec-eval clauses)
         (if (null? clauses)
             'false; checked all, no else-clause
             (let ((first-clause (car clauses)))
                  (cond ((else-clause? first-clause) (eval-sequence (consequent first-clause) env))
                        ((imply-clause? first-clause) (let ((evaluated (eval (predicate first-clause) env))) ; 새로운 구문(문법) 추가
                                                           (if (true? evaluated)
                                                               (apply (eval (caddr first-clause) env) ; 함수 적용
                                                                      (list evaluated))
                                                               'false)))
                        (else (if (true? (eval (predicate first-clause) env))
                                  (eval-sequence (consequent first-clause) env)
                                  'false))))))
       (rec-eval clauses)))
