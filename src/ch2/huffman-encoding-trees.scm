(load "./src/ch2/ordered-list-sets.scm")

; 허프만 알고리즘 = 가장 적게 나오는 글자가 나무 뿌리에서 가장 떨어져 있게끔 트리 구조로 표현.
; 한 단계를 거칠 때마다 가장 가벼운 마디 둘을 골라내어 하나로 묶은 다음에, 그 두 마디를 집합에서 없애고, 그 둘을 오른쪽 가지와 왼쪽 가지로 묶은 새 마디를 만들어서 집어넣는다.

(define (make-leaf symbol weight)
  (list 'leaf symbol weight))
(define (leaf? object)
  (eq? (car object) 'leaf))
(define (symbol-leaf x) (cadr x))
(define (weight-leaf x) (caddr x))

(define (make-code-tree left right)
  (list left
        right
        (append (symbols left) 
                (symbols right))
        (+ (weight left) (weight right))))

(define (left-branch tree) (car tree))
(define (right-branch tree) (cadr tree))

(define (symbols tree)
  (if (leaf? tree)
      (list (symbol-leaf tree))
      (caddr tree)))

(define (weight tree)
  (if (leaf? tree)
      (weight-leaf tree)
      (cadddr tree)))

(define (decode bits tree)
  (define (decode-1 bits current-branch)
    (if (null? bits)
        '()
        (let ((next-branch
               (choose-branch 
                (car bits) 
                current-branch)))
          (if (leaf? next-branch)
              (cons 
               (symbol-leaf next-branch)
               (decode-1 (cdr bits) tree))
              (decode-1 (cdr bits) 
                        next-branch)))))
  (decode-1 bits tree))

(define (choose-branch bit branch)
  (cond ((= bit 0) (left-branch branch))
        ((= bit 1) (right-branch branch))
        (else (error "bad bit: 
               CHOOSE-BRANCH" bit))))

(define (adjoin-set x set)
  (cond ((null? set) (list x))
        ((< (weight x) (weight (car set))) 
         (cons x set))
        (else 
         (cons (car set)
               (adjoin-set x (cdr set))))))

(define (make-leaf-set pairs)
  (if (null? pairs)
      '()
      (let ((pair (car pairs)))
        (adjoin-set 
         (make-leaf (car pair)    ; symbol
                    (cadr pair))  ; frequency
         (make-leaf-set (cdr pairs))))))

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
