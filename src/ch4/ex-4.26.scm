((unless? exp)
 (eval (unless->if exp) env))

(define (unless->if exp)
  (make-if (if-predicate exp)
           (if-alternative exp)
           (if-consequent exp)))

; [참고답안]

(define (unless? expr) (tagged-list? expr 'unless))
(define (unless-predicate expr) (cadr expr))
(define (unless-consequnce expr)
  (if (not (null? (cdddr expr)))
      (cadddr expr)
      'false))
(define (unless-alternative expr) (caddr expr))

(define (unless->if expr)
  (make-if (unless-predicate expr)
           (unless-consequence expr)
           (unless-alternative expr))
