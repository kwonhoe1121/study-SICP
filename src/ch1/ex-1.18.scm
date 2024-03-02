(load "./src/lib/util.scm")

; (define (fast-expt-iter b n) 
;   (define (iter N B A) 
;     (cond ((= 0 N) A) 
;           ((even? N) (iter (/ N 2) (square B) A)) 
;           (else (iter (- N 1) B (* B A))))) 
;   (iter n b 1))

; 거듭제곱 -> 곱셈 
; square -> double
; * -> +
; 항등원(1 -> 0)

(define (* b n) 
  (define (iter N B A) 
    (cond ((= 0 N) A) 
          ((even? N) (iter (halve N) (double B) A)) 
          (else (iter (- N 1) B (+ B A))))) 
  (iter n b 0))
