(load "./src/ch3/table/closure-table.scm")

(define operation-table (make-table equal?))
(define get (operation-table 'lookup-proc))
(define put (operation-table 'insert-proc!))
(define print (operation-table 'print-table))


(put (list 'a) 1)

(put (list 'a 'b) 2)

(put (list 'a 'b 'c) 300)

(put (list 'a 'b 'd) 200)

(print)

(get (list 'a 'b))

(get (list 'a 'b 'c))
