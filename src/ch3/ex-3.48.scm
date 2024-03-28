; 교착상태(deadlock)에 빠지지 않기 위하여 공유 자원에 번호를 매겨놓고 차례대로 쓰는 기법 활용

(define (make-account-and-serializer balance)
  (define (withdraw amount)
    (if (>= balance amount)
        (begin 
          (set! balance (- balance amount))
          balance)
        "Insufficient funds"))
  (define (deposit amount)
    (set! balance (+ balance amount))
    balance)
  (let ((balance-serializer 
         (make-serializer))
        (account-id ((get 'get-id 'account account-table)))) ; wishful-thinking
    (define (dispatch m)
      (cond ((eq? m 'withdraw) withdraw)
            ((eq? m 'deposit) deposit)
            ((eq? m 'balance) balance) ;
            ((eq? m 'serializer)
             balance-serializer)
            ((eq? m 'id) account-id)
            (else (error "Unknown request: 
                          MAKE-ACCOUNT"
                         m))))
    dispatch))

; 프로세스가 공통적으로 id가 큰 계좌의 락을 먼저 획득하는 것이 불가능해지기 때문에 교착상태를 회피할 수 있다.
(define (serialized-exchange account1 account2)
  (let ((serializer1 (account1 'serializer))
        (serializer2 (account2 'serializer)))
    (if (> (account1 'id)
           (account2 'id))
      (serializer2 (serializer1 exchange))
      (serializer1 (serializer2 exchange))
      account1
      account2)))
