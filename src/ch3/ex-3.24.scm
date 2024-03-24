(load "./src/ch3/table/closure-table.scm")

; (define operation-table (make-table equal?))
(define operation-table (make-table (lambda (x y) (< (abs (- x y)) 0.1))))
(define get (operation-table 'lookup-proc))
(define put (operation-table 'insert-proc!))

(put 1.0 1.0 'hello)

(get 1.01 1.01)
