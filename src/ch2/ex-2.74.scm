(load "./src/lib/util.scm")

; op := <get-record, get-salary>
; type := <divisions>

(define (make-insatiable-file division file)
  (cons division file))
(define (insatiable-file-division insatiable-file)
  (car insatiable-file))
(define (insatiable-file-content insatiable-file)
  (cdr insatiable-file))

(define (get-record employee-name insatiable-file)
  (let ((the-division (insatiable-file-division insatiable-file))
        (division-record ((get 'get-record the-division)
                          employee-name
                          (insatiable-file-content insatiable-file))))
    (if (null? record)
      record
      (attach-tag the-division division-record))))

(define (make-insatiable-record division record)
  (cons division record))
(define (insatiable-record-division insatiable-record)
  (car insatiable-record))
(define (insatiable-record-content insatiable-record)
  (cdr insatiable-record))

(define (get-salary insatiable-record)
  (let ((the-division (insatiable-record-division insatiable-record)))
    ((get 'get_salary the-division) insatiable-record-content)))

(define (find-employee-record employee-name personnel-files)
  (if (null? personnel_files)
    nil
    (let ((insatiable-record (get-record employee-name
                                         (car personnel-files))))
      (if (null? insatiable-record)
        (find-employee-record employee-name
                              (cdr personnel-files))
        insatiable-record))))
