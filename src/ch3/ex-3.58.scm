(load "./src/ch3/stream/stream.scm")

(define (expand num den radix)
  (cons-stream
   (quotient (* num radix) den)
   (expand (remainder (* num radix) den) 
           den 
           radix)))

; (1 4 2 8 5 7 1 4 ...)
(expand 1 7 10)

; (3 7 5 0 0 0 ...)
(expand 3 8 10)
