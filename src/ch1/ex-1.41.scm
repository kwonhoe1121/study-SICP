(define (double f)
  (lambda (x) (f (f x))))

((double inc) 3) ; 5

(((double (double double)) inc) 5) ; 21

; (((double (double double)) inc) 5)

; (((double (lambda (x) (double (double x)))) inc) 5)

; (((lambda (x)
;     ((lambda (x) (double (double x)))
;       ((lambda (x) (double (double x))) x))) inc) 5)

; (((lambda (x)
;     ((lambda (x) (double (double x))) (double (double x)))) inc) 5)

; (((lambda (x)
;     (double (double (double (double x))))) inc) 5)

; ∴ double 4개 => 2^4
; ((double (double (double (double inc)))) 5)
; ((double (double (double (lambda (x) (inc (inc x)))))) 5)
; ((double (double (lambda (x) (inc (inc (inc (inc x))))))) 5)
; ((double (lambda (x) (inc (inc (inc (inc (inc (inc (inc (inc x)))))))))) 5)
; ((lambda (x)
;    (inc (inc (inc (inc (inc (inc (inc (inc (inc (inc (inc (inc (inc (inc (inc (inc x))))))))))))))))) 5)

; (inc (inc (inc (inc (inc (inc (inc (inc (inc (inc (inc (inc (inc (inc (inc (inc 5))))))))))))))))
