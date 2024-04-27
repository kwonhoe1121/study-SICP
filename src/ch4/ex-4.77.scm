; not, lisp-value 처리 시, 정의되지 않은 변수가 들어 있는 일람표에 필터링 연산을 적용하는 경우 '잘못된' 답이 나올수 있음을 개선

; [참고답안]

; we can simply rearrange the order of clauses of compound queries by putting all filters at the end, which is an efficient and trivial method. In order to accomplish this, we will normalize the non-normalized compound queries during the parse phase of qeval.

(define compound-table '())
(define (put-compound combinator) (set! compound-table (cons combinator compound-table)))
(define (compound? query) (memq (type query) compound-table))

(define filter-table '())
(define (put-filter operator) (set! filter-table (cons operator filter-table)))
(define (filter? query) (memq (type query) filter-table))

(define (normalize clauses)
  (let ((filters (filter filter? clauses))
        (non-filters (filter (lambda (x) (not (filter? x))) clauses)))
       (append non-filters filters)))

(define (qeval query frame-stream)
  (let ((qproc (get (type query) 'qeval)))
       (cond ((compound? query) (qproc (normalize (contents query)) frame-stream))
             (qproc (qproc (contents query) frame-stream))
             (else (simple-query query frame-stream)))))

(put-compound 'and)
(put-filter 'not)
(put-filter 'lisp-value)
(put-filter 'unique)
