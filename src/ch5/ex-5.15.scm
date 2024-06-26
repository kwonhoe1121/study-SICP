; stack 데이터 정보 추적

(define (make-stack)
  (let ((s '())
        (number-pushes 0)
        (max-depth 0)
        (current-depth 0))
    (define (push x)
      (set! s (cons x s))
      (set! number-pushes (+ 1 number-pushes))
      (set! current-depth (+ 1 current-depth))
      (set! max-depth 
            (max current-depth max-depth)))
    (define (pop)
      (if (null? s)
          (error "Empty stack: POP")
          (let ((top (car s)))
            (set! s (cdr s))
            (set! current-depth
                  (- current-depth 1))
            top)))
    (define (initialize)
      (set! s '())
      (set! number-pushes 0)
      (set! max-depth 0)
      (set! current-depth 0)
      'done)

    (define (print-statistics)
      (newline)
      (display (list 'total-pushes 
                     '= 
                     number-pushes
                     'maximum-depth
                     '=
                     max-depth)))
    (define (dispatch message)
      (cond ((eq? message 'push) push)
            ((eq? message 'pop) (pop))
            ((eq? message 'initialize)
             (initialize))
            ((eq? message 'print-statistics)
             (print-statistics))
            (else
             (error "Unknown request: STACK"
                    message))))
    dispatch))

; 명령 세기instruction counting 기능

;; change the code in make-new-machine, they had been marked.
(define (make-new-machine)
  (let ((pc (make-register 'pc))
        (flag (make-register 'flag))
        (stack (make-stack))
        (the-instruction-sequence '())
        (instruction-number 0))                           ;; ***
       (define (print-instruction-number)                   ;; ***
         (display (list "current instruction number is: " instruction-number))
         (set! instruction-number 0)
         (newline))
       (let ((the-ops
               (list (list 'initialize-stack
                           (lambda () (stack 'initialize)))
                     (list 'print-stack-statistics
                           (lambda () (stack 'print-statistics)))))
             (register-table
               (list (list 'pc pc) (list 'flag flag))))
            (define (allocate-register name)
              (if (assoc name register-table)
                  (error "Multiply defined register: " name)
                  (set! register-table
                        (cons (list name (make-register name))
                              register-table)))
              'register-allocated)
            (define (lookup-register name)
              (let ((val (assoc name register-table)))
                   (if val
                       (cadr val)
                       (begin
                         (allocate-register name)
                         (lookup-register name)))))
            (define (execute)
              (let ((insts (get-contents pc)))
                   ((instruction-execution-proc (car insts)))
                   (set! instruction-number (+ instruction-number 1))     ;; ***
                   (execute)))
            (define (dispatch message)
              (cond ((eq? message 'start)
                     (set-contents! pc the-instruction-sequence)
                     (execute))
                    ((eq? message 'install-instruction-sequence)
                     (lambda (seq) (set! the-instruction-sequence seq)))
                    ((eq? message 'allocate-register) allocate-register)
                    ((eq? message 'get-register) lookup-register)
                    ((eq? message 'install-operations)
                     (lambda (ops) (set! the-ops (append the-ops ops))))
                    ((eq? message  'instruction-number) print-instruction-number)           ;;***
                    ((eq? message 'stack) stack)
                    ((eq? message 'operations) the-ops)
                    (else (error "Unkown request -- MACHINE" message))))
            dispatch)))
