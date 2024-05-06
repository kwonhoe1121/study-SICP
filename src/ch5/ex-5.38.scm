; 번역기가 오픈 코드open-code 기본 연산을 쓴다면 매번 원시/복합 연산의 목적코드를 생성할 필요가 없다.
; 오픈 코드로 만든 기본 연산을 위한 코드 생성기 군family을 만든다.
;; 기계의 기본 산술 연산은 arg1과 arg2 인자로 받는다.

; (a)

;; in compile
((open-code? exp) (compile-open-code exp target linkage))

(define (open-code? exp)
  (memq (car exp) '(+ - * /)))

(define (spread-arguments operand1 operand2)
  (let ((op1 (compile operand1 'arg1 'next))
        (op2 (compile operand2 'arg2 'next)))
       (list op1 op2)))

; (b)

;; This procedure has a bug. It does not save the environment
;; Around the compilation of the first arg. Becuase of this it
;; will give incorrect results for recursive procedures. In my answer
;; Below I have fixed this.
(define (compile-open-code exp target linkage)
  (let ((op (car exp))
        (args (spread-arguments (cadr exp) (caddr exp))))
       (end-with-linkage linkage
                         (append-instruction-sequences
                           (car args)
                           (preserving '(arg1)
                                       (cadr args)
                                       (make-instruction-sequence
                                         '(arg1 arg2)
                                         (list target) 
                                         `((assign ,target (op ,op) (reg arg1) (reg arg2)))))))))
