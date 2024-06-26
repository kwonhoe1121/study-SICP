(define (RLC R L C dt)
  (define (vi vc0 il0)
    (define vc (integral (delay dvc) vc0 dt))
    (define il (integral (delay dil) il0 dt))
    (define dvc (scale-stream (/ (- 1.0) C) il))
    (define dil (add-streams (scale-stream il (- (/ R L)))
                             (scale-stream vc (- (/ 1.0 L)))))
    (define (zip s1 s2)
      (cons-stream (cons (stream-car s1) (stream-car s2))
                   (zip (stream-cdr s1) (stream-cdr s2))))
    (zip vc il))
  vi)
