; 어셈블 제어기 분석 도중에 레지스터가 없으면 추가한다.

; In make-new-machine, change the code of lookup-register
(define (lookup-register name)
  (let ((val (assoc name register-table)))
       (if val
           (cadr val)
           (begin
             (allocate-register name)
             (lookup-register name)))))
