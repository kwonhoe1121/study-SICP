(load "./src/ch2/ex-2.67.scm")

(define (encode message tree)
  (if (null? message)
      '()
      (append 
       (encode-symbol (car message) 
                      tree)
       (encode (cdr message) tree))))

(define (encode-symbol symbol tree)
  (if (leaf? tree)
    '()
    (let ((left-tree (left-branch tree))
          (right-tree (right-branch tree)))
      (cond ((memq symbol (symbols left-tree)) (cons 0 (encode-symbol symbol left-tree)))
            ((memq symbol (symbols right-tree)) (cons 1 (encode-symbol symbol right-tree)))
            (else (error "symbol not found -- encode-symbol" symbol))))))

; (display (encode (decode sample-message sample-tree) sample-tree)) ; (0 1 1 0 0 1 0 1 0 1 1 1 0)
