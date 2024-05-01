; (a) - recursive

(define (count-leaves tree)
  (cond ((null? tree) 0)
        ((not (pair? tree)) 1)
        (else 
         (+ (count-leaves (car tree))
            (count-leaves (cdr tree))))))

(define count-leaves-machine
  (make-machine
    (list (list '+ +) (list 'null? null?)
          (list 'pair? pair?) (list 'car car) (list 'cdr cdr))
    '((assign continue (label count-leaves-done))
      (assign val (const 0))
      tree-loop
      (test (op null?) (reg tree))
      (branch (label null-tree))
      (test (op pair?) (reg tree))
      (branch (label left-tree))
      (assign val (const 1))
      (goto (reg continue))
      left-tree
      (save tree)
      (save continue)
      (assign continue (label right-tree))
      (assign tree (op car) (reg tree))
      (goto (label tree-loop))
      right-tree
      (restore continue)
      (restore tree)
      (save continue)
      (save val)
      (assign continue (label after-tree))
      (assign tree (op cdr) (reg tree))
      (goto (label tree-loop))
      after-tree
      (assign var (reg val))
      (restore val)
      (restore continue)
      (assign val (op +) (reg var) (reg val))
      (goto (reg continue))
      null-tree
      (assign val (const 0))
      (goto (reg continue))
      count-leaves-done)))


; (b) - iterative

(define (count-leaves tree)
  (define (count-iter tree n)
    (cond ((null? tree) n)
          ((not (pair? tree)) (+ n 1))
          (else 
           (count-iter 
            (cdr tree)
            (count-iter (car tree) 
                        n)))))
  (count-iter tree 0))

 (define count-leaves
   (make-machine
     `((car ,car) (cdr ,cdr) (pair? ,pair?)
       (null? ,null?) (+ ,+))
     '(start
       (assign val (const 0))
       (assign continue (label done))
       (save continue)
       (assign continue (label cdr-loop))
       count-loop
       (test (op pair?) (reg lst))
       (branch (label pair))
       (test (op null?) (reg lst))
       (branch (label null))
       (assign val (op +) (reg val) (const 1))
       (restore continue)
       (goto (reg continue))
       cdr-loop
       (restore lst)
       (assign lst (op cdr) (reg lst))
       (goto (label count-loop))
       pair
       (save lst)
       (save continue)
       (assign lst (op car) (reg lst))
       (goto (label count-loop))
       null
       (restore continue)
       (goto (reg continue))
       done)))

