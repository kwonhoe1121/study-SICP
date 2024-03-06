(load "./src/lib/util.scm")

(define (square-list items)
  (if (null? items)
    nil
    (cons (square (car items))
          (square-list (cdr items)))))

(define (square-list items)
  (map square items))

(display (square-list (list 1 2 3 4)))
