; 구간 산술 연산 프로그램
; ex-2.7 ~

; selector

(define (add-interval x y)
  (make-interval (+ (lower-bound x) 
                    (lower-bound y))
                 (+ (upper-bound x) 
                    (upper-bound y))))

(define (sub-interval x y)
  (let ((p1 (- (lower-bound x) 
               (lower-bound y)))
        (p2 (- (lower-bound y) 
               (lower-bound x)))
        (p3 (- (upper-bound x) 
               (upper-bound y)))
        (p4 (- (upper-bound y) 
               (upper-bound x))))
  (make-interval (min p1 p2 p3 p4)
                 (max p1 p2 p3 p4))))

; (define (mul-interval x y)
;   (let ((p1 (* (lower-bound x) 
;                (lower-bound y)))
;         (p2 (* (lower-bound x) 
;                (upper-bound y)))
;         (p3 (* (upper-bound x) 
;                (lower-bound y)))
;         (p4 (* (upper-bound x) 
;                (upper-bound y))))
;     (make-interval (min p1 p2 p3 p4)
;                    (max p1 p2 p3 p4))))
 
(define (mul-interval x y)
  (let ((+? positive?)
        (-? negative?)
        (lx (lower-bound x))
        (ly (lower-bound y))
        (ux (upper-bound x))
        (uy (upper-bound y)))
    ; 9가지 경우
    (cond ((test-signs +? +? +? +? x y)
           (make-interval  (* lx ly) (* ux uy)))
          ((test-signs +? +? -? +? x y)
           (make-interval (* ux ly) (* ux uy) ))
          ((test-signs -? +? +? +? x y)
           (make-interval (* lx uy) (* ux uy) ))
          ((test-signs -? -? +? +? x y)
           (make-interval (* lx uy) (* ux ly) ))
          ((test-signs +? +? -? -? x y)
           (make-interval (* ux ly) (* lx uy) ))
          ((test-signs -? +? -? -? x y)
           (make-interval (* ux ly) (* lx ly) ))
          ((test-signs -? -? -? +? x y)
           (make-interval (* lx uy) (* lx ly) ))
          ((test-signs -? -? -? -? x y)
           (make-interval (* ux uy) (* lx ly) ))
          ((test-signs -? +? -? +? x y)
           (let ((p1 (* lx ly))
                 (p2 (* lx uy))
                 (p3 (* ux ly))
                 (p4 (* ux uy)))
             (make-interval (min p1 p2 p3 p4)
                            (max p1 p2 p3 p4)))))))

(define (test-signs lx-test ux-test ly-test uy-test x y)
  (and (lx-test (lower-bound x))
       (ux-test (upper-bound x))
       (ly-test (lower-bound y))
       (uy-test (upper-bound y))))

(define (div-interval x y)
  (mul-interval x 
                (make-interval 
                 (/ 1.0 (upper-bound y)) 
                 (/ 1.0 (lower-bound y)))))

(define (div-interval x y)
  (let ((lower-y (lower-bound y))
        (upper-y (upper-bound y)))
    (if (<= 0 (* lower-y upper-y)) ; the problem is the interval spans zero (upper-bound > 0, and lower-bound < 0)
      (error "[Error]: divide by zero")
      (mul-interval x 
                    (make-interval 
                     (/ 1.0 (upper-bound y)) 
                     (/ 1.0 (lower-bound y)))))))

(define (make-center-width c w)
  (make-interval (- c w) (+ c w)))

(define (center i)
  (/ (+ (lower-bound i) 
        (upper-bound i)) 
     2))

(define (width i)
  (/ (- (upper-bound i) 
        (lower-bound i)) 
     2))

(define (make-center-percent c e)
  (let ((w (abs (* (/ e 100) c))))
    (make-center-width c w)))

 ; 이때 불확실성은 구간의 폭에 대한 구간 중점의 비율로 측정된다.
(define (percent i)
  (if (= (center i) 0)
    0
    (* 100 (abs (/ (- (upper-bound i) (center i))
                   (center i))))))

; constructor

(define (make-interval a b) (cons a b))
(define (lower-bound interval) (car interval))
(define (upper-bound interval) (cdr interval))
