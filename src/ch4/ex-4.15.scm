; [turing's halting theorem]

(define (run-forever)
  (run-forever))

(define (try p)
  (if (halts? p p)
      (run-forever)
      'halted))

(try try)

; halts? -- 1. halt -> some val
;        '- 2. not halt -> error or run-forever
;
; try -- 1. halt -> run-forever
;     '- 2. not halt -> 'halted
;
; ∴ try 프로시저는 halts? 정의에 어긋난다.
