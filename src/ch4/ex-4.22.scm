; ex-4.6 참고

((let? exp) (analyze-let exp))

(define (analyze-let exp) (analyze (let->combination exp)))
