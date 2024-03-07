(load "./src/lib/util.scm")

(define (fringe items)
  (cond ((null? items) nil)
        ((pair? items) (append (fringe (car items))
                               (fringe (cdr items))))
        (else 
          (list items))))


(define x (list (list 1 2) (list 3 4))) ; ((1 2) (3 4))

; (display (fringe x)) ; (1 2 3 4)
; (display (fringe (list x x))) ; (1 2 3 4 1 2 3 4)
