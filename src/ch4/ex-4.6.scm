; (이끌어낸 식) let->combination 구현 

; (let ((⟨var₁⟩ ⟨exp₁⟩) … (⟨varₙ⟩ ⟨expₙ⟩))
;   ⟨body⟩)

; ((lambda (⟨var₁⟩ … ⟨varₙ⟩)
;    ⟨body⟩)
;  ⟨exp₁⟩
;  …
;  ⟨expₙ⟩)

(define (let? exp) (tagged-list? exp 'let))
(define (let-clauses exp) (cdr exp))
(define (let-vars exp) (map car (cadr exp)))
(define (let-exps exp) (map cadr (cadr exp)))
(define (let-body exp) (caddr exp))
(define (let->combination exp)
  (let ((clauses (let-clauses exp)))
    (list
      (make-lambda
       (let-vars clauses)
       (let-body clauses))
      (let-exps clauses))))
