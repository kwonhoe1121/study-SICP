; ex-5.39 - lexical-address-lookup, lexical-address-set! 구현

(define (lexical-address addr-frame addr-offset)
  (cons addr-frame addr-offset))
(define (addr-frame address) (car address))
(define (addr-offset address) (cdr address))

(define (lexical-address-lookup env address)
  (let* ((frame (list-ref env (addr-frame address)))
         (value (list-ref (frame-values frame) (addr-offset address))))
        (if (eq? value '*unassigned*) ; TDZ
            (error "the variable is unassigned -- LEXICAL-ADDRESS-LOOKUP" address)))
  value)

(define (lexical-address-set! env address value)
  (let ((frame (addr-frame address))
        (offset (addr-frame address)))
       (define (set-value! f pos)
         (if (= f 0)
             (set-car! f value)
             (set-value! (cdr f) (- pos 1))))
       (set-value! frame offset)))

; ex-5.40 - compile-time environment 데이터 구조 적용

(define (compile-lambda-body exp proc-entry ct-env)
  (let ((formals (lambda-parameters exp)))
       (append-instruction-sequences
         (make-instruction-sequence
           '(env proc argl)
           '(env)
           `(,proc-entry
             (assign env
                     (op compiled-procedure-env)
                     (reg proc))
             (assign env
                     (op extend-environment)
                     (const ,formals)
                     (reg argl)
                     (reg env))))
         (compile-sequence
           (lambda-body exp)
           'val
           'return
           (extend-ct-env ct-env formals)))))
(define (extend-ct-env env frame)
  (cons frame env))

; ex-5.41 - find-variable 구현 (그 환경과 관련 있는 변수의 위치 주소 반환)
 
(define (find-variable variable lst)
  (define (search-variable v l n)
    (cond ((null? l) false)
          ((eq? v (car l)) n)
          (else (search-variable v (cdr l) (+ n 1)))))
  (define (search-frame frames f)
    (if (null? frames)
        'not-found
        (let ((o (search-variable variable (car frames) 0)))
             (if o
                 (cons f o)
                 (search-frame (cdr frames) (+ f 1))))))
  (search-frame lst 0))

; ex-5.42 - compile-variable, compile-assignment 구현

(define (compile-variable exp target linkage ct-env)
  (let ((r (find-variable exp ct-env)))
       (if (eq? r 'not-found) ; compile-time environment 에서 못찾은 경우,
           (end-with-linkage
             linkage
             (make-instruction-sequence
               '(env)
               (list target)
               `((assign ,target
                         (op lookup-variable-value) ; global environment 환경에서 찾는다. - run time environment
                         (const ,exp)
                         (reg env)))))
           (end-with-linkage
             linkage
             (make-instruction-sequence
               '(env)
               (list target)
               `(assign ,target
                 (op lexical-address-lookup)
                 (const ,r)
                 (reg env)))))))

; ex-5.43 - clojure
;; 프로시저 바디는 마치 만들고 있는 내부 변수를 lambda 변수로 두는 것처럼 해석되어야 한다. (ex-4.16 참고할 것.)

;; we just need use scan-out-defines here change lambda-body to equivalent expression.
(define (compile-lambda-body exp proc-entry ct-env)
  (let ((formals (lambda-parameters exp)))
       (append-instruction-sequences
         (make-instruction-sequence
           '(env proc argl)
           '(env)
           `(,proc-entry
             (assign env (op compiled-procedure-env) (reg proc))
             (assign env
                     (op extend-environment)
                     (const ,formals)
                     (reg argl)
                     (reg env))))
         (compile-sequence
           (scan-out-defines (lambda-body exp)) ; 
           'val
           'return
           (extend-ct-env ct-env formals)))))

; ex-5.44 - 재정의 기능 (오픈코드 예약어 재정의 여부 확인)

(define (overwrite? operator ct-env)
  (let ((r (find-variable operator ct-env)))
       (eq? r 'not-found)))
(define (open-code? exp ct-env)
  (and (memq (car exp) '(+ - * /))
       (overwrite? (car exp) ct-env)))
