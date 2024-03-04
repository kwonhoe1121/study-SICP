(load "./src/lib/util.scm")

; (a) recur

(define (count-frac n d k)
  (define (recur i)
    (if (> i k)
      0
      (/ (n i)
         (+ (d i) (recur (+ i + 1))))))
  (recur 1))

; (b) iter

(define (cont-frac-iter n d k)
  (define (iter i result)
    (if (= i 0)
      result
      (iter (- i 1)
            (/ (n i)
               (+ (d i) result)))))
  (iter k 0))


(cont-frac (lambda (i) 1.0)
           (lambda (i) 1.0)
           100)

(cont-frac-iter (lambda (i) 1.0)
                (lambda (i) 1.0)
                100)

(/ 1 (phi))
