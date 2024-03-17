; "일반화된 연산" + "데이터 중심 프로그래밍" =>  "recursive data abstraction"

; 합쳐진 데이터 타입에서,
; 타입이 다른 각 부분을 다루는 데 모자람이 없게끔,
; 시스템 속에 일반화된 연산을 알맞게 마련해 놓기만 하면 끝이다.

(define (install-polynomial-package)
  ;; internal procedures
  ;; representation of poly
  (define (make-poly variable term-list)
    (cons variable term-list))
  (define (variable p) (car p))
  (define (term-list p) (cdr p))

  ; ex-2.87
  (define (=zero? p)
    (if (empty-termlist? p)
      (the-empty-termlist)
      (if (=zero? (coeff (first-term p)))
        (=zero? (rest-terms p))
        #f)))

  (define (add-terms L1 L2)
    (cond ((empty-termlist? L1) L2)
          ((empty-termlist? L2) L1)
          (else
           (let ((t1 (first-term L1)) 
                 (t2 (first-term L2)))
             (cond ((> (order t1) (order t2))
                    (adjoin-term
                     t1 
                     (add-terms (rest-terms L1) 
                                L2)))
                   ((< (order t1) (order t2))
                    (adjoin-term
                     t2 
                     (add-terms 
                      L1 
                      (rest-terms L2))))
                   (else
                    (adjoin-term
                     (make-term 
                      (order t1)
                      (add (coeff t1)  ; 일반화된 연산  add 사용
                           (coeff t2)))
                     (add-terms 
                      (rest-terms L1)
                      (rest-terms L2)))))))))

  (define (mul-terms L1 L2)
    (if (empty-termlist? L1)
        (the-empty-termlist)
        (add-terms 
         (mul-term-by-all-terms 
          (first-term L1) L2)
         (mul-terms (rest-terms L1) L2))))

  (define (mul-term-by-all-terms t1 L)
    (if (empty-termlist? L)
        (the-empty-termlist)
        (let ((t2 (first-term L)))
          (adjoin-term
           (make-term 
            (+ (order t1) (order t2))
            (mul (coeff t1) (coeff t2))) ; 일반화된 연산  mul 사용
           (mul-term-by-all-terms 
            t1 
            (rest-terms L))))))
  
  (define (negate-terms termlist) 
    (if (empty-termlist? termlist) 
          the-empty-termlist 
          (let ((t (first-term termlist))) 
            (adjoin-term (make-term (order t) (negate (coeff t))) 
                         (negate-terms (rest-terms termlist)))))) 

  (define (div-terms L1 L2)
    (if (empty-termlist? L1)
      (list (the-empty-termlist) (the-empty-termlist))
      (let ((t1 (first-term L1))
            (t2 (first-term L2)))
        (if (> (order t2) (order t1))
          (list (the-empty-termlist) L1)
          (let ((new-c (div (coeff t1) (coeff t2)))
                (new-o (- (order t1) (order t2)))
                (new-t (make-term new-o new-c)))
                (let ((rest-of-result
                      (div-terms (add-poly L1 (negate (mul-poly (list new-t) L2)))
                                 L2)))
                  (list (adjoin-term new-t
                                     (car rest-of-result))
                        (cadr rest-of-result))))))))
 
  (define (adjoin-term term term-list)
    (if (=zero? (coeff term))
        term-list
        (cons term term-list)))
  (define (the-empty-termlist) '())
  (define (first-term term-list) (car term-list))
  (define (rest-terms term-list) (cdr term-list))
  (define (empty-termlist? term-list) 
    (null? term-list))
  (define (make-term order coeff) 
    (list order coeff))
  (define (order term) (car term))
  (define (coeff term) (cadr term))

  (define (add-poly p1 p2)
    (if (same-variable? (variable p1) 
                        (variable p2))
        (make-poly 
         (variable p1)
         (add-terms (term-list p1)
                    (term-list p2)))
        (error "Polys not in same var: 
                ADD-POLY"
               (list p1 p2))))
  
  (define (mul-poly p1 p2)
    (if (same-variable? (variable p1) 
                        (variable p2))
        (make-poly 
         (variable p1)
         (mul-terms (term-list p1)
                    (term-list p2)))
        (error "Polys not in same var: 
                MUL-POLY"
               (list p1 p2))))

  (define (sub-poly p1 p2)
    (add-poly p1 (negate p2))

  (define (div-poly p1 p2)
    (if (same-variable? (variable p1)
                        (variable p2))
      (make-poly
        (variable p1)
        (div-terms (term-list p1)
                    (term-list p2)))
      (error "Polys not in same var:
             DIV-POLY"
             (list p1 p2))))

  ;; interface to rest of the system
  (define (tag p) (attach-tag 'polynomial p))
  (put 'add '(polynomial polynomial) ; 일반화된 연산 add에 다항식 경우도 추가
       (lambda (p1 p2) 
         (tag (add-poly p1 p2))))
  (put 'mul '(polynomial polynomial) ; 일반화된 연산 mul에 다항식 경우도 추가
       (lambda (p1 p2) 
         (tag (mul-poly p1 p2))))
  (put 'sub '(polynomial polynomial)
       (lambda (p1 p2) 
         (tag (sub-poly p1 p2))))
  (put 'div '(polynomial polynomial)
       (lambda (p1 p2) 
         (tag (div-poly p1 p2))))
  (put 'negate 'polynomial 
           (lambda (p) (make-poly (variable p) 
                                           (negate-terms (term-list p))))) 
  (put '=zero? '(polynomial) =zero?)
  (put 'make 'polynomial
       (lambda (var terms) 
         (tag (make-poly var terms))))
  'done)

; (define (make-polynomial var terms)
;   ((get 'make 'polynomial) var terms))
