(load "./src/lib/util.scm")

(define (accumulate-n op init seqs)
  (if (null? (car seqs))
      nil
      (cons (accumulate op init (map car seqs))
            (accumulate-n op init (map cdr seqs)))))

(define test (list
                 (list 1 2 3)
                 (list 4 5 6)
                 (list 7 8 9)
                 (list 10 11 12)))

; (display (accumulate-n
;            +
;            0
;            test))
; (22 26 30)

; (display (map car test)) ; (1 4 7 10)
; (display (map cdr test)) ; ((2 3) (5 6) (8 9) (11 12))
