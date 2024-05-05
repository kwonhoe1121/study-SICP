; save, restore 연산 최적화 해보기 -> preserving 메커니즘 활용

(f 'x 'y) ; => all the saves and restores are superfluous. because they doesn't change the registers. 
((f) 'x 'y) ; => all the saves and restores are superfluous. 
(f (g 'x) y) ; => register proc, argl will needed save and restore. 
(f (g 'x) 'y) ; => register proc, argl will needed save and restore. 
