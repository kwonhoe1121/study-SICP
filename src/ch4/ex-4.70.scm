; (define (add-assertion! assertion)
;   (store-assertion-in-index assertion)
;   (let ((old-assertions THE-ASSERTIONS))
;     (set! THE-ASSERTIONS
;           (cons-stream assertion 
;                        old-assertions))
;     'ok))

; let을 쓰지 않는 아래의 경우 THE-ASSERTIONS 이 평가되지 않고, 자기 자신을 참조하면서 무한 루프에 빠지게 된다.

(define (add-assertion! assertion)
  (store-assertion-in-index assertion)
  (set! THE-ASSERTIONS
        (cons-stream assertion 
                     THE-ASSERTIONS))
  'ok)
