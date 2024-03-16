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

(define (iterative-improve good-enough? improve)
 (define (iter guess)
   (if (good-enough? guess)
       guess
       (iter (improve guess))))
 iter)

(define (fixed-point f first-guess)
  (define tolerance 0.00001)
  (define (close-enough? v1 v2)
    (< (abs (- v1 v2))
       tolerance))
  ((iterative-improve
    (lambda (x) (close-enough? x (f x)))
    f)
   first-guess))

; (define (fixed-point f first-guess)
;   (define tolerance 0.00001)
;   (define (close-enough? v1 v2)
;     (< (abs (- v1 v2)) 
;        tolerance))
;   (define (try guess)
;     (let ((next (f guess)))
;       (if (close-enough? guess next)
;           next
;           (try next))))
;   (try first-guess))


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

(define (compose f g)
  (lambda (x)
    (f (g x))))

(define (repeated f n)
  (if (= n 1)
    f
    (compose f (repeated f (- n 1)))))

(define (list-ref items n)
  (if (= n 0)
      (car items)
      (list-ref (cdr items) 
                (- n 1))))

(define (length items)
  (if (null? items)
      0
      (+ 1 (length (cdr items)))))

(define (length items)
  (define (length-iter a count)
    (if (null? a)
        count
        (length-iter (cdr a) 
                     (+ 1 count))))
  (length-iter items 0))

(define (append list1 list2)
  (if (null? list1)
      list2
      (cons (car list1) 
            (append (cdr list1) 
                    list2))))

(define (last-pair items)
  (if (null? (cdr items))
    items
    (last-pair (cdr items))))

(define (reverse items)
  (if (null? items)
    items
    (append (reverse (cdr items))
            (list (car items)))))

(define (reverse-iter items)
  (define (iter rest result)
    (if (null? rest)
      result
      (iter (cdr rest) (cons (car rest) result))))
  (iter items '()))

; (define (map proc items)
;   (if (null? items)
;       nil
;       (cons (proc (car items))
;             (map proc (cdr items)))))

(define (scale-list items factor)
  (map (lambda (x) (* x factor))
       items))

(define (for-each proc items)
  (if (null? items)
    #t
    (and (proc (car items))
         (for-each proc (cdr items)))))

(define (count-leaves x)
  (cond ((null? x) 0)
        ((not (pair? x)) 1)
        (else (+ (count-leaves (car x))
                 (count-leaves (cdr x))))))

; (define (scale-tree tree factor)
;   (cond ((null? tree) nil)
;         ((not (pair? tree)) 
;          (* tree factor))
;         (else
;          (cons (scale-tree (car tree) 
;                            factor)
;                (scale-tree (cdr tree) 
;                            factor)))))

(define (scale-tree tree factor)
  (map (lambda (sub-tree)
         (if (pair? sub-tree)
             (scale-tree sub-tree factor)
             (* sub-tree factor)))
       tree))

(define (tree-map proc tree)
  (map (lambda (sub-tree)
         (if (pair? sub-tree)
           (tree-map proc sub-tree)
           (proc sub-tree)))
       tree))

(define (square-tree tree)
  (tree-map square tree))

(define (filter predicate sequence)
  (cond ((null? sequence) nil)
        ((predicate (car sequence))
         (cons (car sequence)
               (filter predicate 
                       (cdr sequence))))
        (else  (filter predicate 
                       (cdr sequence)))))

(define (accumulate op initial sequence)
  (if (null? sequence)
      initial
      (op (car sequence)
          (accumulate op 
                      initial 
                      (cdr sequence)))))

; (accumulate + 0 (list 1 2 3 4 5))
; 15
; (accumulate * 1 (list 1 2 3 4 5))
; 120
; (accumulate cons nil (list 1 2 3 4 5))
; (1 2 3 4 5)

; =~ range
(define (enumerate-interval low high)
  (if (> low high)
      nil
      (cons low 
            (enumerate-interval 
             (+ low 1) 
             high))))

; =~ fringe
(define (enumerate-tree tree)
  (cond ((null? tree) nil)
        ((not (pair? tree)) (list tree))
        (else (append 
               (enumerate-tree (car tree))
               (enumerate-tree (cdr tree))))))

(define fold-right accumulate)

(define (fold-left op initial sequence)
  (define (iter result rest)
    (if (null? rest)
        result
        (iter (op result (car rest))
              (cdr rest))))
  (iter initial sequence))

; flatmap := append(flatten) + map
(define (flatmap proc seq)
  (accumulate append nil (map proc seq)))

(define (prime-sum? pair)
  (prime? (+ (car pair) (cadr pair))))

(define (make-pair-sum pair)
  (list (car pair) 
        (cadr pair) 
        (+ (car pair) (cadr pair))))

(define (prime-sum-pairs n)
  (map make-pair-sum
       (filter 
        prime-sum?
        (flatmap
         (lambda (i)
           (map (lambda (j) 
                  (list i j))
                (enumerate-interval 
                 1 
                 (- i 1))))
         (enumerate-interval 1 n)))))

; S의 각 원소 x에 대하여, S-x 의 순열을 모두 구해 차례열로 묶어낸다.
; 차례열 속에 있는 각 순열의 맨 앞에 x를 덧붙이다.
; 그리하면, S의 각 원소 x에 대하여 x로 시작되는 모든 순열을 얻을 수 있다.
; 이때, S의 순열을 구하는 문제가 S보다 원소가 적은 집합에서 순열을 구하는 문제로 작아지고 있음을 눈여겨보자.
; =~ subsets procedure

(define (permutations s)
  (if (null? s)   ; empty set?
      (list nil)  ; sequence containing empty set
      (flatmap (lambda (x)
                 (map (lambda (p) 
                        (cons x p))
                      (permutations 
                       (remove x s))))
               s)))

(define (remove item sequence)
  (filter (lambda (x) (not (= x item)))
          sequence))

(define (memq item x)
  (cond ((null? x) false)
        ((eq? item (car x)) x)
        (else (memq item (cdr x)))))

(define (attach-tag type-tag contents)
  (cons type-tag contents))

(define (type-tag datum)
  (if (pair? datum)
      (car datum)
      (error "Bad tagged datum: 
              TYPE-TAG" datum)))

(define (contents datum)
  (if (pair? datum)
      (cdr datum)
      (error "Bad tagged datum: 
              CONTENTS" datum)))

(define (apply-generic op . args)
  (let ((type-tags (map type-tag args)))
    (let ((proc (get op type-tags)))
      (if proc
          (apply proc (map contents args))
          (error
            "No method for these types: 
             APPLY-GENERIC"
            (list op type-tags))))))
