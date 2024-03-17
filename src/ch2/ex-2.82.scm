; 모든 인자를 첫 번째 인자 타입으로 바꾸려 해보고,
; 이어서 두 번째 인자 타입으로 바꾸려 해보고,
; 계속 차례대로 타입 바꾸기 시도를 이어가는 방식을 따를 수 있다.

(define (find-type types)
  (define (iter target-types)
    (cond ((null? target-types) nil)
          ((fold-right
             (lambda (a b) (and b
                                (get-coercion
                                  (car target-types)
                                  a)))
             true
             types) (car target-types))
          (else (iter (cdr target-types)))))
  (iter types))

(define (type-coercion target-type args)
  (map (lambda (a)
         (let ((type (type-tag a))
               (content (contents a))
               (coercion (get-coercion
                           type
                           target-type)))
           (coercion content)))))

(define (apply-generic op . args)
  (let ((type-tags (map type-tag args)))
    (let ((proc (get op type-tags)))
      (if proc
          (apply proc (map contents args))
          (let ((target-type (find-type type-tags)))
            (if (target-type)
              (apply proc (type-coercion target-type
                                         args))
              (error 
               "No method for these types"
               (list op type-tags))))))))
