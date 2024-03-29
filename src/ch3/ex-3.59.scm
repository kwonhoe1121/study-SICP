(load "./src/ch3/stream/stream.scm")

; (a)

(define (integrate-series s c)
  (cons-stream
    c
    (mul-streams
      s
      (/ 1 integers))))

(define exp-series
  (cons-stream 
   1 (integrate-series exp-series)))

; (b)

(define cosine-series 
  (cons-stream
    1
    (stream-map
      (lambda (x) (- x))
      (integrate-series cosine-series))))

(define sine-series
  (cons-stream
    0
    (integrate-series
      (stream-map
        (lambda (x) (- x))
        sine-series))))

; [참고답안]

(define (integrate-series s)
  (stream-map
    *
    (stream-map / ones integers)
    s))

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
