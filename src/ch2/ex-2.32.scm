(load "./src/lib/util.scm")

(define (subsets s)
  (if (null? s)
      (list nil)
      (let ((rest (subsets (cdr s))))
        (append rest (map (lambda (x) (cons (car s) x)) rest)))))

; (display (subsets (list 1 2 3)))

; '(())               |-> '((3))                     given s = '(3)
; '(() (3))           |-> '((2) (2 3))               given s = '(2 3)
; '(() (3) (2) (2 3)) |-> '((1) (1 3) (1 2) (1 2 3)) given s = '(1 2 3)
