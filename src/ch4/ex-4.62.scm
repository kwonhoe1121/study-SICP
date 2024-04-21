(assert! (rule (last-pair (?x) (?x))))
(assert! (rule (last-pair (?u . ?v) (?x))
               (last-pair ?v (?x))))

(last-pair (3) ?x)
; ==> (last-pair (3) (3))

(last-pair (1 2 3) ?x)
; ==> (last-pair (1 2 3) (3))

(last-pair (2 ?x) (3))
; ==> (last-pair (2 3) (3))

; (last-pair ?x (3))
; ==> ...?  There are infinite instances.
