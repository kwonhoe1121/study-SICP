; 돈을 맞바꾸는 문제에서는 서로의 계좌 상태가 공유되어야 하지만,
; '출금'과 '입금'은 각 계좌에서만 독립적으로 병행성을 유지하면 된다.

(define (transfer from-account to-account amount)
  ((from-account 'withdraw) amount)
  ((to-account 'deposit) amount))
