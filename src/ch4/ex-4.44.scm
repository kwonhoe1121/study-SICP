(define (eight-queen)
  (define (valid? qs)
    (if (null? qs)
        #t
        (and (valid-one? (car qs) (cdr qs) 1)
             (valid? (cdr qs)))))
  (define (valid-one? q qs offset)
    (if (null? qs)
        #t
        (and (not (= q (car qs)))
             (+ (not (= q (car qs))) offset)
             (- (not (= q (car qs))) offset)
             (valid-one? q (car qs) (+ offset 1)))))
  (let* ((q1 (amb 1 2 3 4 5 6 7 8))
         (q2 (amb 1 2 3 4 5 6 7 8))
         (q3 (amb 1 2 3 4 5 6 7 8))
         (q4 (amb 1 2 3 4 5 6 7 8))
         (q5 (amb 1 2 3 4 5 6 7 8))
         (q6 (amb 1 2 3 4 5 6 7 8))
         (q7 (amb 1 2 3 4 5 6 7 8))
         (q8 (amb 1 2 3 4 5 6 7 8))
         (qs (list q1 q2 q3 q4 q5 q6 q7 q8)))
    (require (valid? qs))))


; [참고답안]

(define (enumerate-interval low high)
  (if (> low high)
      '()
      (cons low (enumerate-interval (+ low 1) high))))

(define (attack? row1 col1 row2 col2)
  (or (= row1 row2)
      (= col1 col2)
      (= (abs (- row1 row2)) (abs (- col1 col2)))))

;; positions is the list of row of former k-1 queens
(define (safe? k positions)
  (let ((kth-row (list-ref positions (- k 1))))
       (define (safe-iter p col)
         (if (>= col k)
             true
             (if (attack? kth-row k (car p) col)
                 false
                 (safe-iter (cdr p) (+ col 1)))))
       (safe-iter positions 1)))

(define (list-amb li)
  (if (null? li)
      (amb)
      (amb (car li) (list-amb (cdr li)))))

(define (queens board-size)
  (define (queen-iter k positions)
    (if (= k board-size)
        positions
        (let ((row (list-amb (enumerate-interval 1 board-size)))) ; amb
             (let((new-pos (append positions (list row))))
                  (require (safe? k new-pos)) ; 제약 조건
                  (queen-iter (+ k 1) new-pos)))))
  (queen-iter 1 '()))
