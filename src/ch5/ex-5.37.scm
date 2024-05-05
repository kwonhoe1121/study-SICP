; 레지스터/스택 최적화를 적용하지 않는 경우

;; remove the condition, when (preserving regs, seq1 seq2), always (save first-reg),
;; then (restore first-reg)
(define (preserving regs seq1 seq2)
  (if (null? regs)
      (append-instruction-sequences seq1 seq2)
      (let ((first-reg (car regs)))
           (preserving (cdr regs)
                       (make-instruction-sequence
                         (list-union (list first-reg) (registers-needed seq1))
                         (list-difference
                           (registers-modified seq1)
                           (list first-reg))
                         (append
                           `((save ,first-reg))
                           (statements seq1)
                           `((restore ,first-reg))))
                       seq2))))
