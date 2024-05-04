; special form 으로 cond 새 문법 추가하기. - ev-sequence 사용하기
  
ev-cond
 (assign exp (op cond-clauses) (reg exp))
 (test (op null?) (reg exp))
 (branch (label ev-cond-end))
 (assign unev (op car) (reg exp))
 (assign exp (op cdr) (reg exp))
 (test (op cond-else-clauses?) (reg unev)) ; 마지막이면 다르게 처리
 (branch (label cond-else))
 (save env)
 (save continue)
 (save unev)
 (save exp)
 (assign continue (label ev-cond-loop))
 (assign exp (op cond-predicate) (reg unev))
 (goto (label ev-dispatch))
 
ev-cond-loop
 (restore exp)
 (test (op true?) (reg val))
 (branch (label cond-result))
 (restore unev)
 (restore continue)
 (restore env)
 (goto (label ev-cond)) 
 
; this does not restore continue so it wont return to the caller.
; it also leaves env on the stack which would accumulate with
; each call to a cond.
cond-result
 (restore unev)
 (assign exp (op cond-actions) (reg unev))
 (assign exp (op sequence->exp) (reg exp))
 (goto (label ev-dispatch))
 
cond-else
 (assign unev (op cond-actions) (reg unev))
 (assign exp (op sequence->exp) (reg unev))
 (goto (label ev-dispatch))
 
ev-cond-end   
 (goto (reg continue))
