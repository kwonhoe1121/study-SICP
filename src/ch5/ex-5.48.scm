; 실행기 안에서 compile 번역기를 사용할 수 있도록 compile-and-run 구현

; this code will get executed by primitive-apply in ch5-eceval-compiler.scm
; specifically, by (apply-primitive-procedure)
(define (compile-and-run expression)
  (let ((stack (eceval 'stack))
        (instructions
          (assemble
            (append
              (statements (compile expression 'val 'next))

              ; print the result after executing statements
              '((goto (reg printres))))
            eceval)))

       ; get rid of old value of continue
       ; this is optional, because (initialize-stack) will
       ; clear the stack after print-result
       (stack 'pop)

       ; the next 2 commands in primitive-apply are:
       ; (restore continue)
       ; (goto (reg continue))
       ; this forces eceval to jump to and execute instructions
       ((stack 'push) instructions)))
