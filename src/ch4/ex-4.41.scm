; [참고답안]

(define (flatmap proc li)
  (if (null? li)
      '()
      (let ((result (proc (car li)))
            (rest (flatmap proc (cdr li))))
           (if (pair? result)
               (append result rest)
               (cons result rest)))))

; 순열 -> 순서 중요

(define (permutations lists)
  (if (null? lists)
      '(())
      (flatmap (lambda (x)
                       (map (lambda (y) (cons x y))
                            (permutations (cdr lists))))
               (car lists))))

(define (restrictions l)
  (apply
    (lambda (baker cooper fletcher miller smith)
            (and (> miller cooper)
                 (not (= (abs (- smith fletcher)) 1))
                 (not (= (abs (- fletcher cooper)) 1))
                 (distinct? (list baker cooper fletcher miller smith))))
    l))

(define (mutiple-dwelling)
  (let ((baker '(1 2 3 4))
        (cooper '(2 3 4 5))
        (fletcher '(2 3 4))
        (miller '(3 4 5))
        (smith '(1 2 3 4 5)))
       (filter restrictions (permutations (list baker cooper fletcher miller smith)))))
