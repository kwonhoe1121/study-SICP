; S_1, S_1 + S_2, S_1 + S_2 + S_3, ...
; 1, (1)+2, (1+2)+3, (1+2+3)+4, ...
; := (partial-sums s)+ s

(define (partial-sums s)
  (cons-stream
    (stream-car s)
    (add-streams (partial-sums s)
                 (stream-cdr s))))
