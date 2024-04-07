; Y Combinator를 써서 '순수한 람다 계산법'만으로 재귀를 나타내는 방법

(define Y
  (lambda (f)
          ((lambda (x) (x x))
           (lambda (x) (f (lambda (y) ((x x) y)))))))


(define fact-once
  (lambda (f)
          (lambda (n)
                  (if (= n 0)
                      1
                      (* n (f (- n 1)))))))

(define factorial (Y fact-once))


; (a)

(define (fact n)
  (if (= n 1)
    1
    (* n (fact (- n 1)))))

((lambda (n)
         ((lambda (fact) (fact fact n))
          (lambda (ft k)
                  (if (= k 1)
                      1
                      (* k (ft ft (- k 1)))))))
 10)

; 1.
; ((lambda (fact) (fact fact 10))
;  (lambda (ft k)
;          (if (= k 1)
;              1
;              (* k (ft ft (- k 1))))))
; 2.
; ((lambda (ft k)
;         (if (= k 1)
;             1
;             (* k (ft ft (- k 1)))))
;  (lambda (ft k)
;        (if (= k 1)
;            1
;            (* k (ft ft (- k 1))))) 10)
; 3.
; (if (= 10 1)
;     1
;     (* 10 ((lambda (ft k)
;                    (if (= k 1)
;                        1
;                        (* k (ft ft (- k 1)))))
;            (lambda (ft k)
;                    (if (= k 1)
;                        1
;                        (* k (ft ft (- k 1)))))
;            (- 10 1))))
; 4.
; (* 10 ((lambda (ft k)
;                (if (= k 1)
;                    1
;                    (* k (ft ft (- k 1)))))
;        (lambda (ft k)
;                (if (= k 1)
;                    1
;                    (* k (ft ft (- k 1)))))
;        (- 10 1)))

(define (fibo n)
  (if (< n 2)
    n
    (+ (fibo (- n 1))
       (fibo (- n 2)))))

((lambda (n)
         ((lambda (fibo) (fibo fibo n))
          (lambda (ft k)
                  (if (< k 2)
                      k
                      (+ (ft ft (- k 1))
                         (ft ft (- k 2)))))))
 10)

; (b)

(define (f x)
  (define (even? n)
    (if (= n 0)
        true
        (odd? (- n 1))))
  (define (odd? n)
    (if (= n 0)
        false
        (even? (- n 1))))
  (even? x))

(define (f x)
  ((lambda (even? odd?)
     (even? even? odd? x))
   (lambda (ev? od? n)
     (if (= n 0) 
         true 
         (od? ev? od? (- n 1))))
   (lambda (ev? od? n)
     (if (= n 0) 
         false 
         (ev? ev? od? (- n 1))))))
