(define (assemble controller-text machine)
  (extract-labels controller-text
    (lambda (insts labels)
      (update-insts! insts labels machine)
      insts)))

; 여러 값을 리턴하는 우아한 방법 - receive
;; receive처럼 인자이면서 다음에 호출될 프로시저를 '앞으로 할 일(continuation)'이라 한다.

(define (extract-labels text receive)
  (if (null? text)
      (receive '() '())
      (extract-labels 
       (cdr text)
       (lambda (insts labels)
         (let ((next-inst (car text)))
           (if (symbol? next-inst)
               (receive 
                   insts
                   (cons 
                    (make-label-entry 
                     next-inst
                     insts)
                    labels))
               (receive 
                   (cons (make-instruction 
                          next-inst)
                         insts)
                   labels)))))))

; (define (assemble controller-text machine)
;   (let ((result 
;          (extract-labels controller-text)))
;     (let ((insts (car result))
;           (labels (cdr result)))
;       (update-insts! insts labels machine)
;       insts)))

; (define (extract-labels text)
;   (if (null? text)
;       (cons '() '())
;       (let ((result 
;              (extract-labels (cdr text))))
;         (let ((insts (car result))
;               (labels (cdr result)))
;           (let ((next-inst (car text)))
;             (if (symbol? next-inst)
;                 (cons 
;                  insts
;                  (cons 
;                   (make-label-entry 
;                    next-inst insts) 
;                   labels))
;                 (cons 
;                  (cons 
;                   (make-instruction next-inst) 
;                   insts)
;                  labels)))))))

(define (update-insts! insts labels machine)
  (let ((pc (get-register machine 'pc))
        (flag (get-register machine 'flag))
        (stack (machine 'stack))
        (ops (machine 'operations)))
    (for-each
     (lambda (inst)
       (set-instruction-execution-proc!
        inst
        (make-execution-procedure
         (instruction-text inst) 
         labels
         machine
         pc
         flag
         stack
         ops)))
     insts)))

; instruction := <inst-text, execute-proc>

(define (make-instruction text)
  (cons text '()))
(define (instruction-text inst) (car inst))
(define (instruction-execution-proc inst)
  (cdr inst))
(define (set-instruction-execution-proc! inst proc)
  (set-cdr! inst proc))

(define (make-label-entry label-name insts)
  (cons label-name insts))

(define (lookup-label labels label-name)
  (let ((val (assoc label-name labels)))
    (if val
        (cdr val)
        (error "Undefined label: ASSEMBLE" 
               label-name))))
