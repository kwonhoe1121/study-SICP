(load "./src/ch3/stream/stream.scm")

(define ramanujan-numbers
  (define (sum-i3-j3-stream s t)
    (define (weight pair)
      (let ((i (car pair))
            (j (cadr pair)))
           (+ (* i i i)
              (* j j j))))
    (weighted-pairs weight s t))
  (define s (sum-i3-j3-stream integers integers))
  (define (ramanujan s)
    (let ((cur (stream-ref s 0))
          (next (stream-ref s 1)))
      (if (= cur next)
        (cons-stream
          cur
          (ramanujan-numbers (stream-cdr (stream-cdr s))))
        (ramanujan-numbers (stream-cdr s)))))
  (ramanujan s))

; [참고답안]

(define (Ramanujan s)
  (define (stream-cadr s) (stream-car (stream-cdr s)))
  (define (stream-cddr s) (stream-cdr (stream-cdr s)))
  (let ((scar (stream-car s))
        (scadr (stream-cadr s)))
       (if (= (sum-triple scar) (sum-triple scadr))
           (cons-stream (list (sum-triple scar) scar scadr)
                        (Ramanujan (stream-cddr s)))
           (Ramanujan (stream-cdr s)))))
(define (triple x) (* x x x))
(define (sum-triple x) (+ (triple (car x)) (triple (cadr x))))
(define Ramanujan-numbers
  (Ramanujan (weighted-pairs integers integers sum-triple)))
  
; 1729
; the next five numbers are: 
; (4104 (2 16) (9 15)) 
; (13832 (2 24) (18 20)) 
; (20683 (10 27) (19 24)) 
; (32832 (4 32) (18 30)) 
; (39312 (2 34) (15 33))
