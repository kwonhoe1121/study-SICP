(load "./src/ch2/binary-tree-sets.scm")

; (a) - 아래는 모두 중위 순회하므로, 같은 리스트 목록을 반환한다.

; (b) - tree->list-1 복잡도 := O(n*logn) = append(O(n)) * tree(O(logn)) - 각 노드마다 append의 시간 복잡도 O(n)을 수행하므로
; (b) - tree->list-2 복잡도 := O(n)

(define (tree->list-1 tree)
  (if (null? tree)
      '()
      (append 
       (tree->list-1 
        (left-branch tree))
       (cons (entry tree)
             (tree->list-1 
              (right-branch tree))))))

(define (tree->list-2 tree)
  (define (copy-to-list tree result-list)
    (if (null? tree)
        result-list
        (copy-to-list 
         (left-branch tree)
         (cons (entry tree)
               (copy-to-list 
                (right-branch tree)
                result-list)))))
  (copy-to-list tree '()))


(define tree1 (make-tree 7
                         (make-tree 3
                                    (make-tree 1 nil nil)
                                    (make-tree 5 nil nil))
                         (make-tree 9
                                    nil
                                    (make-tree 11 nil nil))))

(define tree2 (make-tree 3
                         (make-tree 1 nil nil)
                         (make-tree 7
                                    (make-tree 5 nil nil)
                                    (make-tree 9 
                                               nil
                                               (make-tree 11 nil nil)))))

(define tree3 (make-tree 5
                         (make-tree 3
                                    (make-tree 1 nil nil)
                                    nil)
                         (make-tree 9
                                    (make-tree 7 nil nil)
                                    (make-tree 11 nil nil))))

; (display (tree->list-1 tree1))
; (display (tree->list-1 tree2))
; (display (tree->list-1 tree3))

; (display (tree->list-2 tree1))
; (display (tree->list-2 tree2))
; (display (tree->list-2 tree3))
