(define acc (make-account 50))
(define acc2 (make-account 100))

; 1. The local states for the two accounts each have their own environments.

; 2. The only part of the environment structure that is shared between 'acc' and 'acc2' is the global environment.

; ; [참고 답안]

; (define acc (make-account 50))

; global   _________________________________
; env  -->| make-account :*                 |
;         | acc : *       |                 |
;          -------|-------|---^-----------^-
;                 |       |   |           |
;                 |     ( * , * )         |
;                 |       |               |
;                         parameter: balance
;                 |       body: (define (withdraw ... ))
;                 |                       |
;                 |                -------Frame 0-      (parameter, body)
;                 |               | balance  : 50 |      |
;                 |           E0->| withdraw : *--|--> ( * , * )  
;                 |               | deposit  : *--|--> ( * , * ) 
;                 |               | dispatch : *--|--> ( * , * )     
;                 |                -------^----^--           |
;                 |    ___________________|    |_____________| 
;                 |   |
;               ( * , * )
;                 |
;                 parameter : m           
;                 body      : (cond ((eq? m ... )))               

; ((acc 'deposit) 40)

; Frame 1 is created when (acc 'deposit is evaluated).
; Next, Frame 2 is created when (deposit amount). Since deposit is defined
; in E0, Frame 2 pointer is to environment E0.

; global   _________________________________
; env  -->| make-account :*                 |
;         | acc : *                         |
;          -------|-----------------------^-
;                 |                       |
;                 |                -------Frame 0-
;                 |               | balance  : 50 |
;               ( *, *-)--------->| withdraw : *  |
;                                 | deposit  : *  |<- E0
;                                 | dispatch : *  |
;                                  -^-----^------- (make-account balance)
;                          _________|     |
;                         |        -------Frame 1-
;                         |       | m : 'deposit  |<- E1 
;                         |        --------------- (dispatch m)
;                  -------Frame 2-
;                 | amount : 40   |<- E2
;                  --------------- (deposit amount)

; After ((acc 'deposit) 40) evaluation balance is set to 90 in Frame 0 and
; Frames 1 and 2 are not relevant anymore.

; global   _________________________________
; env  -->| make-account :*                 |
;         | acc : *                         |
;          -------|-----------------------^-
;                 |                       |
;                 |                -------Frame 0-
;                 |               | balance  : 90 |
;               ( *, *-)--------->| withdraw : *  |
;                                 | deposit  : *  |<- E0
;                                 | dispatch : *  |
;                                  --------------- 

; ((acc 'withdraw) 60)

; global   _________________________________
; env  -->| make-account :*                 |
;         | acc : *                         |
;          -------|-----------------------^-
;                 |                       |
;                 |                -------Frame 0-
;                 |               | balance  : 90 |
;               ( *, *-)--------->| withdraw : *  |
;                                 | deposit  : *  |<- E0
;                                 | dispatch : *  |
;                                  -^-----^------- (make-account balance)
;                          _________|     |
;                         |        -------Frame 3-
;                         |       | m : 'withdraw |<- E3
;                         |        --------------- (dispatch m)
;                  -------Frame 4-
;                 | amount : 60   |<- E4
;                  --------------- (withdraw amount)

; After ((acc 'withdraw) 60)

; global   _________________________________
; env  -->| make-account :*                 |
;         | acc : *                         |
;          -------|-----------------------^-
;                 |                       |
;                 |                -------Frame 0-
;                 |               | balance  : 30 |
;               ( *, *-)--------->| withdraw : *  |
;                                 | deposit  : *  |<- E0
;                                 | dispatch : *  |
;                                  ---------------
