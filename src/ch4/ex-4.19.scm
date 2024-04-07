(let ((a 1)) ; a
  (define (f x)
    (define b (+ a x))
    (define a 5) ; a
    (+ a b))
  (f 10))

; Ben - 16
; Alyssa - error! 'Unassigned variable a - 스킴 구현 방식
; Eva - 20 - 구현 어려움

; ∴ 원칙을 따지면, Eva가 옳다. 하지만, Eva가 바라는 방식은 일반성과 효율성을 뒷바침하게끔 구현해 내기가 어렵다. 그런 방식을 따르지 않을 바에야 (Ben처럼) 잘못된 답을 내기보다는 (Alyssa의 생각처럼) 모든 정의를 한꺼번에 처리하기 어려운 경우에 그런 시도가 잘못되었음을 알려주는 편이 낫다.

; [JS 버전]

; const test = () => {
;   const a = 1;
;   const f = (x) => {
;     const b = a + x;
;     const a = 5;
;     return a + b;
;   }
;   return f(10);
; }

; console.log(test()) // ReferenceError: Cannot access 'a' before initialization
