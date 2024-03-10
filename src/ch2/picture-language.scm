(load "./src/lib/util.scm")

; 그림 언어
; 1. 원시 요소: 페인터 => 프로시저로 구현 => 일관성, 데이터 추상
; 2. 조합 수단: beside, below, filp-vert, flip-horizon, ... -> 조합 결과는 페인터(닫힘 성질)
; 3. 추상화 수단: 기본 스킴 프로시저 사용

; 조합 수단에 대한 데이터의 닫힘 성질은, 몇 안되는 연산만으로 복잡한 구조를 만들 수 있는 힘을 마련하는 데 아주 중요한 기초가 된다.

(define (flipped-pairs painter)
  (let ((painter2 
         (beside painter 
                 (flip-vert painter))))
    (below painter2 painter2)))

(define (right-split painter n)
  (if (= n 0)
      painter
      (let ((smaller (right-split painter 
                                  (- n 1))))
        (beside painter 
                (below smaller smaller)))))

(define (corner-split painter n)
  (if (= n 0)
      painter
      (let ((up (up-split painter (- n 1)))
            (right (right-split painter 
                                (- n 1))))
        (let ((top-left (beside up up))
              (bottom-right (below right 
                                   right))
              (corner (corner-split painter 
                                    (- n 1))))
          (beside (below painter top-left)
                  (below bottom-right 
                         corner))))))

(define (square-limit painter n)
  (let ((quarter (corner-split painter n)))
    (let ((half (beside (flip-horiz quarter) 
                        quarter)))
      (below (flip-vert half) half))))

; ex-2.44
(define (up-split painter n)
  (if (= n 0)
    painter
    (let ((smaller (up-split painter (- n 1))))
      (below painter
             (beside smaller smaller)))))

(define (square-of-four tl tr bl br)
  (lambda (painter)
    (let ((top (beside (tl painter) 
                       (tr painter)))
          (bottom (beside (bl painter) 
                          (br painter))))
      (below bottom top))))

(define (flipped-pairs painter)
  (let ((combine4 
         (square-of-four identity 
                         flip-vert
                         identity 
                         flip-vert)))
    (combine4 painter)))

(define (square-limit painter n)
  (let ((combine4 
         (square-of-four flip-horiz 
                         identity
                         rotate180 
                         flip-vert)))
    (combine4 (corner-split painter n))))

; ex-2.45
(define (split f1 f2)
  (define (recur painter n)
    (if (= n 0)
      painter
      (let ((smaller (recur painter
                            (- n 1))))
        (f1 painter
            (f2 smaller smaller)))))
  recur)

(define right-split (split beside below))
(define up-split (split below beside))
 
; 그림틀 := <원점벡터, 모서리1 벡터, 모서리2 벡터>
; 프로시저는 인자로 바다은 벡터가 단위 네모 속에 있을 때, 그에 해당하는 그림틀 속의 벡터를 돌려준다.
(define (frame-coord-map frame)
  (lambda (v)
    (add-vect
     (origin-frame frame)
     (add-vect 
      (scale-vect (xcor-vect v)
                  (edge1-frame frame))
      (scale-vect (ycor-vect v)
                  (edge2-frame frame))))))

; 2.46
(define (make-vect x y) (cons x y))
(define (xcor-vect v) (car v))
(define (ycor-vect v) (cdr v))

(define (add-vect v1 v2)
  (make-vect (+ (xcor-vect v1) (xcor-vect v2))
             (+ (ycor-vect v1) (ycor-vect v2))))
(define (sub-vect v1 v2)
  (make-vect (- (xcor-vect v1) (xcor-vect v2))
             (- (ycor-vect v1) (ycor-vect v2))))
(define (scale-vect s v)
  (make-vect (* s (xcor-vect v))
             (* s (ycor-vect v))))

; 2.47
(define (make-frame origin edge1 edge2)
  (list origin edge1 edge2))
(define (origin-frame frame) (car frame))
(define (edge1-frame frame) (car (cdr frame)))
(define (edge2-frame frame) (car (cdr (cdr frame))))

(define (make-frame origin edge1 edge2)
  (cons origin (cons edge1 edge2)))
(define (origin-frame frame) (car frame))
(define (edge1-frame frame) (car (cdr frame)))
(define (edge2-frame frame) (cdr (cdr frame)))

; 페인터
; 페인터는 프로시저로 나타낸다. 이 프로시저는 그림틀을 인자로 받아서, 그 틀에 맞춘 그림을 그린다. (선분 리스트를 인자로 받고, 그림틀을 인자로 받는 함수 반환)
; 리스트 속 선분 하나하나에 대하여, 선분의 두 끝점이 가리키는 좌표 값을 그림틀 속의 좌표 값으로 바꾼 다음에, 그 좌표 값 사이에 선을 긋는다.
; 데이터를 프로시저로 표현하는 방식
(define (segments->painter segment-list)
  (lambda (frame)
    (for-each
     (lambda (segment)
       (draw-line
        ((frame-coord-map frame) 
         (start-segment segment))
        ((frame-coord-map frame) 
         (end-segment segment))))
     segment-list)))

; ex-2.48

(define (make-segment start end) (cons start end))
(define (start-segment segment) (car segment))
(define (end-segment segment) (cdr segment))

; ex-49

; 주어진 액자의 테두리를 그리는 화가.

(define outline-start-1 (make-vect 0 0))
(define outline-end-1 (make-vect 1 0))
(define outline-segment-1 (make-segment outline-start-1 outline-end-1))
(define outline-start-2 (make-vect 1 0))
(define outline-end-2 (make-vect 1 1))
(define outline-segment-2 (make-segment outline-start-2 outline-end-2))
(define outline-start-3 (make-vect 1 1))
(define outline-end-3 (make-vect 0 1))
(define outline-segment-3 (make-segment outline-start-3 outline-end-3))
(define outline-start-4 (make-vect 0 1))
(define outline-end-4 (make-vect 0 1))
(define outline-segment-4 (make-segment outline-start-4 outline-end-4))
(define outline-painter
  (segments->painter
    (list outline-segment-1
          outline-segment-2
          outline-segment-3
          outline-segment-4)))

; 주어진 액자의 꼭짓점들을 대각선 방향으로 연결해서 'X'자를 그리는 화가

(define x-start-1 (make-vect 0 0))
(define x-end-1 (make-vect 1 1))
(define x-segment-1 (make-segment x-start-1 x-end-1))
(define x-start-2 (make-vect 1 0))
(define x-end-2 (make-vect 0 1))
(define x-segment-2 (make-segment x-start-2 x-end-2))
(define x-painter (segments->painter (list x-segment-1 x-segment-2)))


; 주어진 액자의 각 변 중점을 연결해서 마름모꼴(다이아몬드)을 그리는 화가.

(define diamond-start-1 (make-vect 0.5 0))
(define diamond-end-1 (make-vect 1 0.5))
(define diamond-segment-1 (make-segment diamond-start-1 diamond-end-1))
(define diamond-start-2 (make-vect 1 0.5))
(define diamond-end-2 (make-vect 0.5 1))
(define diamond-segment-2 (make-segment diamond-start-2 diamond-end-2))
(define diamond-start-3 (make-vect 0.5 1))
(define diamond-end-3 (make-vect 0 0.5))
(define diamond-segment-3 (make-segment diamond-start-3 diamond-end-3))
(define diamond-start-4 (make-vect 0 0.5))
(define diamond-end-4 (make-vect 0.5 0))
(define diamond-segment-4 (make-segment diamond-start-4 diamond-end-4))
(define diamond-painter
  (segments->painter
    (list diamond-segment-1
          diamond-segment-2
          diamond-segment-3
          diamond-segment-4)))

; 틀 변환
; 페인터 변환은 처음에 받아온 페인터를 그대로 쓰되, 그 뒤에 인자로 받은 틀에서 새로운 틀을 이끌어 내어 그에 맞추어 그림을 그리는 방식을 따른다.
; 변환된 페인터는 틀을 인자로 받아서 그 틀을 변환한 다음에 원래 있던 페인터를 변환된 틀에 적용한다.
(define (transform-painter 
         painter origin corner1 corner2)
  (lambda (frame)
    (let ((m (frame-coord-map frame)))
      (let ((new-origin (m origin)))
        (painter (make-frame new-origin
                  (sub-vect (m corner1) 
                            new-origin)
                  (sub-vect (m corner2)
                            new-origin)))))))

(define (flip-vert painter)
  (transform-painter 
   painter
   (make-vect 0.0 1.0)   ; new origin
   (make-vect 1.0 1.0)   ; new end of edge1
   (make-vect 0.0 0.0))) ; new end of edge2

(define (shrink-to-upper-right painter)
  (transform-painter painter
                     (make-vect 0.5 0.5)
                     (make-vect 1.0 0.5)
                     (make-vect 0.5 1.0)))

(define (rotate90 painter)
  (transform-painter painter
                     (make-vect 1.0 0.0)
                     (make-vect 1.0 1.0)
                     (make-vect 0.0 0.0)))

(define (squash-inwards painter)
  (transform-painter painter
                     (make-vect 0.0 0.0)
                     (make-vect 0.65 0.35)
                     (make-vect 0.35 0.65)))

; 무엇보다도 페인터를 프로시저로 표현한 방식이 beside 프로시저를 얼마나 구현하기 쉽게 만드는지 눈여겨보자.
(define (beside painter1 painter2)
  (let ((split-point (make-vect 0.5 0.0)))
    (let ((paint-left  (transform-painter 
                        painter1
                        (make-vect 0.0 0.0)
                        split-point
                        (make-vect 0.0 1.0)))
          (paint-right (transform-painter
                        painter2
                        split-point
                        (make-vect 1.0 0.0)
                        (make-vect 0.5 1.0))))
      (lambda (frame)
        (paint-left frame)
        (paint-right frame)))))

; ex-2.50
; 좌우로 뒤집힌 이미지를 생성하도록 변환하는 변환 함수
(define (flip-horiz painter)
  (transform-painter painter
                     (make-vect 1 0)
                     (make-vect 0 0)
                     (make-vect 1 1)))

; 이미지를 반시계방향으로 180도 회전하게 하는 변환 함수
(define (rotate180 painter)
  (transform-painter painter
                     (make-vect 1 1)
                     (make-vect 0 1)
                     (make-vect 1 0)))

; 이미지를 반시계방향으로 270도 회전하게 하는 변환 함수
(define (rotate270 painter)
  (transform-painter painter
                     (make-vect 0 1)
                     (make-vect 0 0)
                     (make-vect 1 0)))

; ex-2.51

; 두 화가의 그림을 상하로 배치하는 화가를 만드는 변환 함수
(define (below painter1 painter2)
  (let ((split-point (make-vect 0 0.5))
        (paint-upper (transform-painter painter1
                                        split-point
                                        (make-vect 1 0.5)
                                        (make-vect 0 1)))
        (paint-lower (transform-painter painter2
                                        (make-vect 0 0)
                                        (make-vect 1 0)
                                        split-point)))
    (lambda (frame)
      (paint-upper frame)
      (paint-lower frame))))
