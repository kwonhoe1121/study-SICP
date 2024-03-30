(load "./src/ch3/stream/stream-signal.scm")

; 평탄화 작업 모듈화 적용

(define (smooth s)
  (stream-map average
              s
              (stream-cdr s)))

(define (make-zero-crossings input-stream)
  (cons-stream
    (sign-change-detector (smooth input-stream)
                          (smooth (stream-cdr input-stream)))
    (make-zero-crossings (stream-cdr input-stream))))

; [참고답안]

(define (smooth s)
  (stream-map (lambda (x1 x2) (/ (+ x1 x2) 2))
              (cons-stream 0 s)
              s))

(define (make-zeor-crosssings input-stream smooth)
  (let ((after-smooth (smooth input-stream)))
       (stream-map sign-change-detector after-smooth (cons-stream 0 after-smooth))))
