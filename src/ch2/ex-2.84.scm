; 먼저 탑 구조에서 두 타입 가운데 어느 쪽이 위에 있는지 알아보는 방법부터 마련해야 한다.

(define (raise-up type1 type2)
  (define tower '(integer rational real complex))
  (define (iter t1 t2 t)
    (let ((tag1 (type-tag t1))
          (tag2 (type-tag t2))
          (tag (type-tag (car t)))
          (content1 (contents t1))
          (content2 (contents t2)))
      (cond ((null? t) nil)
            ((and (= tag tag1)
                  (= tag tag2)) (cons t1 t2))
            ((equal? tag tag1) (iter (raise t1 tower) t2 (cdr t)))
            ((equal? tag tag2) (iter t1 (raise t2 tower) (cdr t)))
            (else (error "Type-system error!" tower)))))
  (iter type1 type2 tower))

; (define (apply-generic op . args)
;   (define (raise-into s t)
;         (let ((s-type (type-tag s))
;               (t-type (type-tag t)))
;           (cond ((equal? s-type t-type) s)
;                 ((get 'raise (list s-type))
;                  (raise-into ((get 'raise (list s-type)) (contents s)) t))
;                 (else #f))))
;   (let ((type-tags (map type-tag args)))
;         (let ((proc (get op type-tags)))
;           (if proc
;             (apply proc (map contents args))
;             (if (= (length args) 2)
;               (let ((a1 (car args))
;                    (a2 (cadr args)))
;                 (cond
;                   ((raise-into a1 a2)
;                    (apply-generic op (raise-into a1 a2) a2))
;                   ((raise-into a2 a1)
;                    (apply-generic op a1 (raise-into a2 a1)))
;                   (else (error "No method for these types"
;                         (list op type-tags)))))
;            (error "No method for these types"
;                   (list op type-tags)))))))