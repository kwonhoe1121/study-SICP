; 종료 조건에 counting 여부 조건 추가

(define (count-pairs x)
  (let ((counted-pairs '()))
    (define (counted-pair? pairs x)
      (cond ((null? pairs) #f)
            ((eq? (car pairs) x) #t)
            (else (counted-pair? (cdr pairs) x))))
    (define (count x)
      (if (or (not (pair? x))
              (counted-pair? counted-pairs x))
        0
        (begin
          (set! counted-pairs (cons x counted-pairs))
          (+ (count (car x))
             (count (cdr x))
             1))))
    (count x)))

; [참고 답안]

(define (count-pairs x)
  (define (collect-pairs x seen)
    (if (or (not (pair? x)) (memq x seen))
        seen
        (let ((seen-car (collect-pairs (car x) (cons x seen))))
          (collect-pairs (cdr x) seen-car))))
  (length (collect-pairs x '())))

(display (count-pairs (list 'a 'b 'c))) ;; => 3

(define second (cons 'a 'b))
(define third (cons 'a 'b))
(define first (cons second third))
(set-car! third second)
(count-pairs first)  ;; => 3

(define third (cons 'a 'b))
(define second (cons third third))
(define first (cons second second))
(count-pairs first)  ;; => 3

(define lst (list 'a 'b 'c))
(set-cdr! (cddr lst) lst)
(count-pairs lst)  ;; => 3
