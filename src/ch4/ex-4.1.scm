; (define (list-of-values exps env)
;   (if (no-operands? exps)
;       '()
;       (fold-left
;         cons
;         (list (eval (first-operand exps) env)
;               (list-of-values (rest-operands exps) env)))))

; (define (list-of-values exps env)
;   (if (no-operands? exps)
;       '()
;       (fold-right
;         cons
;         (list (eval (first-operand exps) env)
;               (list-of-values (rest-operands exps) env)))))

; [참고답안]

;; left to right
(define (list-of-values1 exps env)
  (if (no-operand? exps)
      '()
      (let* ((left (eval (first-operand exps) env))
             (right (eval (rest-operands exps) env)))
            (cons left right))))

;; right to left
(define (list-of-values2 exps env)
  (if (no-operand? exps)
      '()
      (let* ((right (eval (rest-operands exps) env))
             (left (eval (first-operand exps) env)))
            (cons left right))))
