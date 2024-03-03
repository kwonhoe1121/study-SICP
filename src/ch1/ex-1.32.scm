; 결합적인 이항연산자 + 항등원 => 모노이드
; | combiner | e |
; | -------- | - |
; | sum      | 0 |
; | product  | 1 |

; (a) - recur accumulate - right fold

(define (accumulate combiner null-value term a next b)
  (if (> a b)
    null-value
    (combiner (term a)
              (accumulate combiner null-value term (next a) next b))))

; (b) - iter accumulate - left fold

(define (accumulate-iter combiner null-value term a next b)
  (define (iter a result)
    (if (> a b)
      result
      (iter (next a) (combiner result (term a)))))
  (iter a null-value))

; test

(define (sum term a next b)
  (accumulate + 0 term a next b))

(define (product term a next b)
  (accumulate * 1 term a next b))

(define (sum-integer a b)
  (sum identity a inc b))

(define (product-integer a b)
  (product identity a inc b))
