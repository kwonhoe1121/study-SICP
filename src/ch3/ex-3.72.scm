(load "./src/ch3/stream/stream.scm")

; [참고답안]

(define (sum-of-squares p)
  (+ (square (car p)) (square (cadr p))))

(define ordered-pairs
  (weighted-pairs sum-of-squares integers integers))

(define (equiv-sum-squares-stream s)
  (let ((next-1 (stream-cdr s))
        (next-2 (stream-cdr (stream-cdr s))))
       (let ((p1 (stream-car s))
             (p2 (stream-car next-1))
             (p3 (stream-car next-2)))
            (let ((x1 (sum-of-squares p1))
                  (x2 (sum-of-squares p2))
                  (x3 (sum-of-squares p3)))
                 (if (= x1 x2 x3)
                     (cons-stream
                       (list x1 p1 p2 p3)
                       (equiv-sum-squares-stream (stream-cdr next-2)))
                     (equiv-sum-squares-stream next-1))))))

; (stream->list (equiv-sum-squares-stream ordered-pairs) 5)
