# 프로시저와 프로세스

## 선형(factorial)

| 모양,꼴(shape) | 계산 단계 | 기억 공간 |
| -------------- | --------- | --------- |
| fact recur     | O(n)      | O(n)      |
| fact iter      | O(n)      | O(1)      |

### recur

```lisp
(define (factorial n)
  (if (= n 1)
    1
    (* n (factorial (- n 1)))))
```

### iter

```lisp
(define (factorial n)
  (define (iter product counter)
    (if (> counter n)
      product
      (iter (* counter product)
            (+ counter 1)))
  (iter 1 1)))
```

## 트리(fibo)

| 모양,꼴(shape) | 계산 단계 | 기억 공간 |
| -------------- | --------- | --------- |
| fibo recur     | O(∅ⁿ)     | O(n)      |
| fibo iter      | O(n)      | O(1)      |

### recur

대개 여러 갈래로 되도는 프로세스가 거치는 단계 수는 나무 마디 수에 비례하고, 기억 공간의 크기는 가장 큰 나무 키에 비례한다.

recur 의 경우, 성능을 높이기 위해 메모화 기술이 자주 사용된다. (트리 레벨에 따라서 계산해야하는 숫자가 지수 함수로 증가한다. )

계산 단계: 지수 비례 - 메모화 -> 선형 비례

```lisp
(define (fib n)
  (cond ((= n 0) 0)
        ((= n 1) 1)
        (else (+ (fib (- n 1))
                 (fib (- n 2))))))
```

돈 바꾸는 방법:

- 처음 나오는 한 가지 동전을 아예 쓰지 않는 방법과 다 쓰는 방법, 이 둘로 문제가 나뉜다는 점을 눈여겨 보아야 한다.
- 다시 말해, 처음 나오는 한 가지 동전을 쓰지 않고 바꾸는 가짓수와, 처음 나오는 동전까지 모두 써서 바꾸는 가짓수를 따로 구해서 이를 더한 것과 같다.

```lisp
(define (count-change amount)
  (define (first-denomination kinds-of-coins)
    (cond ((= kinds-of-coins 1) 1)
          ((= kinds-of-coins 2) 5)
          ((= kinds-of-coins 3) 10)
          ((= kinds-of-coins 4) 25)
          ((= kinds-of-coins 5) 50)))
  (define (iter amount kinds-of-coins)
    (cond ((= amount 0) 1)
          ((or (< amount 0) (= kinds-of-coins 0)) 0)
          (else (+ (iter amount
                         (- kinds-of-coins 1))
                   (iter (- amount
                            (first-denomination kinds-of-coins))
                         kinds-of-coins)))))
  (iter amount 5))
```

### iter

```lisp
(define (fib n)
  (define (iter a b count)
    (if (= count 0)
      b
      (iter (+ a b) a (- count 1))))
  (iter 1 0 n))
```

## 거듭제곱

### recur

```lisp
(define (expt b n)
  (if (= n 0)
    1
    (* b (expt b (- n 1)))))
```

### iter

```lisp
(define (expt b n)
  (define (iter b counter product)
    (if (= counter 0)
      product
      (iter b
            (- counter 1)
            (* b product))))
  (iter b n))
```

### 로그(`n*(1/2)^k = 1`)

```txt
n is even, b^n = (b^(n/2))^2
n is odd, b^n = b*b^(n-1)
```

```lisp
(define (fast-expt b n)
  (cond ((= n 0) 1)
        ((even? n) (square (fast-expt b (/ n 2))))
        (else (* b (fast-expt b (- n 1))))))
```

```lisp
(define (fast-expt b n)
  (define (iter a e count)
    (cond ((> count n) a)
          ((even? count) (iter (* (square b) e)
                           (* (square b) e)
                           (+ count 1)))
          (else (iter (* a b)
                      e
                      (+ count 1)))))
  (iter 1 1 1))
```
