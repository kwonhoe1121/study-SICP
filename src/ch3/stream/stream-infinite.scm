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
