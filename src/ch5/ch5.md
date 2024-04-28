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

- `stack` + `continue`
  - 재귀 계산의 깊이를 미리 알지 못하므로 저장할 레지스터 값을 얼마든지 커질 수 있다. 그리고 저장한 값은 역순으로 되돌려 놓아야 한다. '나중에 넣은 게 먼저 나오는' **스택stack** 데이터 구조를 사용한다. - `save`, `restore` 연산 활용
  - 이 방법에서는 제어기가 안에 있는 문제를 풀고 나서 원래 문제를 이어서 풀려고 할 때, 알맞은 명령 위치로 되돌아갈 목적으로 `continue` 레지스터를 사용한다. 따라서 `continue` 레지스터에 저장된 진입점entry point으로 돌아가는 팰토리얼 서브루틴을 만들 수 있다. 즉, 팩토리얼 서브루틴은 낮은 수준의 문제를 불러낼 때 그 위치(안에 있는 문제를 풀기 시작한 곳)를 새로운 값으로 삼아 `continue` 레지스터에 넣는다.
- 되도는 방식으로 어떤 문제를 풀 때 스택에 저장한 레지스터 값은 문제를 푼 다음에 필요하다. 문제를 풀고 나면 저장한 레지스터를 복구하고 다시 원래 문제로 계속 진행할 수 있다. (`continue` 레지스터는 언제나 저장되어야 한다.)
  - 레지스터 값이 변경될 경우 다른 계산에 영향을 미치는 레지스터의 경우는 값을 변경(`assign`) 연산을 적용하기 전에 현재 값을 스택에 저장`save`한다.

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
  (registers val n continue) ; 필요한 레지스터
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

##### 두 군데서 되도는 프로세스double recursion - tree-recursive

```scheme
(define (fib n)
  (if (< n 2)
      n
      (+ (fib (- n 1)) (fib (- n 2)))))
```

```scheme
(controller
   (assign continue (label fib-done))
 fib-loop
   (test (op <) (reg n) (const 2))
   (branch (label immediate-answer))
   ;; set up to compute Fib(n − 1)
   (save continue)
   (assign continue (label afterfib-n-1))
   (save n)           ; save old value of n
   (assign n
           (op -)
           (reg n)
           (const 1)) ; clobber n to n-1
   (goto
    (label fib-loop)) ; perform recursive call
 afterfib-n-1 ; upon return, val contains Fib(n − 1)
   (restore n)
   ;; set up to compute Fib(n − 2)
   (assign n (op -) (reg n) (const 2))
   (assign continue (label afterfib-n-2))
   (save val)         ; save Fib(n − 1)
   (goto (label fib-loop))
 afterfib-n-2 ; upon return, val contains Fib(n − 2)
   (assign n
           (reg val)) ; n now contains Fib(n − 2)
   (restore val)      ; val now contains Fib(n − 1)
   (restore continue)
   (assign val        ; Fib(n − 1) + Fib(n − 2)
           (op +)
           (reg val)
           (reg n))
   (goto              ; return to caller,
    (reg continue))   ; answer is in val
 immediate-answer
   (assign val
           (reg n))   ; base case: Fib(n) = n
   (goto (reg continue))
 fib-done)
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

### 기계 모형

- `make-machine`으로 만든 모형 기계는 메시지 패싱 기법을 사용하여 지역적인 상태local state를 가진 프로시저로 나타낸다.

```txt
(make-machine ⟨register-names⟩ ⟨operations⟩ ⟨controller⟩)

(set-register-contents! ⟨machine-model⟩ ⟨register-name⟩ ⟨value⟩)

(get-register-contents ⟨machine-model⟩ ⟨register-name⟩)

(start ⟨machine-model⟩)
```

- `flag` 레지스터는 시뮬레이션 기계에서 제어가 어디로 갈라질지 결정할 때 쓴다. `test` 명령은 검사 결과(참 또는 거짓)를 `flag` 레지스터에 넣는다. `branch` 명령은 `flag`값에 따라 갈림길에서 어디로 갈지 결정한다.
- `pc` 레지스터는 기계가 돌아갈 때 명령이 실행되는 순서를 알려주는데, 내부 프로시저 `execute`에서 차례대로 명령을 구현한다.
  - `branch`와 `goto` 명령에서는 `pc`가 새로운 위치를 가리키도록 한다. 다른 명령들은 단순히 `pc` 값이 명령 시퀀스의 다음 명령을 가리키도록 한다.

### 어셈블러

- 어셈블러는 기계의 제어기 식들을 그에 상응하는 기계어 명령들로 바꾸어 준다.
  - 단순한 규칙(문법)으로 작성된 `controller-text`에 의미를 부여한다.
  - 그 명령마다 실행 프로시저가 있다.
  - 대체로 어셈블러는 **실행기evaluator**와 아주 비슷하다. 그 실행기는 언어(여기서는 레지스터 기계어)를 입력받고, 그 언어에서 식의 종류에 따라 그에 알맞은 일을 해야 했다.
- 레지스터의 실제 값을 몰라도 레지스터-기계-언어 식을 유용하게 분석할 수 있다.
  - 레지스터 물체에 대한 참조를 포인터로 바꿀 수 있고 라벨이 지정하는 명령 시퀀스의 참조도 포인터로 바꿀 수 있다.
  - 그래서 어셈블러는 명령어에서 라벨을 구별하기 위해, 제어기 텍스트controller text를 스캔scan하는 일부터 시작한다. 텍스트를 스캔하면서 명령 리스트를 만들고, 리스트 안의 명령어와 라벨을 연관시키기 위한 포인터의 테이블을 만든다. 그러면서 어셈블러는 각 명령을 수행하는 실행 프로시저를 끼워 넣으면서 명령 리스트를 완성해 나간다.
- 실행 프로시저는 `extract-labels`가 명령을 바로 만들었을 때에는 아직 완성된 것이 아니며 결국 나중에 `update-insts!`가 실행 명령을 직접 넣어주면서 만들어 낸다.

### 명령 실행 프로시저 만들기

- 각 명령을 분석하는 일은 시뮬레이션할 때 수행되는 것이 아니라 어셈블할 때 한 번만 수행한다.

## 메모리 할당memory allocation과 재활용garbage collection

## 제어가 다 보이는 실행기

## 번역compilation
