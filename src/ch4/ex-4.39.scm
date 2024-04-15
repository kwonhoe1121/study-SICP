; 결과는 동일하지만 amb, require 순서에 따라서 성능에 영향을 미친다.
; 순서에 따라서, 경우의 수가 줄어든다.
; amb ~> choice - combination - 조합(경우의 수)

(define (multiple-dwelling)
  (let ((baker (amb 1 2 3 4 5)))
    (require (not (= baker 5)))
    (let ((cooper (amb 1 2 3 4 5)))
      (require (not (= cooper 1)))
      ...
      (let ((smith (amb 1 2 3 4 5)))
        (require
          (distinct? (list baker cooper fletcher miller smith)))
        (require (not (= (abs (- smith fletcher)) 1)))
        ...))))
