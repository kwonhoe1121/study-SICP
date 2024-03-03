(load "./src/lib/util.scm")

; recur

(define (filtered-accumulate
          predicate
          combiner
          null-value
          term
          a
          next
          b)
  (cond ((> a b) null-value)
        ((not (predicate a)) (filtered-accumulate
                               predicate
                               combiner
                               null-value
                               term
                               (next a)
                               next
                               b))
        (else (combiner (term a)
                        (filtered-accumulate
                          predicate
                          combiner
                          null-value
                          term
                          (next a)
                          next
                          b)))))

; iter

(define (filtered-accumulate-iter
          predicate
          combiner
          null-value
          term
          a
          next
          b)
  (define (iter a result)
    (cond ((> a b) result)
          ((not (predicate a)) (iter (next a) result))
          (else
            (iter (next a)
                  (combiner result (term a))))))
  (iter a null-value))

; (a) - 모든 소수를 제곱하여 더하는 식

(define (sum-of-prime-square a b)
  (filtered-accumulate-iter prime? + 0 square a inc b))

; (b) - 모든 서로소 곱하는 식

(define (sum-of-coprimes n)
  (define (coprime? k) (and (< k n) (= (gcd k n) 1)))
  (filtered-accumulate-iter coprime? * 1 identity 1 inc n))
