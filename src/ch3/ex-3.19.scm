(load "./src/ch3/ex-3.13.scm")

; 상수 크기의 공간만 사용하는 알고리즘 - fast than ex-3.18
; 현재와 다음을 비교하면서 순환 포인터 확인

(define (cycle? x)
  (define (iter fast slow)
    (cond ((or (null? fast)
               (null? (cdr fast))) #f)
          ((eq? fast slow) #t)
          (else (iter (cddr fast)
                      (cdr slow)))))
  (iter (cdr x) x))
