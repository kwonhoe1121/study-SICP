; node := <data, prev-node*, next-node*>

(define (make-deque)
  (let ((front-node '())
        (rear-node '()))
    (define (set-front-node! node) (set! front-node node))
    (define (set-rear-node! node) (set! rear-node node))
    (define (make-node data prev next) (list data prev next))
    (define (data-node node) (car node))
    (define (prev-node node) (cadr node))
    (define (next-node node) (caddr node))
    (define (set-prev-node! node prev)
      (set-car! (cdr node) prev))
    (define (set-next-node! node next)
      (set-car! (cddr node) next))
    (define (single-node?) (eq? front-node rear-node))
    (define (empty-deque?) (null? front-node))
    (define (front-deque)
      (if (empty-deque?)
        (error "FRONT called with an empty deque")
        (data-node front-node)))
    (define (rear-deque)
      (if (empty-deque?)
        (error "FRONT called with an empty deque")
        (data-node rear-node)))
    (define (front-insert-deque! data)
      (let ((new-node (make-node data '() '())))
        (cond ((empty-deque?)
               (set-front-node! new-node)
               (set-rear-node! new-node)
               'front-insert!)
              (else (set-prev-node! front-node new-node)
                    (set-next-node! new-node front-node)
                    (set-front-node! new-node)
                    'front-insert!))))
    (define (rear-insert-deque! data)
      (let ((new-node (make-node data '() '())))
        (cond ((empty-deque?)
               (set-front-node! new-node)
               (set-rear-node! new-node)
               'rear-insert!)
              (else (set-next-node! rear-node new-node)
                    (set-prev-node! new-node rear-node)
                    (set-rear-node! new-node)
                    'rear-insert!))))
    (define (front-delete-deque!)
      (cond ((empty-deque?)
             (error "DELETE! called with an empty deque"))
            ((single-node?) (set-front-node! '())
                            (set-rear-node! '())
                            'empty-deque)
            (else (set-front-node! (next-node front-node))
                  (set-prev-node! front-node '())
                  'front-delete!)))
    (define (rear-delete-deque!)
      (cond ((empty-deque?)
             (error "DELETE! called with an empty deque"))
            ((single-node?) (set-front-node! '())
                            (set-rear-node! '())
                            'empty-deque)
            (else (set-rear-node! (prev-node rear-node))
                  (set-next-node! rear-node '())
              'rear-delete!)))
    (define (print-deque) 
      (define (iter node result)
        (if (null? node)
          (display result)
          (iter (next-node node) (append result (list (data-node node))))))
      (iter front-node '()))
    (define (dispatch m)
      (cond ((eq? m 'front) (front-deque))
            ((eq? m 'rear) (rear-deque))
            ((eq? m 'front-insert!) front-insert-deque!)
            ((eq? m 'rear-insert!) rear-insert-deque!)
            ((eq? m 'front-delete!) (front-delete-deque!))
            ((eq? m 'rear-delete!) (rear-delete-deque!))
            ((eq? m 'empty?) (empty-deque?))
            ((eq? m 'print) (print-deque))
            (else (error "Unknown request: MAKE-DEQUE"))))
    dispatch))
