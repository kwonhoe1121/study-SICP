(define (new-if predicate then-clause else-clause)
  (cond (predicate then-clause)
        (else else-clause)))

;; 새로 정의한 new-if 프로시저는 인수 우선 평가로 인해서 sqrt-iter 평가가 무한 호출 된다.
(define (sqrt-iter guess x)
  (new-if (good-enough? guess x)
          guess
          (sqrt-iter (improve guess x) ;; 무한 호출
                     x)))
