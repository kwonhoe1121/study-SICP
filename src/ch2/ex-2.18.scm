(load "./src/lib/util.scm")

(define (reverse items)
  (if (null? items)
    items
    (append (reverse (cdr items))
            (list (car items)))))

(define (reverse-iter items)
  (define (iter rest result)
    (if (null? rest)
      result
      (iter (cdr rest) (cons (car rest) result))))
  (iter items '()))

; (display (reverse (list 1 4 9 16 25)))
; (display (reverse-iter (list 1 4 9 16 25)))
