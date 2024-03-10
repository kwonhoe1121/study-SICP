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
