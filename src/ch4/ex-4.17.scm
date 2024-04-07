; ex) C언어 컴파일은 파일 단위로 이뤄짐, extern 으로 외부에 해당 선언부가 존재함을 명시하여 컴파일 시 에러를 막을 수 있다.

; [참고답안]

;; a 
; because let expression will be substituted as lambda expression, every lambda expression will extend the environment. 

;; b 
; the new environment is confined to the let expression, it doesn't change the outer environment. 

;; c 
; Do away with the let - All the (define var '*unassigned*) which was there in the let statements should instead be moved on top of the body. The set! statements should simply replace the earlier defines. 

; Note that you cannot simply, move all defines to the start of the body, because that might allow the body to access variables not yet defined in the original code. 
