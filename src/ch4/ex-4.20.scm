(define (f x)
  (letrec
      ((even?
        (lambda (n)
          (if (= n 0)
              true
              (odd? (- n 1)))))
       (odd?
        (lambda (n)
          (if (= n 0)
              false
              (even? (- n 1))))))
    ⟨rest of body of f⟩))

; (letrec ((⟨var₁⟩ ⟨exp₁⟩) … (⟨varₙ⟩ ⟨expₙ⟩))
;   ⟨body⟩)

; (a)

(define (letrec->let exp)
  (let ((vars (map car (caddr exp)))
        (vals (map cdr (caddr exp)))
        (body (cadddr exp)))
    (let ((hoisted (map (lambda (x) (cons x '*unassigned*)) vars)))
      (define (iter rest-vars rest-vals result)
        (if (null? rest)
          result
          (iter (cdr rest-vars)
                (cdr rest-vals)
                (cons (set! (car rest-vars) (car rest-vals)) result))))
                (cons (list 'set!
                            (car rest-vars)
                            (car rest-vals))
                      result))))
      (list 'let
            (iter vars vals)
            body))))

; [참고답안]

;; letrec expression
(define (letrec? expr) (tagged-list? expr 'letrec))
(define (letrec-inits expr) (cadr expr))
(define (letrec-body expr) (cddr expr))
(define (declare-variables expr)
  (map (lambda (x) (list (car x) '*unassigned*)) (letrec-inits expr)))
(define (set-variables expr)
  (map (lambda (x) (list 'set! (car x) (cadr x))) (letrec-inits expr)))
(define (letrec->let expr)
  (list 'let (declare-variables expr)
        (make-begin (append (set-variables expr) (letrec-body expr)))))

; (b)

(let ((fact <fact-body>))
     <let-body>)

;; is encoded by

((lambda (fact)
         <let-body>)
 <fact-body>) ; fact-body가 외부에서 정의된다.

;; such that `<fact-body>' can't refer to `fact'. While:

(letrec ((fact <fact-body>))
        <let-body>)

;; is encoded by

((lambda (fact)
         (set! fact <fact-body>) ; fact-body가 내부에서 정의된다.
         <fact-body>)
 '*unassigned*)

 ;; note that in the context of `<fact-body>', the variable `fact' itself is
 ;; bound.


; Letrec Environment Diagram
; ==========================
; Even? and odd? procs reference E2 because the are created when evaluating
; set! within the body of the lambda.  This means they can lookup the even?
; and odd? variables defined in this frame.

; global env ──┐
;              v
; ┌───────────────────────────┐
; │                           │
; │(after call to define)     │
; │f:┐                        │<─────────────────────────────┐
; └───────────────────────────┘                              │
;    │  ^                                                    │
;    │  │                                  call to f         │
;    v  │                          ┌─────────────────────────┴─┐
;   @ @ │                          │x: 5                       │
;   │ └─┘                     E1 ->│                           │
;   v                              │                           │<───┐
; parameter: x                     └───────────────────────────┘    │
; ((lambda (even? odd?)                                             │
;    (set! even? (lambda (n) ...)                                   │
;    (set! odd? (lambda (n) ...)             call to letrec/lambda  │
;    (even? x))                           ┌─────────────────────────┴─┐
;  *unassigned* *unassigned*)             │even?:─────────────────┐   │
;                                    E2 ->│odd?:┐                 │   │
;                                         │     │                 │   │
;                                         └───────────────────────────┘
;                                               │  ^              │  ^
;                                               │  │              │  │
;                                               v  │              v  │
;                                              @ @ │             @ @ │
;                                              │ └─┘             │ └─┘
;                                              v                 v
;                                         parameter: n      parameter: n
;                                       (if (equal? n 0)  (if (equal? n 0)
;                                           false             true
;                                           ...               ...

; Let Environment Diagram
; =======================
; Even? and odd? procs reference E1 because they are evaluated in the body of
; f but outside the 'let lambda' because they are passed as arguments to that
; lambda.  This means they can't lookup the even? and odd? variables defined
; in E2.

; global env ──┐
;              v
; ┌───────────────────────────┐
; │                           │
; │(after call to define)     │
; │f:┐                        │<─────────────────────────────┐
; └───────────────────────────┘                              │
;    │  ^                                                    │
;    │  │                                  call to f         │
;    v  │                          ┌─────────────────────────┴─┐
;   @ @ │                          │x: 5                       │<───────────┐
;   │ └─┘                     E1 ->│                           │<─────────┐ │
;   v                              │                           │<───┐     │ │
; parameter: x                     └───────────────────────────┘    │     │ │
; ((lambda (even? odd?)                                             │     │ │
;    (even? x))                                                     │     │ │
;  (lambda (n) (if (equal? n ...))           call to let/lambda     │     │ │
;  (lambda (n) (if (equal? n ...)))       ┌─────────────────────────┴─┐   │ │
;                                         │even?:─────────────────┐   │   │ │
;                                    E2 ->│odd?:┐                 │   │   ^ │
;                                         │     │                 │   │   │ │
;                                         └───────────────────────────┘   │ │
;                                               │                 │       │ │
;                                               │  ┌──────────────────────┘ ^
;                                               │  │              │         │
;                                               v  │              v         │
;                                              @ @ │             @ @        │
;                                              │ └─┘             │ └────────┘
;                                              v                 v
;                                         parameter: n      parameter: n
;                                       (if (equal? n 0)  (if (equal? n 0)
;                                           false             true
;                                           ...               ...
