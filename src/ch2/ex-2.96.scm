; GCD는 그저 분자와 분모를 나누는 데 쓰는 것이므로, 정수 인자는 저절로 사라지게 된다.
; 정수화 상수integerizing factor를 분자에 곱한 다음에 나누기하는 방식

; [참고 답안]

;; a
(define (pseudoremainder-terms a b)
  (let* ((o1 (order (first-term a)))
         (o2 (order (first-term b)))
         (c (coeff (first-term b)))
         (divident (mul-terms (make-term 0
                                         (expt c (+ 1 (- o1 o2))))
                              a))) ; 정수화 상수 분자에 곱한 값
    (cadr (div-terms divident b))))

(define (gcd-terms a b)
  (if (empty-termlist? b)
    a
    (gcd-terms b (pseudoremainder-terms a b))))

;; b
(define (gcd-terms a b)
  (if (empty-termlist? b)
    (let* ((coeff-list (map cadr a))
           (gcd-coeff (apply gcd coeff-list)))
      (div-terms a (make-term 0  gcd-coeff)))
    (gcd-terms b (pseudoremainder-terms a b))))
