(load "./src/lib/util.scm")

(define (unique_triples n)
  (flatmap
    (lambda (i)
      (flatmap
        (lambda (j)
          (map (lambda (k) (list i j k))
               (enumerate-interval 1 (- j 1))))
        enumerate-interval 1 (- i 1)))
    (enumerate-interval 1 n)))

(define (exact-sum? s)
  (lambda (p) (= s (fold-right + p))))

(define (exact-sum-pair n s)
  (filter
    (exact-sum? s)
    (unique_triples n)))
