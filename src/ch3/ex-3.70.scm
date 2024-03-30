(define (merge-weighted weight s1 s2)
  (cond ((stream-null? s1) s2)
        ((stream-null? s2) s1)
        (else
          (let ((s1car (stream-car s1))
                (s2car (stream-car s2)))
            (cond ((< (weight s1car) (weight s2car))
                   (cons-stream
                     s1car
                     (merge (stream-cdr s1)
                            s2)))
                  ((> (weight s1car) (weight s2car))
                   (cons-stream
                     s2car
                     (merge s1
                            (stream-cdr s2))))
                  (else
                    (cons-stream
                      s1car
                      (merge
                        (stream-cdr s1)
                        (stream-cdr s2)))))))))

(define (weighted-pairs weight s t)
  (cons-stream
    (list (stream-car s) (stream-car t))
    (merge-weighted
      weight
      (stream-map
        (lambda (x) (list (stream-car s) x))
        (stream-cdr t))
      (weighted-pairs
        weight
        (stream-cdr s)
        (stream-cdr t)))))

; (a) - weighted-pairs 는 이미 i <= j 집합만 가지고 있다.

(define weight1 (lambda (x) (+ (car x) (cadr x))))
(define pairs1 (weighted-pairs weight1 integers integers))

; (b)

(define weight2 (lambda (x) (+ (* 2 (car x)) (* 3 (cadr x)) (* 5 (car x) (cadr x)))))
(define (divide? x y) (= (remainder y x) 0))
(define stream235
  (stream-filter (lambda (x) (not (or (divide? 2 x) (divide? 3 x) (divide? 5 x))))
                 integers))
(define pairs2 (weighted-pairs weight2 stream235 stream235))
