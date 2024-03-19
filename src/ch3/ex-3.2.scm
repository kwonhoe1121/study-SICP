(load "./src/lib/util.scm")

(define (make-monitored f)
  (let ((count 0))
    (define (mf x)
      (begin
        (set! count (+ count 1))
        (f x)))
    (define (dispatch m)
      (cond ((eq? m 'how-many-calls?) count)
            ((eq? m 'reset-count) (set! count 0))
            (else (mf m))))
    dispatch))

(define s (make-monitored sqrt))

; (s 100)
; (s 'how-many-calls?)
; (s 'reset-count)
