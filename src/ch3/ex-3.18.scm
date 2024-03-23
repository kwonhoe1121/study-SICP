(load "./src/ch3/ex-3.13.scm")

; (define (cycle? x)
;   (let ((counted-pairs '()))
;     (define (counted-pair? pairs x)
;       (cond ((null? pairs) #f)
;             ((eq? (car pairs) x) #t)
;             (else (counted-pair? (cdr pairs x)))))
;     (define (detect-cycle x)
;       (cond ((null? x) #f)
;             ((counted-pair? counted-pairs x) #t)
;             (else
;               (set! counted-pairs (cons x counted-pairs))
;               (detect-cycle (cdr x)))))
;     (detect-cycle x)))

(define (cycle? x)
  (let ((traversed '()))
    (define (traverse x)
      (cond ((null? x) #f)
            ((memq x traversed) #t)
            (else (set! traversed (cons x traversed))
                  (traverse (cdr x)))))
    (traverse x)))

; (define z1 (make-cycle (list 'a 'b 'c))) 
; (define z2 (list z1 z1))

; (cycle? z1) ; #t

; (cycle? z2) ; #f

