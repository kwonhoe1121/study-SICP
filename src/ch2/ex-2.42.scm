(load "./src/lib/util.scm")

(define (queens board-size)
  (define empty-board nil)
  (define (adjoin-position row col rest) (cons (cons row col) rest))
  (define (safe? k positions)
    (let ((first-row (car (car positions)))
          (first-col (cdr (car positions))))
      (fold-right
        (lambda (pos so-far)
          (let ((row (car pos))
                (col (cdr pos)))
            (and so-far
                 (not (= (- first-row first-col) 
                         (- row col)))
                 (not (= (+ first-row first-col) 
                         (+ row col)))
                 (not (= first-row row))))) 
        #t
        (cdr positions))))
  (define (queen-cols k)
    (if (= k 0)
        (list empty-board)
        (filter  
         (lambda (positions) 
           (safe? k positions))  
         (flatmap 
          (lambda (rest-of-queens)
            (map (lambda (new-row) 
                   (adjoin-position 
                    new-row 
                    k 
                    rest-of-queens))
                 (enumerate-interval 
                  1 
                  board-size)))
          (queen-cols (- k 1)))))) 
  (queen-cols board-size))

; (display (queens 5))
; (display (queens 8))
