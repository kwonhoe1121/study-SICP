; [답안 참고]

; 어떤 수에 project 연산을 적용한 다음,
; 그 결과를 다시 처음 꼴로 raise 연산을 적용하였을 때,
; 그 값이 처음 값과 같다면 그 수에는 drop 연산을 적용할 수 있다.

;; add into rational package
(put 'project 'rational
     (lambda (x) (make-scheme-number (round (/ (numer x) (denom x))))))

;; add into real package
(put 'project 'real
     (lambda (x)
       (let ((rat (rationalize
                    (inexact->exact x) 1/100)))
         (make-rational
           (numerator rat)
           (denominator rat)))))

;; add into complex package
(put 'project 'complex
     (lambda (x) (make-real (real-part x))))

(define (drop x)
  (let ((project-proc (get 'project (type-tag x))))
    (if project-proc
      (let ((project-number (project-proc (contents x))))
        (if (equ? project-number (raise project-number)) ; if raise = project then drop is possible
          (drop project-number)
          x))
      x)))

;; apply-generic
;; the only change is to apply drop to the (apply proc (map contents args))
(drop (apply proc (map contents args)))
