; 불변 -> 안전 공유

(define x (list 'a 'b))

(define z1 (cons x x))

(define z2 
  (cons (list 'a 'b) (list 'a 'b)))

(define (set-to-wow! x)
  (set-car! (car x) 'wow)
  x)

; (display (set-to-wow! z1)) ; ((wow b) wow b)

; (display (set-to-wow! z2)) ; ((wow b) a b)

; [참고답안]


; z1 -> ( . )
;        | |
;        v v
; x --> ( . ) -> ( . ) -> null
;        |        |
;        v        v
;       'wow     'b

; z2 -> ( . ) -> ( . ) -> ( . ) -> null
;        |        |        |
;        |        v        v
;        |       'a       'b
;        |                 ^
;        |                 |
;        `-----> ( . ) -> ( . ) -> null
;                 |
;                 v
;                'wow
