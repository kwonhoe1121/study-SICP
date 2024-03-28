(define (make-serializer)
  (let ((mutex (make-mutex)))
    (lambda (p)
      (define (serialized-p . args)
        (mutex 'acquire)
        (let ((val (apply p args)))
          (mutex 'release)
          val))
      serialized-p)))

; 뮤텍스는 세마포어 방식을 단순하게 바꾼 것이다.
(define (make-mutex)
  (let ((cell (list false)))
    (define (the-mutex m)
      (cond ((eq? m 'acquire)
             (if (test-and-set! cell)
                 (the-mutex 'acquire))) ; retry
            ((eq? m 'release) (clear! cell))))
    the-mutex))

(define (clear! cell) (set-car! cell false))

; (define (test-and-set! cell)
;   (if (car cell)
;       true
;       (begin (set-car! cell true)
;              false)))

; time-slicing -> interupts -> change process
; atomically
(define (test-and-set! cell)
  (without-interrupts ; 시분할 인터럽트를 걸지 못하도록 한다.
   (lambda ()
     (if (car cell)
         true
         (begin (set-car! cell true)
                false)))))
