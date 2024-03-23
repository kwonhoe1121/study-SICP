(define (make-queue)
  (let ((front-ptr '())
        (rear-ptr '()))
    (define (set-front-ptr! item) (set! front-ptr item))
    (define (set-rear-ptr! item) (set! rear-ptr item))
    (define queue (cons front-ptr rear-ptr))
    (define (empty-queue?) (null? front-ptr))
    (define (front-queue)
      (if (empty-queue?)
          (error "FRONT called with an empty queue")
          (car front-ptr)))
    (define (insert-queue! item)
      (let ((new-pair (cons item '())))
        (cond ((empty-queue?)
               (set-front-ptr! new-pair)
               (set-rear-ptr! new-pair)
               queue)
              (else (set-cdr! rear-ptr new-pair)
                    (set-rear-ptr! new-pair)
                    queue))))
    (define (delete-queue!)
      (cond ((empty-queue?)
             (error "DELETE! called with an empty queue"))
            (else (set-front-ptr! (cdr front-ptr))
                  queue)))
    (define (print-queue)
      (display front-ptr))
    (define (dispatch m)
      (cond ((eq? m 'front) (front-queue))
            ((eq? m 'insert!) insert-queue!)
            ((eq? m 'delete!) (delete-queue!))
            ((eq? m 'empty?) (empty-queue?))
            ((eq? m 'print) (print-queue))
            (else (error "Unknown request: MAKE-QUEUE"))))
    dispatch))
