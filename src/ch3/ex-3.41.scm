(define (make-account balance)
  (define (withdraw amount)
    (if (>= balance amount)
        (begin 
          (set! balance 
                (- balance amount))
          balance)
        "Insufficient funds"))
  (define (deposit amount)
    (set! balance (+ balance amount))
    balance)
  (let ((protected (make-serializer)))
    (define (dispatch m)
      (cond ((eq? m 'withdraw) 
             (protected withdraw))
            ((eq? m 'deposit) 
             (protected deposit))
            ((eq? m 'balance)
             ((protected 
                (lambda () 
                  balance)))) ; serialized
            (else 
             (error 
              "Unknown request: 
               MAKE-ACCOUNT"
              m))))
    dispatch))

; balance 값의 조회는 해당 시점의 값만 보여주면 된다. 따라서 serialized 할 필요는 없다.
