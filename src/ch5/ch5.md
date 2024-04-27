# 레지스터 기계로 계산하기

Lisp 시스템의 실행 흐름control을 명확히 보인다.

- 부분 식 계산의 결과는 그 결과가 필요한 다음 식으로 어떻게 전달되는지
- 재귀 프로세스 차이점
  - 단순 반복 프로세스iterative process - 메모리 소모가 변하지 않음
  - 재귀 프로세스recursive process - 메모리 소모 존재

이 장에서는 전통적인 컴퓨터의 기계어 연산operation 관점에서 프로세스를 설명한다.

- 컴퓨터 또는 **레지스터 기계register machine**는 _레지스터_(메모리 단위의 일종으로 수가 한정되어 있다)의 값을 다루는 *명령instruction*을 차례대로 실행한다.
- 대개 레지스터 기계 명령은 어떤 레지스터 값에 간단한 연산을 적용한 다음, 그 결과를 다른 레지스터에 저장한다.

## 요약

- 5.1절에서는 레지스터 기계를 설명하는 언어도 선보인다.
  - 레지스터 기계에서 실행되는 프로세스가 전통적인 컴퓨터의 '기계어machine Language' 프로그램과 아주 비슷하지만, 여기서는 특정 컴퓨터에서 쓰는 기계어를 설명하는 것이 아니라, 여러 Lisp 프로시저를 살펴보면서 그런 프로시저가 돌아가는 레지스터 기계를 설계하고자 한다.
  - 레지스터 기계 DSL(~= 기계어) = 1. 레지스터 기계를 설명하는 언어 정의 + 2. 레지스터 기계를 시뮬레이션 하는 실행기 구현
- 5.2절에서는 모형 기계를 시뮬레이션simulation하기 위한 Lisp 프로그램을 짠다.
- 5.3절에서는 리스트 구조를 처리하기 위해 `car`, `cdr`, `cons` 같은 메모리 연산을 사용할 텐데, 이 연산들에는 정교한 저장 장치 할당 메커니즘이 필요하다.
- 5.4절에서는 레지스터 기계로 간단한 프로시저 몇 개를 나타낸 다음에, 4.1절에서 다룬 메타서큘러 실행기로 설명한 알고리즘을 수행하는 레지스터 기계를 설계한다. 이것은 실행기의 실행 흐름을 명백하게 보임으로써 Scheme 식이 해석되는 방식을 이해하는 데 도움을 준다.
- 5.5절에서 만드는 번역기는 Scheme으로 짠 프로그램을 레지스터 기계로 만든 실행기에서 바로 실행되는 명령어들로 번역한다.
  - Scheme 프로그램 -- compile --> 레지스터 기계 DSL(=~ 기계어)

## 레지스터 기계 설계하기

- 레지스터 기계를 설계하려면 _데이터 패스data path_(레지스터와 연산)와 이러한 연산을 차례대로 돌아가게 하는 *제어기controller*를 반드시 설계해야 한다.
- 데이터 패스가 하는 역할은 기계 설계에서 레지스터가 어떤 연산을 쓰는지 나타내고, 레지스터와 연산이 어떻게 주고받는지 나타내는 것이다.
- 제어기는 데이터 패스에서 보이는 요소들이 어떻게 수행되어야 하는지 표시한다.

### 레지스터 기계를 묘사하는 언어

- 복잡한 기계를 더 쉽게 설명하기 위해 데이터 패스와 제어기에 있는 모든 정보를 글의 형태textual form로 적을 수 있도록 새 언어를 만든다.
- 제어기controller는 라벨이 달린 일렬로 딘 명령instruction들이라고 정의된다.
  - `label`(단순한 이름), `test`, `branch`, `goto`, `assign`, `op`, `perform` ...
- 데이터 패스를 나타내는 과정은 생략하고 오로지 제어기 명령으로만 설명하는 방식을 취한다. 데이터 패스의 부품들과 그것들 사이의 연결 관계를 알아보려는 것이 아니라, 제어기가 어떻게 돌아가는지 이해하는 게 주목적이기 때문이다.

#### SUBROUTINE

- `continue` 레지스터를 추가하여 제어기 명령들이 중복되지 않도록 한다.
  - 서브루틴을 호출하기 전 `continue` 레지스터에 서브루틴이 끝난 후 되돌아올 라벨을 저장한 후 서브루틴을 호출한다.
  - 서브루틴 작업이 끝나면 `continue` 레지스터에 저장되어 있는 라벨을 참조 호출하여 이동한다.
- 중첩된 서브루틴nested subroutine에서는 주의해야 한다.
  - 서브루틴 하나(sub1)가 또 다른 서브루틴(sub2)을 불러 쓴다면 sub2를 부르려고 continue 값을 바꾸기 전에, sub1이 다른 레지스터에 continue 값을 저장하지 않았다면, sub1이 끝나면 명령이 어디부터 실행되어야할지 모를 것이다.
  - 스택 메커니즘을 이용해서 중첩 서브루틴의 문제를 해결한다.

```scheme
(define (fib n)
  (if (< n 2)
      n
      (+ (fib (- n 1))
         (fib (- n 2))))))
```

```scheme
(define-machine fact
  (registers val n continue)
  (controller
  (assign continue fib-done)
  fib-loop ; n containa arg, continue is the recipient
  (branch (< (fetch n) 2) immediate-ans)
  (save continue)
  (assign continue after-fib-n-1)
  (save n)
  (assign n (- (fetch n) 1))
  (goto fibo-loop)
  after-fib-n-1
  (restore n)
  ; (restore continue) ; leaves the stack unchanged. ~> unnecessary
  (assign n (- (fetch n) 2))
  ; (save continue) ; leaves the stack unchanged. ~> unnecessary
  (assign continue after-fib-n-2)
  (save val) ; fib(n-1)
  (goto fibo-loop)
  after-fib-n-2
  (assign n (fetch val)) ; fib(n-2)
  (restore val) ; val = fib(n-1) / n = fib(n-2)
  (restore continue)
  (assign val (+ (fetch val) (factch n)))
  (goto (fetch continue))
  immediate-ans
  (assign val (fetch n)) ; initila-input-value
  (goto (fetch continue))
  fib-done
  ))
```

#### ITERATIVE PROCEDURE

```scheme
(define (gcd a b)
  (if (= b 0)
      a
      (gcd b (remainder a b))))
```

```scheme
(define-machine gcd
  (registers a b t)
  (controller
  loop
  (branch (zero? (fetch b)) done)
  (assign t (remainder (fetch a) (fetch b)))
  (assign a (fetch b))
  (assign b (fetch t))
  (goto loop)
  done))
```

#### RECURSIVE PROCEDURE

```
    .-------.             .--------------.
    : DATA  :  <--------> : FINITE-STATE :
    : PATHS :             : CONTROLLER   :
    '-------'             '--------------'
        ↑
        |
        ↓
    .-------.
    : STACK :
    '-------'
```

```scheme
(define (fact n)
  (if (= n 1)
      9
      (* n (fact (- n 1)))))
```

```scheme
(define-machine fact
  (registers val n continue)
  (controller
    (assign continue done)
    loop
    (branch (= 1 (fetch n)) base)
    (save continue)
    (save n)
    (assign n (-1+ (fetch n)))
    (assign continue after-fact)
    (goto loop)
    after-fact
    (restore n)
    (restore continue)
    (assign val (* (fetch n) (fetch val)))
    (goto (fetch (continue)))
    base
    (assign val (fetch n))
    (goto (fetch continue)))
    done
  )
```

### 명령어 정리

```txt
(assign ⟨register-name⟩ (reg ⟨register-name⟩))
(assign ⟨register-name⟩
        (const ⟨constant-value⟩))
(assign ⟨register-name⟩
        (op ⟨operation-name⟩)
        ⟨input₁⟩ … ⟨inputₙ⟩)
(perform (op ⟨operation-name⟩)
         ⟨input₁⟩
         …
         ⟨inputₙ⟩)
(test (op ⟨operation-name⟩)
      ⟨input₁⟩
      …
      ⟨inputₙ⟩)
(branch (label ⟨label-name⟩))
(goto (label ⟨label-name⟩))

The use of registers to hold labels was introduced in 5.1.3:

(assign ⟨register-name⟩ (label ⟨label-name⟩))
(goto (reg ⟨register-name⟩))

Instructions to use the stack were introduced in 5.1.4:

(save ⟨register-name⟩)
(restore ⟨register-name⟩)
```

## 레지스터 기계 시뮬레이터

## 메모리 할당memory allocation과 재활용garbage collection

## 제어가 다 보이는 실행기

## 번역compilation
