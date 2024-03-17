(define (raise type tower)
  (let ((tag (type-tag type))
        (content (contents type)))
    (cond ((null? tower) (error "No supertype for these tower" tower))
          ((equal? type (car tower)) ((get-coercion
                                        type
                                        (car tower)) content))
          (else (raise type (cdr tower))))))

; (define (raise x) (apply-generic 'raise x))

; ;; add into integer package
; (put 'raise '(integer)
;          (lambda (x) (make-rational x 1)))

; ;; add into rational package
; (put 'raise '(rational)
;          (lambda (x) (make-real (* 1.0 (/ (numer x) (denom x))))))

; ;; add into real package
; (put 'raise '(real)
;          (lambda (x) (make-complex-from-real-imag x 0)))
