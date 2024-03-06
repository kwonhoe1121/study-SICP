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
                 (max p1 p2 p3 p4)))

(define (mul-interval x y)
  (let ((p1 (* (lower-bound x) 
               (lower-bound y)))
        (p2 (* (lower-bound x) 
               (upper-bound y)))
        (p3 (* (upper-bound x) 
               (lower-bound y)))
        (p4 (* (upper-bound x) 
               (upper-bound y))))
    (make-interval (min p1 p2 p3 p4)
                   (max p1 p2 p3 p4))))

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

; constructor

(define (make-interval a b) (cons a b))
(define (lower-bound interval) (car interval))
(define (upper-bound interval) (cdr interval))
