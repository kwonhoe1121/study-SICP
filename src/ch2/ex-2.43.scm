(flatmap
 (lambda (new-row)
   (map (lambda (rest-of-queens)
          (adjoin-position 
           new-row k rest-of-queens))
        (queen-cols (- k 1)))) ; 재귀 호출 위치 변경
 (enumerate-interval 1 board-size))

; O(n!) -> O(n^n)
