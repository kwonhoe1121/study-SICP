; 은행 계정마다 시리얼라이저를 하나씩 가지므로, 서로 다른 은행 계정에 돈을 넣거나 빼는 일은 한꺼번에 처리될 수 있다.

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
  (let ((protected (make-serializer))) ; serializer
    (define (dispatch m)
      (cond ((eq? m 'withdraw) 
             (protected withdraw)) ;
            ((eq? m 'deposit) 
             (protected deposit)) ;
            ((eq? m 'balance) 
             balance)
            (else (error "Unknown request: 
                          MAKE-ACCOUNT"
                         m))))
    dispatch))
