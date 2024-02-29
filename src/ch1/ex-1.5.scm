(define (p) (p))

(define (test x y)
  (if (= x 0)
    0
    (y)))

;; applicatvie order evaluation => 인수 (p)가 평가되면서 무한 루프 형성 => Lisp 실행기
;; normal-order evaluation => 0
(test 0 (p))

