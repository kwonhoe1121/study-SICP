; C(n, r) = r=0, 1
;         = r=n, 1
;         = else, C(n-1, r-1) + C(n-1, r)

(define (comb n r)
  (cond ((= r 0) 1)
        ((= r n) 1)
        (else (+ (comb (- n 1) (- r 1))
                 (comb (- n 1) r)))))

(comb 4 2) ; 6
