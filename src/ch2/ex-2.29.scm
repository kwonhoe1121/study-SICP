(load "./src/lib/util.scm")

(define (make-mobile left right)
  (list left right))

(define (make-branch length structure)
  (list length structure))

; (a)

(define (left-branch mobile) (car mobile))
(define (right-branch mobile) (cadr mobile))

(define (branch-length branch) (car branch))
(define (branch-structure branch) (cadr branch))

; (b)

(define (weight? n) (not (pair? n)))

(define (total-weight mobile)
  (if (weight? mobile)
    mobile
    (+ (total-weight (branch-structure (left-branch mobile)))
       (total-weight (branch-structure (right-branch mobile))))))

; (c)

(define (balanced? mobile)
  (or (weight? mobile)
      (and (balanced? (branch-structure (left-branch mobile)))
           (balanced? (branch-structure (right-branch mobile))) ; 양쪽 가지 끝까지 도달한 시점에
           (= (* (total-weight (branch-structure (left-branch mobile))) ; 왼쪽 막대 길이 * 추 무게 === 오른쪽 막대 길이 * 추 무게
                 (total-weight (branch-length (left-branch mobile))))
              (* (total-weight (branch-structure (right-branch mobile)))
                 (total-weight (branch-length (right-branch mobile))))))))

; (d)

; (define (make-mobile left right) (cons left right))
; (define (make-branch length structure) (cons length structure))
; (define (branch-length branch) (car branch))
; (define (branch-structure branch) (cdr branch)) ; 변경부분, cadr -> cdr 
