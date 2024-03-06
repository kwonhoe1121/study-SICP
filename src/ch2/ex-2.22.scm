
; cons 는 list 앞에 요소를 추가함으로 역순으로 정렬된다.

(define (square-list items)
  (define (iter things answer)
    (if (null? things)
        answer
        (iter (cdr things)
              (cons (square (car things)) ;
                    answer))))
  (iter items nil))

; list 구조가 중첩된다.
; (cons
;   (cons answer (square (car things)))
;   (square (car things)))
; (cons
;   ((cons answer (square (car things)))
;    (square (car things)))
;   (square (car things)))

(define (square-list items)
  (define (iter things answer)
    (if (null? things)
        answer
        (iter (cdr things)
              (cons answer ;
                    (square 
                     (car things))))))
  (iter items nil))
