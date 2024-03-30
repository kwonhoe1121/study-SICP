(load "./src/ch3/stream/stream.scm")
(load "./src/ch3/stream/stream-module.scm")

; ex-3.6 구현 방식과 비교할 것

; [참고답안] - (1)

(define (random-update x)
  (remainder (+ (* 13 x) 5) 24))
(define random-init (random-update (expt 2 32)))

;; assume the operation 'generator and 'reset is a stream,
;; and if the command is 'generator, the element of
;; stream is a string, if the command is 'reset,
;; it is a pair whose first element is 'reset,
;; the other element is the reset value.
(define (random-number-generator command-stream)
  (define random-number
    (cons-stream random-init
                 (stream-map (lambda (number command)
                                     (cond ((null? command) the-empty-stream)
                                           ((eq? command 'generator)
                                            (random-update number))
                                           ((and (pair? command)
                                                 (eq? (car command) 'reset)) ; 이후의 스트림
                                            (cdr command))
                                           (else
                                             (error "bad command -- " commmand))))
                             random-number
                             command-stream)))
  random-number)

; [참고답안] - (2)

(define (random-numbers-generator requests)
  (define (random-numbers seed)
    (cons-stream seed
                 (random-numbers (rand-update seed))))

  (define (generate? request)
    (eq? request 'generate))

  (define (reset? request)
    (and (pair? request) (eq? (car request) 'reset)))

  (define (loop requests s)
    (cond ((stream-null? requests) the-empty-stream)
          ((generate? (stream-car requests))
           (cons-stream (stream-car s)
                        (loop (stream-cdr requests) (stream-cdr s))))
          ((reset? (stream-car requests))
           (let ((r (random-numbers (cadr (stream-car requests))))) ; 초기화 랜덤 수열 생성
                (cons-stream (stream-car r)
                             (loop (stream-cdr requests) (stream-cdr r)))))))

  (loop requests (random-numbers 705894)))

(define requests
  (fold-right
    cons-stream
    (list 'generate 'generate 'generate 'generate '(rest 705894) 'generate 'generate)))

(display-stream (random-numbers-generator requests))
