; 레지스터, 상수 값만 처리되도록 수정 (라벨은 제외)

(define (make-operation-exp expr machine labels operations)
  (let ((op (lookup-prim (operation-exp-op expr) operations))
        (aprocs
          (map (lambda (e)
                       (if (label-exp? e)
                           (error "can't operate on label -- MAKE-OPERATION-EXP" e)
                           (make-primitive-exp e machine labels)))
               (operation-exp-operands expr))))
       (lambda ()
               (apply op (map (lambda (p) (p)) aprocs)))))
