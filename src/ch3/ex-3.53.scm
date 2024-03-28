(load "./src/ch3/stream/stream.scm")

(define s (cons-stream 1 (add-streams s s)))

; (1 2 4 8 16 ...)
