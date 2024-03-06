(load "./src/lib/util.scm")

; (define (count-change amount)
;   (define (first-denomination kinds-of-coins)
;     (cond ((= kinds-of-coins 1) 1)
;           ((= kinds-of-coins 2) 5)
;           ((= kinds-of-coins 3) 10)
;           ((= kinds-of-coins 4) 25)
;           ((= kinds-of-coins 5) 50)))
;   (define (iter amount kinds-of-coins)
;     (cond ((= amount 0) 1)
;           ((or (< amount 0) (= kinds-of-coins 0)) 0)
;           (else (+ (iter amount
;                          (- kinds-of-coins 1))
;                    (iter (- amount
;                             (first-denomination kinds-of-coins))
;                          kinds-of-coins)))))
;   (iter amount 5))

(define us-coins (list 50 25 10 5 1))
; (define us-coins (list 10 25 50 5 1))
(define uk-coins (list 100 50 20 10 5 2 1 0.5))

(define (no-more? coin-values) (null? coin-values))
(define (first-denomination coin-values) (car coin-values))
(define (except-first-denomination coin-values) (cdr coin-values))

(define (cc amount coin-values)
  (cond ((= amount 0) 
         1)
        ((or (< amount 0) 
             (no-more? coin-values)) 
         0)
        (else
         (+ (cc 
             amount
             (except-first-denomination 
              coin-values))
            (cc 
             (- amount
                (first-denomination 
                 coin-values))
             coin-values)))))


; (cc 100 us-coins) ; 292
; (cc 100 uk-coins); 104561
