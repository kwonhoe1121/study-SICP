(load "./src/ch3/stream/stream.scm")

; 2, 3, 5 이외의 소인수는 없는 모든 양의 정수를 중복 없이 오름차순으로 나열하는 프로그램
 
(define S
  (cons-stream
    1
    (merge
      (scale-stream S 2)
      (merge (scale-stream S 3)
             (scale-stream S 5)))))
