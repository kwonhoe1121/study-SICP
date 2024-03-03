(load "./src/lib/util.scm")

 (define (simpson-integral f a b n) 
   (define h (/ (- b a) n)) 
   (define (yk k) (f (+ a (* h k)))) 
   (define (simpson-term k) 
     (* (cond ((or (= k 0) (= k n)) 1) 
              ((odd? k) 4) 
              (else 2)) 
        (yk k))) 
   (* (/ h 3) (sum simpson-term 0 inc n)))

; (simpson-integral cube 0 1 100) ; 1/4
; (simpson-integral cube 0 1 1000) ; 1/4
