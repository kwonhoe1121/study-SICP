; sum monoid e : 0
; product monoid e: 1

; (a) - recur product

(define (product term a next b)
  (if (> a b)
    1
    (* (term a)
       (product term (next a) next b))))


; (b) - iter product

(define (product-iter term a next b)
  (define (iter a result)
    (if (> a b)
      result
      (iter (next a) (* result (term a)))))
  (iter a 1))

; test

(define (product-integer a b)
  (product-iter identity a inc b))

; π/4 = (2*4*4*6*6*...)/(3*3*5*5*7*7*...)
; π = 4 * ((n-1)*(n+1)/n*n) ...
(define (pi n)
  (define (term n)
    (* (/ (- n 1.0) n)
       (/ (+ n 1.0) n)))
  (define (next n) (+ n 2.0))
  (* 4.0 (product-iter term 3.0 next n)))
