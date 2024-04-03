; 기존 lookup-variable-value, set-variable-value!, define-variable! 프로시저에서
; 환경/프레임 검색 분리
; CPS 방식 -> 프로시저를 인자로 넘기면, 환경을 유지하면서 부모에게 응답을 줄 수 있다.

; [참고답안]

; frame-lookup-cps procedure
(define (frame-lookup-cps var vars vals sc fc)
  (cond ((null? vars) (fc))
        ((eq? var (car vars)) (sc vals))
        (else (frame-lookup-cps var (cdr vars) (cdr vals) sc fc))))

; env-lookup-cps procedure
(define (env-lookup-cps var env sc fc)
  (if (eq? env the-empty-environment)
      (fc)
      (let ((frame (first-frame env)))
           (let ((vars (frame-variables frame))
                 (vals (frame-values frame))
                 (enc (enclosing-environment env)))
                (let ((fc (lambda () (env-lookup-cps var enc sc fc))))
                     (frame-lookup-cps var vars vals sc fc))))))

; lookup-variable-value procedure
(define (lookup-variable-value var env)
  (env-lookup-cps
    var
    env
    (lambda (vals) (car vals))
    (lambda () (error "Unbound variable" var))))

; set-variable-value! mutator procedure
(define (set-variable-value! var val env)
  (env-lookup-cps
    var
    env
    (lambda (vals) (set-car! vals val))
    (lambda () (error "Unbound variable -- SET!" var))))

; define-variable! mutator procedure
(define (define-variable! var val env)
  (let ((frame (first-frame env)))
       (let ((vars (frame-variables frame))
             (vals (frame-values frame)))
            (frame-lookup-cps
              var
              vars
              vals
              (lambda (vals) (set-car! vals val))
              (lambda () (add-binding-to-frame! var val frame))))))
