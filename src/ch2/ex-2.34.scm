(load "./src/lib/util.scm")

; anxn+an−1xn−1+⋯+a1x+a0
; (…(anx+an−1)x+⋯+a1)x+a0.
; 호너의 법칙 = a(n) 으로 출발해서 거기에 x를 곱하고, a(n-1)을 더하고, x를 곱하는 식으로 a(0) 까지 나아가는 것이다.

(define 
  (horner-eval x coefficient-sequence)
  (accumulate 
   (lambda (this-coeff higher-terms)
     (+ (* higher-terms x)
        this-coeff))
   0
   coefficient-sequence))

(horner-eval 2 (list 1 3 0 5 0 1))
