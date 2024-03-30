; 현재 평균 이전 평균을 비교해야 한다.

(define (make-zero-crossings input-stream last-value last-avpt)
  (let ((avpt (/ (+ (stream-car input-stream) last-value) 2)))
       (cons-stream (sign-change-detetor avpt last-avpt)
                    (make-zero-crossings (stream-cdr input-stream)
                                         (stream-car input-stream)
                                         avpt))))
