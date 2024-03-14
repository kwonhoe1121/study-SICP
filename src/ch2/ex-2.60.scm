(load "./src/ch2/unordered-list-sets.scm")

; 중복 허용 집합 계산 차수: O(n) - 비교 연산(element-of-set?) 사용 안해도 되기 때문.
; 중복을 허용하므로, 집합 크기는 증가
; 중복요소가 드물게 발생하는 프로그램에서 사용하면 속도 향상을 가져올 수 있다. O(n^2) -> O(n)

(define (adjoin-set x set) (cons x set))
(define (union-set set1 set2) (append set1 set2))
