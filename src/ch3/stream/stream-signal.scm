(load "./src/ch3/stream/stream.scm")

(define (integral integrand initial-value dt)
  (define int
    (cons-stream 
     initial-value
     (add-streams (scale-stream integrand dt)
                  int)))
  int)

(define (RC R C dt)
  (define (rc i v0)
    (add-streams
      (scale-stream i R)
      (integral (scale-stream i (/ 1.0 C))
                v0
                dt)))
  rc)
