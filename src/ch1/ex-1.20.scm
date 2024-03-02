(load "./src/ch1/ex-1.6.scm")

;; 장상 순서 평가
; gcd(a, b) = gcd(b, r)
(define (gcd a b)
  (if (= b 0)
    a
    (gcd b (remainder a b))))

; (gcd 9 3)
; ...
; (if (= 3 0)
;   9
;   (gcd 3 (remainder 9 3)))
; ...
; (if (= (remainder 9 3) 0)
;     3
;     (gcd (remainder 9 3) (remainder 3 (remainder 9 3))))
; ...
; (if (= 0 0)
;     3
;     (gcd (remainder 9 3) (remainder 3 (remainder 9 3))))
; ∴ 3

;; 인수 우선 평가
(define (gcd a b)
  (new-if (= b 0)
          a
          (gcd b (remainder a b))))

; (gcd 9 3)
; ...
; (new-if
;   (= 3 0)
;   9
;   (gcd 3 3))
; ...
; (new-if
;   (= 3 0)
;   9
;   (new-if
;     (= 3 0)
;     3
;     (gcd 3 0))
; ...
; (new-if
;   (= 3 0)
;   9
;   (new-if
;     (= 3 0)
;     3
;     (new-if
;       (= 0 0)
;       3
;       (gcd 0 (remainder 3 0)))) ;; ∴ remainder: division by zero [,bt for context]
