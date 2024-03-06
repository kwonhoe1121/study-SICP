
(define foo (list 1 3 (list 5 7) 9))

; (display (cdr (car (cdr (cdr foo))))) ; (7)
; (display (car (cdr (car (cdr (cdr foo)))))) ; 7

(define foo2 (list (list 7)))

; (display (car foo2)) ; (7)
; (display (car (car foo2))) ; 7

(define foo3 (list 1 (list 2 (list 3 (list 4 (list 5 (list 6 7)))))))

; (display (cdr
;            (car (cdr
;                      (car (cdr
;                                (car (cdr
;                                          (car (cdr
;                                                    (car (cdr foo3)))))))))))) ; (7)
; (display (car (cdr
;                 (car (cdr
;                           (car (cdr
;                                     (car (cdr
;                                               (car (cdr
;                                                         (car (cdr foo3))))))))))))) ; 7

; (display (cadr (cadr (cadr (cadr (cadr (cadr foo3)))))))
