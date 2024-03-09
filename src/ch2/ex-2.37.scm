(load "./src/ch2/ex-2.36.scm")

; (dot-product v w) returns the sumΣiviwi;
; (matrix-*-vector m v) returns the vectort,whereti=Σjmijvj;
; (matrix-*-matrix m n) returns the matrixp,wherepij=Σkmiknkj;
; (transpose m) returns the matrixn,wherenij=mji.

(define (dot-product v w)
  (accumulate + 0 (map * v w))) ; map은 scheme 표준 map

(define (matrix-*-vector m v)
  (map (lambda (row) (dot-product row v)) m))

(define (transpose mat)
  (accumulate-n cons nil mat))

(define (matrix-*-matrix m n)
  (let ((cols (transpose n)))
    (map (lambda (row) (map (lambda (col) (dot-product row col)) cols)) m)))

; (define test (list (list 1 2 3 4) 
;                      (list 4 5 6 6) 
;                      (list 6 7 8 9)))

; (dot-product (car test) (car (cdr test))) ; 56

; (display (transpose test)) ; ((1 4 6) (2 5 7) (3 6 8) (4 6 9))

; (display (matrix-*-matrix test (transpose test)))
