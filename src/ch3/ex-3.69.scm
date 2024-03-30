; (1 1 1) + (1 1 z) + (1 y z) + (x y z)

(define (triples s t u)
  (cons-stream
    (list (stream-car s) (stream-car t) (stream-car u))
    (interleave
      (stream-map
        (lambda (x) (list (stream-car s) (stream-car t) x))
        (stream-cdr u))
      (interleave
        (stream-map
          (lambda (x) (cons-stream (stream-cdr s) x))
          (pairs (stream-cdr t) (stream-cdr u)))
        (triples (stream-cdr s)
                 (stream-cdr t)
                 (stream-cdr u))))))

(define (pythagorean-triples s)
  (define (pythagorean-triples? pair)
    (let ((i (car pair))
          (j (cadr pair))
          (k (caddr pair)))
      (= (+ (square i) (square j))
         (square k))))
  (let ((found-stream (stream-filter pythagorean-triples? s)))
    (cons-stream
      (stream-car found-stream)
      (pythagorean-triples (stream-cdr found-stream)))))

; [참고답안]

(define (triples s t u)
  (cons-stream
    (list (stream-car s) (stream-car t) (stream-car u))
    (interleave
      (stream-map
        (lambda (x) (cons (stream-car s) x))
        (stream-cdr (pairs t u)))
      (triples (stream-cdr s)
               (stream-cdr t)
               (stream-cdr u)))))

(define (phythagorean-numbers)
  (define (square x) (* x x))
  (define numbers (triples integers integers integers))
  (stream-filter
    (lambda (x)
      (= (square (caddr x))
         (+ (square (car x))
            (square (cadr x)))))
    numbers))
