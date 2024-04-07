(define (unless condition 
                usual-value 
                exceptional-value)
  (if condition 
      exceptional-value 
      usual-value))

(define (factorial n)
  (unless (= n 1)
          (* n (factorial (- n 1)))
          1))

; [정상 순서 평가기]
; (factorial 5)

; (unless (= 5 1)
;         (* 5 (factorial (- 5 1)))
;         1)

; (if (= 5 1)
;    (* 5 (factorial (- 5 1))) 
;    1)

; (* 5 ((unless (= 4 1)
;           (* 4 (factorial (- 4 1)))
;           1)))

; (* 5 ((if (= 4 1)
;           (* 4 (factorial (- 4 1)))
;           1)))

; (* 5 (* 4 (factorial (- 4 1))))

; ...

; [인수 우선 평가기] -> 인수에서 factorial 을 무한히 호출한다.

; (factorial 5)

; (unless (= 5 1)
;         (* 5 (factorial (- 5 1)))
;         1)

; (unless (= 5 1)
;         (* 5 (unless (= 4 1)
;                      (* 5 (factorial (- 4 1)))
;                      1)
;            )
;         1)

; (unless (= 5 1)
;         (* 5 (* 4 (factorial (- 4 1))))
;         1)

; ...

; (unless (= 5 1)
;         (* 5 (* 4 (* 3 (* 2 (* 1 (* 0 (* -1 (factorial (- -1 -1)))
;         1)
