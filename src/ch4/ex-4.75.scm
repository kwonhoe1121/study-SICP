; unique 라는 특별한 형태를 구현하는데는 2가지 부분이 있다.
; not 특별한 형태를 구현하는 방식과 비슷하다.

; 1. 특별한 형태를 다루는 프로시저를 짜는 일

(define (unique-query operands)
  (car operands))

(define (singleton-stream? s)
  (and (not (stream-null? s))
       (stream-null? (stream-cdr s))))

(define (uniquely-asserted query frame-stream)
  (stream-flatmap
    (lambda (frame)
            (let ((result (qeval (unique-query query) (singleton-stream frame))))
                 (if (singleton-stream? result) ; 정확히 원소 하나만 들지 않은 스트림을 걸러낸다.
                     result
                     the-empty-stream)))
    frame-stream))

; 2. qeval에서 프로시저를 불러 쓰도록 만드는 일. (data-directed)

(put 'unique 'qeval uniquely-asserted)
