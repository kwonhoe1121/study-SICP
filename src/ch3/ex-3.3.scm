(define (make-account balance password)
  (define (withdraw amount)
    (if (>= balance amount)
        (begin (set! balance 
                     (- balance amount))
               balance)
        "Insufficient funds"))
  (define (deposit amount)
    (set! balance (+ balance amount))
    balance)
  (define (valid-password? input-password)
    (eq? password input-password))
  (define (get-method m)
    (cond ((eq? m 'withdraw) withdraw)
          ((eq? m 'deposit) deposit)
          (else (error "Unknown request: MAKE-ACCOUNT" m))))
  (define (dispatch input-password m) ; message passing style
    (if (valid-password? input-password)
      (get-method m)
      (error "Incorrect password" input-password)))
  dispatch)


(define acc (make-account 100 'secret-password))

; ((acc 'secret-password 'withdraw) 40)

; ((acc 'some-other-password 'deposit) 50)
