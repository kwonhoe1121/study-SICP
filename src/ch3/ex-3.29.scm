(load "./src/ch3/digital-circuit/digital-circuit.scm")

; or_gate_delay := and_gate_delay + inverter_delay

(define (or-gate a1 a2 output)
  (if (not (= (get-signal a1)
              (get-signal a2)))
    (if (= (get-signal a1) 0)
      (inverter a1 a1)
      (inverter a2 a2)))
  (and-gate a1 a2 output)
  'ok)

; [참고답안]

;; a
;; (A or B) is equivalent to (not ((not A) and (not B)))
(define (or-gate a1 a2 output)
  (let ((c1 (make-wire))
        (c2 (make-wire))
        (c3 (make-wire)))
    (inverter a1 c1)
    (inverter a2 c2)
    (and-gate c1 c2 c3)
    (inverter c3 output)))


;; b
; the delay is the sum of and-gate-delay plus twice inverter-delay.
