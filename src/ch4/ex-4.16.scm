(load "./src/ch4/meta-circular-evaluator/meta-circular-evaluator.scm")

; /*
;  * 함수 적용을 평가할 때 평가기는 프레임 두 개를 생성한다.
;  * 1. 매개변수들을 위한 환경
;  * 2. 함수의 본문 블록에서 직접 선언된 이름들을 위한 환경
;  *
;  * ∴ 1, 2 종류의 이름들은 모두 범위가 같아야 한다. 해당 프로세스를 하나의 프레임에서 생성되도록 수정한다.
;  */

; (a)

(define (lookup-variable-value var env)
  (define (env-loop env)
    (define (scan vars vals)
      (cond ((null? vars)
             (env-loop 
              (enclosing-environment env)))
            ((eq? var (car vars))
             (if (eq? (car vals) '*unassigned*) ; 초기화 되었는지 여부 확인
               (error "'Unassigned variable" var)
               (car vals)))
            (else (scan (cdr vars) 
                        (cdr vals)))))
    (if (eq? env the-empty-environment)
        (error "Unbound variable" var)
        (let ((frame (first-frame env)))
          (scan (frame-variables frame)
                (frame-values frame)))))
  (env-loop env))

; [참고답안]

; (b)

; (lambda ⟨vars⟩
;   (let ((u '*unassigned*)
;         (v '*unassigned*))
;     (let ((a ⟨e1⟩)
;           (b ⟨e2⟩))
;       (set! u a)
;       (set! v b))
;     ⟨e3⟩))

(define (scan-out-defines body)
  (define (name-unassigned defines)
    (map (lambda (x) (list (definition-variable x) '*unassigned*))
         defines))
  (define (set-values defines)
    (map (lambda (x) (list 'set! (definition-variable x) (definition-value x)))
         defines))
  (define (defines->let exprs defines not-defines)
    (cond ((null? exprs)
           (if (null? defines)
               body
               (list (list 'let (name-unassigned defines)
                           (make-begin (append (set-values defines)
                                               (reverse not-defines)))))))
          ((definition? (car exprs))
           (defines->let (cdr exprs) (cons (car exprs) defines) not-defines))
          (else (defines->let (cdr exprs) defines (cons (car exprs) not-defines)))))
  (defines->let body '() '()))

; c
; install scan-out-defines into make-procedure. otherwise, when we call procedure-body, procedure scan-out-defines will be called.
