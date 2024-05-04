; 실행기에 cond, let 같이 파생된 식 추가

; (a) - cond

;; add those to eval-operations (위임하기)
(list 'cond? cond?)
(list 'cond->if cond->if)

;;  add those following ev-dispatch
ev-dispatch
  (test (op cond?) (reg exp))
  (branch (label ev-cond))

ev-cond
  (assign exp (op cond->if) (reg exp))
  (goto (label ev-if))

; (b) - let

;; add those to eval-operations (위임하기)
(list 'let? cond?)
(list 'let->combination cond->if)

;; Add to eval-dispatch
eval-dispatch
  (test (op let?) (reg exp))
  (branch (label ev-let))

;; add this to eval operations
ev-let
  (assign exp (op let->combination) (reg exp))
  (goto (label ev-lambda))
