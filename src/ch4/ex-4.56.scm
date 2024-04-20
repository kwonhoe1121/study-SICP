; (a)

(and (supervisor ?person (Bitdiddle Ben))
     (address ?person ?address))

; (b)

(and (salary (Bitdiddle Ben) $ben-salary)
     (salary ?person $person-salary)
     (lisp-value < $person-salary $ben-$salary))

; (c)

(and (not (job ?person (computer . ?department)))
     (supervisor ?managed-person ?person)
     (job ?person ?job))
