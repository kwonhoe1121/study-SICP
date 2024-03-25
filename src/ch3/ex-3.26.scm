; entry-node := record := <key, value>
; unordered list -> binary tree

; [참고답안]

(define (entry tree) (car tree))
(define (left-branch tree) (cadr tree))
(define (right-branch tree) (caddr tree))
(define (make-tree entry-record left right)
  (list entry-record left right))

(define (adjoin-set x set)
  (cond ((null? set) (make-tree x '() '()))
        ((< (car x) (car (entry set)))
         (let (left (left-branch set))
           (set! left (adjoin-set x left))))
        ((> (car x) (car (entry set)))
         (let (right (right-branch set))
           (set! right (adjoin-set x right))))))

(define (assoc key record-tree)
  (cond ((null? record-tree) false)
        ((eq? key (car (entry record-tree)) (entry record-tree)))
        ((< key (car (entry record-tree)) (assoc key (left-branch record-tree))))
        ((> key (car (entry record-tree)) (assoc key (right-branch record-tree))))))

(define (make-table)
  (let (local-table (list '*table*))
    (define (look-up key)
      (let ((record (assoc key (cdr local-table))))
        (if record
            (cdr record)
            false)))

    (define (insert! key value)
      (let ((record (assoc key (cdr local-table))))
        (if record
            (set-cdr! record value)
            (adjoin-set (cons key value) (cdr local-table)))
        'ok))

    (define (dispatch m)
      (cond ((eq? m 'lookup-proc) look-up)
            ((eq? m 'insert-proc!) insert!)
            (else "No such operation on table" m)))
    dispatch))
