(define (eval-sequence exps env)
  (cond ((last-exp? exps) 
         (eval (first-exp exps) env))
        (else 
         (actual-value (first-exp exps) 
                       env)
         (eval-sequence (rest-exps exps) 
                        env))))

; [참고답안]

; ;; a 
; In begin expression, every expression will be evaluated using eval, and display is primitive function, it will call force-it to get x. 

; ;; b 
; original eval-sequence: 
; (p1 1) => (1 . 2) 
; (p2 1) => 1  . because (set! x (cons x '(2))) will be delayed, in function p, when evaluating it, it's a thunk. 

; Cy's eval-sequence: 
; (p1 1) => (1 . 2) 
; (p2 1) => (1 . 2). thunk (set! x (cons x '(2))) will be forced to evaluate. 

; ;; c 
; when using actual-value, it will call (force-it p), if p is a normal value, force-it will return p, just as never call actual-value 

; ;; d 
; I like Cy's method. 
