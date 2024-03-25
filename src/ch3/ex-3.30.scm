(load "./src/ch3/digital-circuit/digital-circuit.scm")

; 전가산기 n개를 연결한 리플캐리 가산기(ripple-carry-adder).
; 이것은 두 개의 n 비트 이진수를 더하는 병렬 가산기 중 가장 간단한 형태.
; 리플캐리 가산기의 주된 단점은 자리올림 신호들이 끝까지 전파되길 기다려야 한다는 점이다.

(define (ripple-carry-adder a b s c)
  (define (iter rest-a rest-b c-in)
    (let ((a1 (car rest-a))
          (b1 (car rest-b))
          (s1 (make-wire))
          (c-out (make-wire)))
      (if (or (null? a1)
              (null? b1))
        'ok
        (begin
          (full-adder a1 b1 c-in s1 c-out)
          (set! s (append s1 s))
          (iter (cdr rest-a) (cdr rest-b) c-out)))))
  (iter (reverse a) (reverse b) c))

; [참고답안]

(define (ripple-carry-adder a b s c)
  (let ((c-in (make-wire)))
        (if (null? (cdr a))
          (set-signal! c-in 0)
          (ripple-carry-adder (cdr a) (cdr b) (cdr s) c-in))
        (full-adder (car a) (car b) c-in (car s) c)))
