(load "./src/lib/util.scm")

(define fold-right accumulate)

(define (fold-left op initial sequence)
  (define (iter result rest)
    (if (null? rest)
        result
        (iter (op result (car rest))
              (cdr rest))))
  (iter initial sequence))

(display (fold-right / 1 (list 1 2 3)))
; (/ 1 (/ 2 (/ 3 1)))

(display (fold-left  / 1 (list 1 2 3)))
; (/ (/ (/ 1 1) 2) 3)

(display (fold-right list nil (list 1 2 3)))

; (list 1 (list 2 (list 3 nil)))

(display (fold-left  list nil (list 1 2 3)))

; (list (list (list nil) 2) 3)

; ∴ op 연산하자가 결합적인 속성을 만족하면 fold-left, fold-right 결과값은 동일하다.
