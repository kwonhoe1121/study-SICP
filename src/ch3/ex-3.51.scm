(load "./src/ch3/stream/stream.scm")

(define (show x)
  (display-line x)
  x)

(define x 
  (stream-map 
   show 
   (stream-enumerate-interval 0 10)))

; 0

(stream-ref x 5)
; 0
; 1
; 2
; 3
; 4
; 5

(stream-ref x 7) ; memo-proc
; 6
; 7
