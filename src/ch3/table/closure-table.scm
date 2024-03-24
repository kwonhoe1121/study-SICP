(define (make-table same-key?)
  (let ((local-table (list '*table*)))
    (define (assoc key records)
      (cond ((null? records) false)
            ((same-key? key (caar records)) 
             (car records))
            (else (assoc key (cdr records)))))

    (define (find-table key tables) (assoc key tables))

    (define (last-key? keys) (= (length keys) 1))

    ; (define (lookup key-1 key-2)
    ;   (let ((subtable 
    ;          (assoc key-1 (cdr local-table))))
    ;     (if subtable
    ;         (let ((record 
    ;                (assoc key-2 
    ;                       (cdr subtable))))
    ;           (if record (cdr record) false))
    ;         false)))

    ; (define (insert! key-1 key-2 value)
    ;   (let ((subtable 
    ;          (assoc key-1 (cdr local-table))))
    ;     (if subtable
    ;         (let ((record 
    ;                (assoc key-2 
    ;                       (cdr subtable))))
    ;           (if record
    ;               (set-cdr! record value)
    ;               (set-cdr! 
    ;                subtable
    ;                (cons (cons key-2 value)
    ;                      (cdr subtable)))))
    ;         (set-cdr! 
    ;          local-table
    ;          (cons (list key-1
    ;                      (cons key-2 value))
    ;                (cdr local-table)))))
    ;   'ok)

    (define (lookup keys)
      (define (iter rest-keys rest-tables)
        (if (or (null? rest-keys)
                (null? rest-tables))
          #f
          (let ((found-table (find-table (car rest-keys)
                                         (cdr rest-tables))))
            (if (and found-table
                     (last-key? rest-keys))
              (cdr found-table)
              (iter (cdr rest-keys) (cdr rest-tables))))))
      (iter keys local-table))

    (define (insert! keys value)
      (define (iter rest-keys rest-tables)
        (if (null? rest-keys)
          'ok
          (let ((found-table (find-table (car rest-keys)
                                       (cdr rest-tables))))
            (if (last-key? rest-keys)
              (if found-table
                (set-cdr! found-table value)
                (set-cdr!
                  rest-tables
                  (cons (cons (car rest-keys) value)
                        (cdr rest-tables))))
              (if found-table
                (iter (cdr rest-keys) (cdr rest-tables))
                (begin
                  (set-cdr!
                    rest-tables
                    (list (car rest-keys)))
                  (iter (cdr rest-keys)
                       (cdr rest-tables))))))))
      (iter keys local-table))

    (define (print-table) (display local-table))

    (define (dispatch m)
      (cond ((eq? m 'lookup-proc) lookup)
            ((eq? m 'insert-proc!) insert!)
            ((eq? m 'print-table) print-table)
            (else (error "Unknown operation: 
                          TABLE" m))))
    dispatch))
