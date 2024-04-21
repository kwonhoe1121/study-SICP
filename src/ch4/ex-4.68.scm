(assert! (rule (reverse () ())))
(assert! (rule (reverse ?x ?y)
               (and (append-to-form (?first) ?rest ?x)
                    (append-to-form ?rev-rest (?first) ?y)
                    (reverse ?rest ?rev-rest))))

(reverse (1 2 3) ?x)  ; infinite loop

;;; Query input:
(reverse ?x (1 2 3))

;;; Query output:
(reverse (3 2 1) (1 2 3))
