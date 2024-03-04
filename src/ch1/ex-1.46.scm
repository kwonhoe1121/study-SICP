; recur

(define (iterative-improve good-enough? improve)
  (lambda (guess)
    (if (good-enough? guess)
        guess
        ((iterative-improve good-enough? improve) (improve guess)))))

; iter

(define (iterative-improve good-enough? improve)
  (lambda (first-guess)
    (define (iter guess)
      (if (good-enough? guess)
          guess
          (iter (improve guess))))
    (iter first-guess)))

(define (iterative-improve good-enough? improve)
  (define (iter guess)
    (if (good-enough? guess)
        guess
        (iter (improve guess))))
  iter)

; iterative-improve 사용한 버전 fixed-point 구현

(define (fixed-point f first-guess)
  (define tolerance 0.00001)
  (define (close-enough? v1 v2)
    (< (abs (- v1 v2))
       tolerance))
  ((iterative-improve
    (lambda (x) (close-enough? x (f x)))
    f)
   first-guess))
