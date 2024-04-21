; [참고답안] - greats

(rule (end-in-grandson (grandson)))
(rule (end-in-grandson (?x . ?rest))
      (end-in-grandson ?rest))

(rule ((grandson) ?x ?y)
      (grandson ?x ?y))
(rule ((great . ?rel) ?x ?y) ; ?rel = grandson으로 끝나는 리스트
      (and (end-in-grandson ?rel)
           (son ?x ?z)
           (?rel ?z ?y)))
