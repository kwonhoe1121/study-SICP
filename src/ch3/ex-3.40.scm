; a := (set! x (* x x))
; b := (set! x (* x x x))

(define x 10)
(parallel-execute 
 (lambda () (set! x (* x x)))
 (lambda () (set! x (* x x x))))

; a,b -> a -> b := 10^3
; a,b -> b -> a := 10^2
; 각 x 인자를 참조할 때마다, 달라진다.

(define x 10)
(define s (make-serializer))
(parallel-execute 
 (s (lambda () (set! x (* x x))))
 (s (lambda () (set! x (* x x x)))))

; a -> b := 10^6
; b -> a := 10^6

; [참고답안]

; P1: (lambda () (set! x (* x x)))
; P2: (lambda() (set! x (* x x x)))

; ** "x1", "x2", "x3" below refer to the first, second, and third arguments of the respective procedures

; P1 events:
; a) access x1
; b) access x2
; c) new value = x1 * x2
; d) set! x to new value

; P2 events:
; v) access x1
; w) access x2
; x) access x3
; y) new value = x1 * x2 * x3
; z) set! x to new value

; significant event sequences and their results:
; ** (P1) refers to event sequence "abcd", (P2) refers to event sequence "vwxyz"
; 1. (P1)(P2) => 1,000,000
; 2. (P2)(P1) => 1,000,000
; 3. a(P2)bcd => 10,000
; 4. v(P1)wxyz => 100,000
; 5. vw(P1)xyz => 10,000
; 6. abc(P2)d => 100
; 7. vwxy(P1)z => 1,000

; Unique results:
; [100, 1000, 10000, 100000, 1000000]

; After serializing P1 and P2:
; Only event sequence 1 and 2 remain:
; [1000000]
