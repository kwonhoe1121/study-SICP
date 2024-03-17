; complex := rectangular | polar
; polynomial := dense | sparse

; [참고 답안]

(define (install-sparse-term-list)
    (define (adjoin-term term term-list)
        (if (=zero? (coeff term))
            term-list
            (cons (term term-list))))

    (define (first-term term-list) (car term-list))
    (define (rest-terms term-list) (cdr term-list))

    (define (tag term-list) (attach-tag 'sparse term-list))

    (put 'adjoin-term 'sparse adjoin-term)
    (put 'first-term '(sparse)
        (lambda (term-list) (first-term term-list)))
    (put 'rest-term '(sparse)
        (lambda (term-list) (tag (rest-terms term-list))))
    'done)

(define (install-dense-term-list)
    (define (adjoin-term term term-list)
    (cond ((=zero? (coeff term)) term-list)
            ((=equ? (order term) (length term-list)) (cons (coeff term) term-list))
            (else (adjoin-term term (cons 0 term-list)))))

    (define (first-term term-list) (make-term (- (length term-list) 1) (car term-list)))
    (define (rest-terms term-list) (cdr term-list))

    (define (tag term-list) (attach-tag 'dense term-list))
    (put 'adjoin-term 'dense adjoin-term)
    (put 'first-term '(dense)
        (lambda (term-list) (first-term term-list)))
    (put 'rest-term '(dense)
        (lambda (term-list) (tag (rest-terms term-list))))
    'done)

(define (adjoin-term term term-list)
    ((get 'adjoin-term (type-tag term-list)) term term-list))

(define (first-term term-list) (apply-generic 'first-term term-list))
(define (rest-term term-list) (apply-generic 'rest-term term-list))
