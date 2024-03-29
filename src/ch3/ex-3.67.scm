; 모든 정수 쌍 (i, j)을 산출하는 스트림

(define (pairs s t)
  (cons-stream
   (list (stream-car s) (stream-car t))
   (interleave
    (stream-map (lambda (x) 
                  (list (stream-car s) x))
                (stream-cdr t))
    (pairs (stream-cdr s) t)))) ; order를 S에 대해서만 줄이는 것으로 바꾼다.

; [참고답안]
; 1, 2, 3 구역 이외의 4번째 구역 스트림도 추가하여 전체 쌍을 구성한다.

(define (pairs s t)
  (cons-stream
   (list (stream-car s) (stream-car t)) ; 1.
   (interleave
    (interleave
      (stream-map (lambda (x)
                          (list (stream-car s) x)) ; 2.
                  (stream-cdr t))
      (pairs (stream-cdr s) (stream-cdr t))) ; 3.
    (stream-map (lambda (x) (list x (stream-car t))) ; 4.
                (stream-cdr s)))))
