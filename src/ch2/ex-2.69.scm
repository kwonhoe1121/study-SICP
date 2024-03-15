(load "./src/ch2/ex-2.68.scm")

(define (generate-huffman-tree pairs)
  (successive-merge 
   (make-leaf-set pairs)))

(define (successive-merge sets)
  (if (= (length sets) 1)
    (car sets)
    (let ((x1 (car sets))
          (x2 (cadr sets))
          (rest-sets (cddr sets)))
      (successive-merge
        (adjoin-set (make-code-tree x1 x2)
                    sets)))))

; (define sample-tree
;   (make-code-tree
;     (make-leaf 'A 4)
;     (make-code-tree
;       (make-leaf 'B 2)
;       (make-code-tree
;         (make-leaf 'D 1)
;         (make-leaf 'C 1)))))

; (define sample-frequencies
;   (list (list 'A 4)
;         (list 'B 2)
;         (list 'C 1)
;         (list 'D 1)))

; (display (equal? sample-tree (generate-huffman-tree sample-frequencies)))
