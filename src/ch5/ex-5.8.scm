(define (label-exist? labels lable-name)
  (assoc label-name labels))

(define (extract-labels text)
  (if (null? text)
      (cons '() '())
      (let ((result (extract-labels (cdr text))))
           (let ((insts (car result))
                 (labels (cdr result)))
                (let ((next-inst (car text)))
                     (if (symbol? next-inst)
                         (if (label-exist? labels next-inst)
                             (error "the label has existed EXTRACT-LABELS" next-labels)
                             (cons insts
                                   (cons (make-label-entry next-inst insts) labels)))
                         (cons (cons (make-instruction next-inst) insts)
                               labels)))))))

; CPS style

(define (extract-labels text receive)
  (if (null? text)
      (receive '() '())
      (extract-labels (cdr text)
                      (lambda (insts labels)
                              (let ((next-inst (car text)))
                                   (if (sysmbol? next-inst)
                                       (let ((s (assoc next-inst labels)))
                                            (if s
                                                (error "Repeated label name" next-inst)
                                                (receive insts
                                                         (cons (make-label-entry next-inst
                                                                                 insts)
                                                               labels))))
                                       (receive (cons (make-instruction next-inst)
                                                      insts)
                                                labels)))))))
