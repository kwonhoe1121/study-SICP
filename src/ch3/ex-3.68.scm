; (define (pairs s t)
;   (cons-stream
;    (list (stream-car s) (stream-car t))
;    (interleave ; delay!
;     (stream-map (lambda (x) 
;                   (list (stream-car s) x))
;                 (stream-cdr t))
;     (pairs (stream-cdr s) (stream-cdr t)))))

(define (pairs s t)
  (interleave
   (stream-map (lambda (x) (list (stream-car s) x))
               t)
   (pairs (stream-cdr s) (stream-cdr t))))

; [참고답안]
; no. The program will infinitely loop. because their is no delay in (pairs (stream-cdr s) (stream-cdr t)), it will be called recursively.
