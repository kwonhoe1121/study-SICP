(load "./src/ch3/stream/stream.scm")

(define (integers-starting-from n)
  (cons-stream 
   n (integers-starting-from (+ n 1))))
(define integers (integers-starting-from 1))

(define (divisible? x y) (= (remainder x y) 0))
(define no-sevens
  (stream-filter (lambda (x) 
                   (not (divisible? x 7)))
                 integers))

(define (fibgen a b)
  (cons-stream a (fibgen b (+ a b))))
(define fibs (fibgen 0 1))

(define (sieve stream)
  (cons-stream
   (stream-car stream)
   (sieve (stream-filter
           (lambda (x)
             (not (divisible? 
                   x (stream-car stream))))
           (stream-cdr stream)))))

(define primes 
  (sieve (integers-starting-from 2)))

; 스트림의 재귀적 정의

(define ones (cons-stream 1 ones))

(define integers 
  (cons-stream 1 (add-streams ones integers)))

(define fibs 
  (cons-stream 
   0 (cons-stream
      1 (add-streams 
         (stream-cdr fibs) fibs))))

(define double 
  (cons-stream 1 (scale-stream double 2)))

(define primes
  (cons-stream
   2 (stream-filter 
      prime? (integers-starting-from 3))))

(define (prime? n)
  (define (iter ps)
    (cond ((> (square (stream-car ps)) n) true)
          ((divisible? n (stream-car ps)) false)
          (else (iter (stream-cdr ps)))))
  (iter primes))

(define (integrate-series s)
  (stream-map
    *
    (stream-map / ones integers)
    s))

(define exp-series
  (cons-stream 
   1 (integrate-series exp-series)))

(define sine-series
  (cons-stream
    0
    (integrate-series
      cosine-series)))

(define cosine-series
  (cons-stream
    1
    (integrate-series
      (scale-stream sine-series -1))))

(define (mul-series s1 s2)
  (cons-stream
    (* (stream-car s1) (stream-car s2))
    (add-streams
      (mul-series (stream-cdr s1) s2)
      (scale-stream (stream-cdr s2) (stream-car s1)))))

(define (invert-unit-series series)
  (define inverted-unit-series
    (cons-stream 1 (scale-stream (mul-streams (stream-cdr series)
                                              inverted-unit-series)
                                 -1)))
  inverted-unit-series)

(define (div-series s1 s2)
  (let ((c (stream-car s2)))
    (if (= c 0)
        (error "constant term of s2 can't be 0!")
        (scale-stream
          (mul-series
            s1
            (invert-unit-series
              (scale-stream
                s2
                (/ 1 c))))
          (/ 1 c)))))

(define tangent-series
  (div-series sine-series cosine-series))

(define (sqrt-stream x)
  (define guesses
    (cons-stream 
     1.0 (stream-map
          (lambda (guess)
            (sqrt-improve guess x))
          guesses)))
  guesses)

(define (pi-summands n)
  (cons-stream 
   (/ 1.0 n)
   (stream-map - (pi-summands (+ n 2)))))

(define pi-stream
  (scale-stream 
   (partial-sums (pi-summands 1)) 4))

; Sn+1 − (Sn+1 − Sn)^2 / (Sn−1 − 2Sn + Sn+1)

(define (euler-transform s)
  (let ((s0 (stream-ref s 0))     ; Sₙ₋₁
        (s1 (stream-ref s 1))     ; Sₙ
        (s2 (stream-ref s 2)))    ; Sₙ₊₁
    (cons-stream 
     (- s2 (/ (square (- s2 s1))
              (+ s0 (* -2 s1) s2)))
     (euler-transform (stream-cdr s)))))

; stream of stream

(define (make-tableau transform s)
  (cons-stream 
   s
   (make-tableau
    transform
    (transform s))))

; 순차열 가속기; 스트림을 변환시켜서 만들 수 있다.

(define (accelerated-sequence transform s)
  (stream-map stream-car
              (make-tableau transform s)))

; (display-stream 
;  (accelerated-sequence euler-transform
;                        pi-stream))
