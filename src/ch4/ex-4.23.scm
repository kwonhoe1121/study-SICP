; [비교]
; 실행 프로시저를 하나씩 부를 때마다 건네주는 환경이 같기 때문에, 앞의 실행 프로시저가 돌아가면서 환경에 어떤 변화를 일으켰다면, 그 변화가 다음 실행 프로시저에 힘을 미치게 된다.

; (lambda (env) 
;     ((lambda (env) (proc1 env) (proc2 env)) 
;      env) 
;     (proc3 env)) 
; 꼬리 재귀 수행 - compile time
(define (analyze-sequence exps)
  (define (sequentially proc1 proc2)
    (lambda (env) (proc1 env) (proc2 env)))
  (define (loop first-proc rest-procs)
    (if (null? rest-procs)
        first-proc
        (loop (sequentially first-proc 
                            (car rest-procs))
              (cdr rest-procs))))
  (let ((procs (map analyze exps)))
    (if (null? procs)
        (error "Empty sequence: ANALYZE"))
    (loop (car procs) (cdr procs))))

; (lambda (env) (executive-sequence procs env))) 
; 재귀 수행 - runtime -> 비효율적
(define (analyze-sequence exps)
  (define (execute-sequence procs env)
    (cond ((null? (cdr procs)) 
           ((car procs) env))
          (else ((car procs) env)
                (execute-sequence 
                 (cdr procs) env))))
  (let ((procs (map analyze exps)))
    (if (null? procs)
        (error "Empty sequence: 
                ANALYZE"))
    (lambda (env) 
      (execute-sequence procs env))))
