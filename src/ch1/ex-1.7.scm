(define (square x) (* x x))

;; 해당 스케일의 절대 오차가 항상 허용 오차보다 크도록 허용 오차를 선택하면 됩니다.
(define (good-enough? previous-guess guess)
  (< (abs (/ (- guess previous-guess) guess)) 0.00000000001)) ;; 주어진 입력값의 정밀도(유효숫자)를 관찰할 수 있도록 설정

(define (sqrt-iter guess x)
  (if (good-enough? guess (improve guess x))
      guess
      (sqrt-iter (improve guess x) x)))

(define (improve guess x)
  (average guess (/ x guess)))

(define (average x y)
  (/ (+ x y) 2))

(define (sqrt x)
  (sqrt-iter 1.0 x)) ;; 초기값을 실수로 정의

(sqrt 4)
(sqrt 123456789012345)
(sqrt 0.00000000123456)
