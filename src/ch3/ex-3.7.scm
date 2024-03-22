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
  (define share-passwords (list password))
  (define (valid-password? input-password)
    (memq input-password share-passwords))
  (define (save-password x)
    (set! share-passwords (cons x share-passwords)))
  (define (get-method m)
    (cond ((eq? m 'withdraw) withdraw)
          ((eq? m 'deposit) deposit)
          ((eq? m 'share) save-password)
          (else (error "Unknown request: MAKE-ACCOUNT" m))))
  (define (dispatch input-password m)
    (if (valid-password? input-password)
      (get-method m)
      (error "Incorrect password" input-password)))
  dispatch)

(define (make-joint share-account share-pwd private-pwd)
  ((share-account share-pwd 'share) private-pwd)
  share-account)

; (define peter-acc (make-account 100 'open-sesame)) 

; ((peter-acc 'open-sesame 'withdraw) 0)

; (define paul-acc (make-joint peter-acc 'open-sesame 'rosebud)) 

; ((paul-acc 'open-sesame 'withdraw) 0)

; ((paul-acc 'rosebud 'withdraw) 20)

; (define pan-acc (make-joint paul-acc 'rosebud 'vvv))

; ((paul-acc 'vvv 'withdraw) 0)

; ((paul-acc 'rosebud 'withdraw) 20)

; (define (make-joint linked-acc linked-pwd joint-pwd)
;   (lambda (m pwd)
;     (if (not (= pwd joint-pwd))
;       (lambda (x) (error "Wrong joint account password"))
;       (let ((access-linked (linked-acc m linked-pwd)))
;         (if (= (access-linked 0) "Incorrect Password")
;           (lambda (x) (error "Wrong linked account password"))
;           access-linked)))))
