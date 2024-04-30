(save y)
(save x)
(restore y)

; (a) - 스택에 마지막으로 저장한 값을 y로 둔다. 그 값을 어떤 레지스터에서 가져왔는지는 개의치 않는다. (현재 구현된 방법)

; (assign n (reg val)) 
; (restore val) 
; we can use (restore n) replace these two instructions. Because val contain Fib(n-2), (restore n) make n containing Fib(n-1), then (assign val (op +) (reg val) (reg n)) works still.

; (b) - Stack: StackData[], StackData: Record<Register, Value>

;; in make-save, push the register name and contents on the stack.
(define (make-save inst machine stack pc)
  (let ((reg (get-register machine
                           (stack-inst-reg-name inst))))
       (lambda ()
               (push stack (cons (stack-inst-reg-name inst) (get-contents reg)))
               (advance-pc pc))))

;; when pop stack, check if the register name on the stack is equal to
;;  reg-name in (restore reg-name)
(define (make-restore inst machine stack pc)
  (let* ((reg-name (stack-inst-reg-name inst))
         (reg (get-register machine reg-name)))
        (lambda ()
                (let ((pop-reg (pop stack)))
                     (if (eq? (car pop-reg) reg-name)
                         (begin
                           (set-contents! reg (cdr pop-reg))
                           (advance-pc pc))
                         (error "the value is not from register:" reg-name))))))

; (c) - 레지스터별 스택을 각각 두는 경우

;; first modify make-stack making it including the name of register.
;; all the named-register are in s, we can use assoc to find it.
;; add interface add-reg-stack to add register to stack.
(define (make-stack)
  (let ((s '()))
       (define (push reg-name value)
         (let ((reg (assoc reg-name s)))
              (if reg
                  (set-cdr! reg (cons value (cdr reg)))
                  (error "the register is not in the stack -- PUSH" reg-name))))
       (define (pop reg-name)
         (let ((reg (assoc reg-name s)))
              (if reg
                  (if (null? (cdr reg))
                      (error "Empty stack for register -- POP " reg-name)
                      (let ((top (cadr reg)))
                           (set-cdr! reg (cddr reg))
                           top))
                  (error "the register is not in the stack -- POP" reg-name))))
       (define (add-reg-stack reg-name)
         (if (assoc reg-name s)
             (error "this register is already in the stack -- ADD-REG-STACK" reg-name)
             (set! s (cons (list reg-name) s))))
       (define (initialize)
         (for-each
           (lambda (stack)
                   (set-cdr! stack '()))
           s)
         'done)
       (define (dispatch message)
         (cond ((eq? message 'push) push)
               ((eq? message 'pop) pop)
               ((eq? message 'add-reg-stack) add-reg-stack)
               ((eq? message 'initialize) (initialize))
               (else (error "Unknown request -- STACK" message))))
       dispatch))

(define (add-reg-stack stack reg-name)
  ((stack 'add-reg-stack) reg-name))

;; change make-store and make-restore. because their parameters had change.
(define (make-save inst machine stack pc)
  (let ((reg (get-register machine
                           (stack-inst-reg-name inst))))
       (lambda ()
               (push stack (stack-inst-reg-name inst) (get-contents reg))
               (advance-pc pc))))

(define (make-restore inst machine stack pc)
  (let* ((reg-name (stack-inst-reg-name inst))
         (reg (get-register machine reg-name)))
        (lambda ()
                (let ((value (pop stack reg-name)))
                     (set-contents! reg value)
                     (advance-pc pc)))))

;; modify allocate-register in make-new-machine, when allocate a register,
;; add it to stack.
(define (allocate-register name)
  (if (assoc name register-table)
      (error "Multiply defined register: " name)
      (begin
        (add-reg-stack stack name)
        (set! register-table
              (cons (list name (make-register name))
                    register-table))))
  'register-allocated)
