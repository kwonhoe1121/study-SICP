; [참고답안]

(define (lier)
  (let ((a (amb 1 2 3 4 5))
        (b (amb 1 2 3 4 5))
        (c (amb 1 2 3 4 5))
        (d (amb 1 2 3 4 5))
        (e (amb 1 2 3 4 5)))
       (require (or (and (= d 2) (not (= a 3))) (and (not (= d 2)) (= a 3))))
       (require (or (and (= b 1) (not (= c 2))) (and (not (= b 1)) (= c 2))))
       (require (or (and (= c 3) (not (= b 5))) (and (not (= c 3)) (= b 5))))
       (require (or (and (= d 2) (not (= e 4))) (and (not (= d 2)) (= e 4))))
       (require (or (and (= e 4) (not (= a 1))) (and (not (= e 4)) (= a 1))))
       (require (distinct? (list a b c d e)))
       (list a b c d e)))

; ∴ (3 5 2 1 4)
