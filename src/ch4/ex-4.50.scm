; [참고답안] - ramb

;; In (analyze expr) adds
((ramb? expr) (analyze-ramb expr))

;; add these code to amb evaluator
(define (analyze-ramb expr)
  (analyze-amb (cons 'amb (ramb-choices expr))))

;; amb expression
(define (amb? expr) (tagged-list? expr 'amb))
(define (amb-choices expr) (cdr expr))

(define (ramb? expr) (tagged-list? expr 'ramb))
(define (ramb-choices expr) (shuffle-list (cdr expr)))


;; random-in-place, from CLRS 5.3
(define (shuffle-list lst)
  (define (random-shuffle result rest)
    (if (null? rest)
        result
        (let* ((pos (random (length rest)))
               (item (list-ref rest pos)))
              (if (= pos 0)
                  (random-shuffle (append result (list item)) (cdr rest))
                  (let ((first-item (car rest)))
                       (random-shuffle (append result (list item))
                                       (insert! first-item (- pos 1) (cdr (delete! pos rest)))))))))
  (random-shuffle '() lst))

;; insert item to lst in position k.
(define (insert! item k lst)
  (if (or (= k 0) (null? lst))
      (append (list item) lst)
      (cons (car lst) (insert! item (- k 1) (cdr lst)))))
(define (delete! k lst)
  (cond ((null? lst) '())
        ((= k 0) (cdr lst))
        (else (cons (car lst)
                    (delete! (- k 1) (cdr lst))))))
