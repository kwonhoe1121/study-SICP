(define (square n) (* n n))
(define (cube n) (* n n n))
(define (average x y) (/ (+ x y) 2))

(define (even? n) (= (remainder n 2) 0))

(define (expt b n)
  (cond ((= n 0) 1)
        ((even? n) (square (expt b (/ n 2))))
        (else (* b (expt b (- n 1))))))

(define (double x) (+ x x)) 
(define (halve x) (/ x 2))

; gcd(a, b) = gcd(b, r)
(define (gcd a b)
  (if (= b 0)
    a
    (gcd b (remainder a b))))

; find prime number - O(√n)
(define (smallest-divisor n)
  (find-divisor n 2))

(define (divides? a b)
  (= (remainder b a) 0))

(define (find-divisor n test-divisor)
  (cond ((> (square test-divisor) n) n)
        ((divides? test-divisor n) test-divisor)
        (else (find-divisor 
               n 
               (+ test-divisor 1)))))

(define (prime? n)
  (= n (smallest-divisor n)))

; find prime number - O(log(n))

;; if a^n modulo n != a is not prime number
;; stochastically, n is pirme number
(define (expmod base exp m)
  (cond ((= exp 0) 1)
        ((even? exp)
         (remainder (square (expmod base (/ exp 2) m)) ; It is similar to fast-expt
                    m))
        (else
          (remainder (* base (expmod base (- exp 1) m))
                     m))))

(define (fermat-test n)
  (define (try-it a)
    (= (expmod a n n) a))
  (try-it (+ 1 (random (- n 1)))))

(define (fast-prime? n times)
  (cond ((= times 0) true)
        ((fermat-test n) (fast-prime? n (- times 1)))
        (else false)))

(define (sum term a next b)
  (if (> a b)
      0
      (+ (term a)
         (sum term (next a) next b))))

(define (inc n) (+ n 1))
(define (identity x) x)

(define (integral f a b dx)
  (define (add-dx x) (+ x dx))
  (* (sum f (+ a (/ dx 2.0)) add-dx b) 
     dx))

; search f(x) = 0
; if f(x) > 0 then  search [a, x]
; else search [x, b]
; ∴ O(log(L/T))
(define (search f neg-point pos-point)
  (define (close-enough? x y) 
      (< (abs (- x y)) 0.001))
  (let ((midpoint 
         (average neg-point pos-point)))
    (if (close-enough? neg-point pos-point)
        midpoint
        (let ((test-value (f midpoint)))
          (cond 
           ((positive? test-value)
            (search f neg-point midpoint))
           ((negative? test-value)
            (search f midpoint pos-point))
           (else midpoint))))))

(define (half-interval-method f a b)
  (let ((a-value (f a))
        (b-value (f b)))
    (cond ((and (negative? a-value) 
                (positive? b-value))
           (search f a b))
          ((and (negative? b-value) 
                (positive? a-value))
           (search f b a))
          (else
           (error "Values are not of 
                   opposite sign" a b)))))

(define (fixed-point f first-guess)
  (define tolerance 0.00001)
  (define (close-enough? v1 v2)
    (< (abs (- v1 v2)) 
       tolerance))
  (define (try guess)
    (let ((next (f guess)))
      (if (close-enough? guess next)
          next
          (try next))))
  (try first-guess))

; x |-> 1 + 1/x
(define (phi)
  (fixed-point
    (lambda (x) (average x (+ 1 (/ 1 x))))
    1.0))

(define (count-frac n d k)
  (define (recur i)
    (if (> i k)
      0
      (/ (n i)
         (+ (d i) (recur (+ i + 1))))))
  (recur 1))

(define (average-damp f)
  (lambda (x) 
    (average x (f x))))

(define (newton-transform g)
  (define (deriv g)
    (define dx 0.00001)
    (lambda (x)
      (/ (- (g (+ x dx)) (g x))
         dx)))
  (lambda (x)
    (- x (/ (g x) 
            ((deriv g) x)))))

(define (newtons-method g guess)
  (fixed-point (newton-transform g) 
               guess))

(define (fixed-point-of-transform g transform guess)
  (fixed-point (transform g)
               guess))

; y = sqrt(x)
; y^2 = x
; y |-> x/y
(define (sqrt x)
  (fixed-point-of-transform
    (lambda (y) (/ x y))
    average-damp ; 평균 감쇄 변환 방식
   1.0))

; y |-> y²-x
(define (sqrt x)
  (fixed-point-of-transform 
     (lambda (y) (- (square y) x))
     newton-transform ; 뉴튼 변환 방식
   1.0))
