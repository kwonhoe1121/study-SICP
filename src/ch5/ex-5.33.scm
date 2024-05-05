; In (* (factorial (- n 1) n)), compiler need (save argl), then (restore argl). 
(define (factorial n)
    (if (= n 1)
        1
        (* (factorial (- n 1)) n)))

; In (* n (factorial (- n 1))), compiler need (save env), then (restore env). 
(define (factorial-alt n)
  (if (= n 1)
      1
      (* n (factorial-alt (- n 1)))))

; ∴ so there is no efficiency between the two program.
