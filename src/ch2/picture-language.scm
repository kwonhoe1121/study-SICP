(load "./src/lib/util.scm")

(require (planet "sicp.ss" ("soegaard" "sicp.plt" 2 1)))

; 그림 언어
; 1. 원시 요소: 페인터
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
