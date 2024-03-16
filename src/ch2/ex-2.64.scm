(load "./src/ch2/sets/binary-tree-sets.scm")

(define (list->tree elements)
  (car (partial-tree 
        elements (length elements))))

(define (partial-tree elts n)
  (if (= n 0)
      (cons '() elts)
      (let ((left-size 
             (quotient (- n 1) 2)))
        (let ((left-result 
               (partial-tree ; left tree
                elts left-size)))
          (let ((left-tree 
                 (car left-result))
                (non-left-elts 
                 (cdr left-result))
                (right-size 
                 (- n (+ left-size 1))))
            (let ((this-entry ; root
                   (car non-left-elts))
                  (right-result 
                   (partial-tree ; right tree
                    (cdr non-left-elts)
                    right-size)))
              (let ((right-tree
                     (car right-result))
                    (remaining-elts 
                     (cdr right-result)))
                (cons (make-tree this-entry 
                                 left-tree 
                                 right-tree)
                      remaining-elts))))))))

; (display (list->tree (list 1 3 5 7 9 11)))

; (5
;  (1 ()
;     (3 () ()))
;  (9 (7 () ())
;     (11 () ())))

; | n | elts           | left-size | left-result                 | left-tree        | right-size | right-result               | right-tree               | non-left-elts  |
; | - | ----           | --------- | -----------                 | ---------        | ---------- | ------------               | ----------               | -------------  |
; | 1 | (3 5 7 9 11)   | 0         | (() 3 5 7 9 11)             | ()               | 0          | (() 5 7 9 11)              | ()                       | (3 5 7 9 11)   |
; | 2 | (1 3 5 7 9 11) | 0         | (() 1 3 5 7 9 11)           | ()               | 1          | ((3 () ()) 5 7 9 11)       | (3 () ())                | (1 3 5 7 9 11) |
; | 1 | (7 9 11)       | 0         | (() 7 9 11)                 | ()               | 0          | (() 9 11)                  | ()                       | (7 9 11)       |
; | 1 | (11)           | 0         | (() 11)                     | ()               | 0          | (())                       | ()                       | (11)           |
; | 3 | (7 9 11)       | 1         | ((7 () ()) 9 11)            | (7 () ())        | 1          | ((11 () ()))               | (11 () ())               | (9 11)         |
; | 6 | (1 3 5 7 9 11) | 2         | ((1 () (3 () ())) 5 7 9 11) | (1 () (3 () ())) | 3          | ((9 (7 () ()) (11 () ()))) | (9 (7 () ()) (11 () ())) | (5 7 9 11)     |
