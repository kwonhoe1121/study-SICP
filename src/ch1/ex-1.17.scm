(load "./src/lib/util.scm")

(define (* a b)
  (if (= b 0)
    0
    (+ a (* a (- b 1)))))

; even, 2 * a_(n/2)
; odd, a + a_(n-1)

; (define (expt b n)
;   (cond ((= n 0) 1)
;         ((even? n) (square (expt b (/ n 2))))
;         (else (* b (expt b (- n 1))))))

; 거듭제곱 -> 곱셈 
; square -> double
; expt -> *
; * -> +
; 항등원(1 -> 0)

(define (* a b)
  (cond ((= b 0) 0)
        ((even? b) (double (* a (halve b))))
        (else (+ a (* a (- b 1))))))
