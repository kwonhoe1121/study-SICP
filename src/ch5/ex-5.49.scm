; read -> compile -> print -> loop 레지스터 기계 설계
; 식을 읽고, 읽은 식을 번역하고, 번역된 코드를 어셈블하고, 실행한 결과를 찍는 루프
; '레지스터 기계 연산'로 compile과 assemble 프로시저를 불러 쉽게 처리할 수 있다.

(define rcep-controller
  '((assign env (op get-global-environment))
    read
    (perform (op prompt-for-input) (const ";;; RCEP-RM input:"))
    (assign val (op read))
    (assign val (op compile) (reg val))
    (assemble-val)
    (assign continue (label after-execute))
    (goto (reg val))
    after-execute
    (perform (op announce-output) (const ";;; RCEP-RM value:"))
    (perform (op user-print) (reg val))
    (goto (label read))))

(define operations
  (append eceval-operations
          (list (list 'read read)
                (list 'compile statements-with-return)
                (list 'prompt-for-input prompt-for-input)
                (list 'announce-output announce-output)
                (list 'user-print user-print)
          ;...
          ))

;; in repl
(start (make-machine operations rcep-controller))
