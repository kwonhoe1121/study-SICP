(define (install-rational-package)
  ;; internal procedures
  (define (numer x) (car x))
  (define (denom x) (cdr x))
  ; (define (make-rat n d)
  ;   (let ((g (gcd n d)))
  ;     (cons (/ n g) (/ d g))))
   (define (make-rat n d)
     (let ((r (reduce n d))) ; 일반화된 연산 reduce 사용 - 정수, 다항식 모두 사용 가능
       (cons (car r) (cadr r))))
  (define (add-rat x y)
    (make-rat (add (mul (numer x) (denom y))
                 (mul (numer y) (denom x)))
              (mul (denom x) (denom y))))
  (define (sub-rat x y)
    (make-rat (sub (mul (numer x) (denom y))
                 (mul (numer y) (denom x)))
              (mul (denom x) (denom y))))
  (define (mul-rat x y)
    (make-rat (mul (numer x) (numer y))
              (mul (denom x) (denom y))))
  (define (div-rat x y)
    (make-rat (mul (numer x) (denom y))
              (mul (denom x) (numer y))))
  (define (equ? x y)
    (and (= (number x) (numer y))
         (= (denom x) (denom y))))
  (define (=zero? x) (= (numer x) 0))
  ;; interface to rest of the system
  (define (tag x) (attach-tag 'rational x))
  (put 'add '(rational rational)
       (lambda (x y) (tag (add-rat x y))))
  (put 'sub '(rational rational)
       (lambda (x y) (tag (sub-rat x y))))
  (put 'mul '(rational rational)
       (lambda (x y) (tag (mul-rat x y))))
  (put 'div '(rational rational)
       (lambda (x y) (tag (div-rat x y))))
  (put 'equ '(rational rational)
       (lambda (x y) (tag (equ? x y))))
  (put 'negate 'rational
       (lambda (rat) (make-rational (- (numer rat)) (denom rat))))
  (put '=zero? '(rational) (lambda (x) (tag (=zero? x))))
  (put 'make 'rational
       (lambda (n d) (tag (make-rat n d))))
  'done)

; (define (make-rational n d)
;   ((get 'make 'rational) n d))
