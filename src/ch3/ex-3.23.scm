(load "./src/ch3/queue/deque.scm")

(define dq (make-deque)) 

(dq 'empty?)

((dq 'front-insert!) 'a)

((dq 'rear-insert!) 'b)

((dq 'rear-insert!) 'c)

(dq 'front)

(dq 'rear)

(dq 'front-delete!)

(dq 'rear-delete!)

(dq 'print)
