; 번역된compiled 프로시저가 기본 프로시저뿐 아니라
; 번역compile 없이 실행interpret하기로 한 프로시저까지 부를 수 있도록 번역기 수정

;; add a test for compound procedures.

(define (compile-procedure-call op target linkage compile-time-environment)
  (let ((primitive-branch (make-label 'primitive-branch))
        (compiled-branch (make-label 'compiled-branch))
        (compound-branch (make-label 'compound-branch)) ; 번역 없이 실행하는 프로시저 케이스 추가
        (after-call (make-label 'after-call)))
       (let ((comp-linkage
               (if (eq? linkage 'next)
                   after-call
                   linkage)))
            (append-instruction-sequences
              (make-instruction-sequence
                '(proc) '()
                `((test (op primitive-procedure?) (reg proc))
                  (branch (label ,primitive-branch))
                  (test (op compound-procedure?) (reg proc))
                  (branch (label ,compound-branch))))
              (parallel-instruction-sequences
                (parallel-instruction-sequences
                  (append-instruction-sequences
                    compiled-branch
                    (compile-proc-appl op target comp-linkage compile-time-environment))
                  (append-instruction-sequences  ; **
                    compound-branch
                    (compile-compound-call op target comp-linkage compile-time-environment)))
                (append-instruction-sequences
                  primitive-branch
                  (end-with-linkage
                    linkage
                    (make-instruction-sequence
                      '(proc argl)
                      (list target)
                      `((assign ,target
                                (op apply-primitive-procedure)
                                (reg proc)
                                (reg argl)))))))
              after-call))))


; The evaluator is arranged so that at apply-dispatch,
; the continuation would be at the top of the stack.
; So we must save the continue before passing control
; to the evaluator.

(define (compile-compound-call op target linkage compile-time-environment)
  (let ((modified-regs
          (if (memq op safe-ops)
              '()
              all-regs)))
       (cond ((and (eq? target 'val) (not (eq? linkage 'return)))
              (make-instruction-sequence
                '(proc)
                modified-regs
                `((assign continue (label ,linkage))
                  (save continue)
                  (goto (reg compapp)))))
             ((and (not (eq? target 'val))
                   (not (eq? linkage 'return)))
              (let ((proc-return (make-label 'proc-return)))
                   (make-instruction-sequence
                     '(proc) modified-regs
                     `((assign continue (label ,proc-return))
                       (save continue)
                       (goto (reg compapp))
                       ,proc-return
                       (assign ,target (reg val))
                       (goto (label ,linkage))))))
             ((and (eq? target 'val) (eq? linkage 'return))
              (make-instruction-sequence
                '(proc continue)
                modified-regs
                '((save continue)
                  (goto (reg compapp)))))
             ((and (not (eq? target 'val))
                   (eq? linkage 'return))
              (error "return linkage, target not val -- COMPILE"
                     target)))))
