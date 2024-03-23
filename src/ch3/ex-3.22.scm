(load "./src/ch3/queue/closure-queue.scm")

(define q (make-queue)) 

; (q 'empty?)      ; #t 
; ((q 'insert!) 'a)   ; ((a) a) 
; (q 'front)           ; a 

; (q 'empty?)      ; #f      
; ((q 'insert!) 'b)   ; ((a b) b) 
; (q 'front)           ; a 

; (q 'delete!)      ; ((b) b) 

; (q 'delete!)      ; (()) 

; (q 'print)
