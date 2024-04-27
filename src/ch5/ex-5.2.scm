(define (fact n)
  (define (iter product counter)
    (if (> counter n)
      product
      (iter (* counter product)
            (+ counter 1)))
  (iter 1 1)))

; 레지스터 기계어로 표현

(define fact-machine
  (make-machine
    '(c p n)
    (list (list '* *) (list '+ +) (list '> >))
    '((assign c (const 1))
      (assign p (const 1))
      test-n
      (test (op >) (reg c) (reg n))
      (branch (label fact-done))
      (assign p (op *) (reg c) (reg p))
      (assign c (op +) (reg c) (const 1))
      (goto (label test-n))
      fact-done)))
