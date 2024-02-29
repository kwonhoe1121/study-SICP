; 1.3
(define (square n)
  (* n n))

(define (sum-square x y)
  (+ (square x) (square y)))

(define (select-big-two-digit-and-sum-square x y z)
  (cond ((and (<= x y) (<= x z)) (sum-square y z))
        ((and (<= y x) (<= y z)) (sum-square x z))
        (else                    (sum-square x y))))

(select-big-two-digit-and-sum-square 10 1 3)
