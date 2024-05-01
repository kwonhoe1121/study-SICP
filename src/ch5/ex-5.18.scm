; 레지스터 기록 남기는 기능

(define (trace-on-register machine register-name)
  ((get-register machine register-name) 'trace-on)
  'trace-on)
(define (trace-off-register machine register-name)
  ((get-register machine register-name) 'trace-off)
  'trace-off)

(define (make-register name)
  (let ((contents '*unassigned*)
        (trace? false))
       (define (dispatch message)
         (cond ((eq? message 'get) contents)
               ((eq? message 'set) ; 레지스터 설정 시 추적 모드면 출력 기능 추가
                (lambda (value)
                        (if trace?
                            (begin
                              (display name)
                              (display " ")
                              (display contents)
                              (display " ")
                              (display value)
                              (newline)
                              (set! contents value))
                            (set! contents value))))
               ((eq? message 'trace-on)
                (set! trace? true))
               ((eq? message 'trace-off)
                (set! trace? false))
               (else
                 (error "Unkown request -- REGISTER" message))))
       dispatch))
