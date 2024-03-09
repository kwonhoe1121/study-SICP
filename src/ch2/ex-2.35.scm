(load "./src/lib/util.scm")

; (define (count-leaves t)
;   (accumulate
;     (lambda (leaves total) (+ leaves total))
;     0
;     (map
;       (lambda (x)
;         (cond ((null? x) x)
;               ((pair? x) (count-leaves x))
;               (else 1)))
;       t)))

(define (count-leaves t)
  (accumulate
    (lambda (leaves total) (+ leaves total))
    0
    (map
      (lambda (x)
        (if (pair? x)
            (count-leaves x)
            1))
      t)))

; (count-leaves (list (list 1 2 3 4) (list 1 2 3 4)))
