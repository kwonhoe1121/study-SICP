(load "./src/lib/util.scm")

(define (reverse sequence)
  (fold-right 
   (lambda (x y) (append y (list x))) nil sequence))

(define (reverse sequence)
  (fold-left 
   (lambda (x y) (cons y x)) nil sequence))

; (display (reverse (list 1 2 3 4)))
