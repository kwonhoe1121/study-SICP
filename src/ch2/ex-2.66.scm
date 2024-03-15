(load "./src/ch2/binary-tree-sets.scm")

(define (lookup given-key set-of-records)
  (cond ((null? set-of-records) false)
        ((equal? given-key 
                 (key (car set-of-records)))
         (car set-of-records))
        (else 
         (lookup given-key 
                 (cdr set-of-records)))))

(define (lookup given-key set-of-records)
  (if (null? set-of-records)
    false
    (let ((computed-key (key (entry set-of-records))))
      (cond ((equal? given-key computed-key) (entry set-of-records))
            ((< given-key computed-key) (lookup
                                          given-key
                                          (left-tree set-of-records)))
            ((> given-key computed-key) (lookup
                                          given-key
                                          (right-tree set-of-records)))))))
