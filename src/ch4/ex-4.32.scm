 ; * 스트림을 사용하여 무한 길이의 선형 목록을 구성할 수 있습니다.
 ; * 그러나 게으른 지연 목록을 사용하여 무한한 깊이의 트리를 구성할 수 있습니다.

(define code
'((define (cons x y)
  (lambda (m) (m x y)))
(define (car z)
  (z (lambda (p q) p)))
(define (cdr z)
  (z (lambda (p q) q)))

(define (make-tree value left right)
  (cons value (cons left right)))

(define nil-tree (make-tree "X" "X" "X"))

(define (nil-tree? tree)
  (eq? tree nil-tree))

(define (tree-value tree)
  (car tree))

(define (tree-left tree)
  (car (cdr tree)))

(define (tree-right tree)
  (cdr (cdr tree)))

(define (make-random-tree value)
  (make-tree value
             (if (= (modulo value 5) 0)
               nil-tree
               (make-random-tree (+ value 3)))
             (if (= (modulo value 8) 0)
               nil-tree
               (make-random-tree (* value 2)))))

(define (display-tree tree depth-limit)
  (define (go tree d)
    (cond ((nil-tree? tree)
           (print (indent d "-")))
          (else
            (print (indent d (tree-value tree)))
            (cond ((>= (+ d 1) depth-limit)
                   (print (indent d "...")))
                  (else
                    (print (indent d "Left:"))
                    (go (tree-left tree) (+ d 1))
                    (print (indent d "Right:"))
                    (go (tree-right tree) (+ d 1)))))))
  (go tree 0))

(display-tree (make-random-tree 3) 3)
(display-tree (make-random-tree 3) 8)
))
