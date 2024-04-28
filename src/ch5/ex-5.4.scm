; (a) - Recursive exponentiation

(define (expt b n)
  (if (= n 0)
      1
      (* b (expt b (- n 1)))))

(define expt-machine
  (make-machine
    '(b n r continue)
    (list (list '= =) (list '* *) (list '- -))
    '((assign continue (label expt-done))
      expt-loop
      (test (op =) (reg n) (const 0))
      (branch (label expt-base))
      (save continue)
      (assign n (op -) (reg n) (const 1))
      (assign continue (label after-expt))
      (goto (label expt-loop))
      after-expt
      (restore continue)
      (assign r (op *) (reg r) (reg b))
      (goto (reg continue))
      expt-base
      (assign r (const 1))
      (goto (reg continue))
      expt-done)))

(set-register-contents! expt-machine 'b 2)
(set-register-contents! expt-machine 'n 10)
(start expt-machine)

(get-register-contents expt-machine 'r)
;=> 1024

; Data-path:
; ----------

;         ^    ┌───────┐      ^
;        /0\   │   n   │     /1\
;        ─┬─   └┬─────┬┘     ─┬─
;         │     │  ^  │       │
;         v     │  │  v       v
;        ,─.    │  X ───────────
;       ( = )<──┘  │  \  sub  /
;        `─'       │   ───┬───
;                  └──────┘

;   ┌───────┐             ┌───────┐
;   │   p   ├──┐       ┌──┤   b   │
;   └───────┘  v       v  └───────┘
;       ^     ───────────
;       │      \  mul  /
;       X       ───┬───
;       └──────────┘

;   ┌──────────┐       ┌──────────┐
;   │ continue ├────X─>│   stack  │
;   │          │<─X────┤          │
;   └──────────┘       └──────────┘

; (b) - Iterative exponentiation

(define (expt b n)
  (define (expt-iter counter product)
    (if (= counter 0)
        product
        (expt-iter (- counter 1)
                   (* b product))))
  (expt-iter n 1))

(define expt-machine
  (make-machine
    '(product b n product)
    (assign product (const 1))
    expt-loop
    (test (op =) (reg n) (const 0))
    (branch (label expt-done))
    (assign product (op *) (reg product) (reg b))
    (assign n (op -) (reg n) (const 1))
    (goto (label expt-loop))
    expt-done))

; Data-path:
; ----------

;         ^    ┌───────┐      ^
;        /0\   │   n   │     /1\
;        ─┬─   └┬─────┬┘     ─┬─
;         │     │  ^  │       │
;         v     │  │  v       v
;        ,─.    │  X ───────────
;       ( = )<──┘  │  \  sub  /
;        `─'       │   ───┬───
;                  └──────┘

;   ┌───────┐             ┌───────┐
;   │   p   ├──┐       ┌──┤   b   │
;   └───────┘  v       v  └───────┘
;       ^     ───────────
;       │      \  mul  /
;       X       ───┬───
;       └──────────┘
