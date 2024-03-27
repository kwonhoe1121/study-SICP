(define (make-account balance)
  (define (withdraw amount)
    (if (>= balance amount)
        (begin (set! balance 
                     (- balance amount))
               balance)
        "Insufficient funds"))
  (define (deposit amount)
    (set! balance (+ balance amount))
    balance)
  (let ((protected (make-serializer)))
    (let ((protected-withdraw  ;
           (protected withdraw))
          (protected-deposit 
           (protected deposit)))
      (define (dispatch m)
        (cond ((eq? m 'withdraw) 
               protected-withdraw)
              ((eq? m 'deposit) 
               protected-deposit)
              ((eq? m 'balance) 
               balance)
              (else 
               (error "Unknown request: 
                       MAKE-ACCOUNT"
                      m))))
      dispatch)))

; 위 버전은 함수 호출 전에 직렬화 (기존은 함수 호출 시 직렬화)
; 직렬화 범위는 동일한다. 은행 계정마다 시리얼라이저를 하나씩 갖고 있다.
