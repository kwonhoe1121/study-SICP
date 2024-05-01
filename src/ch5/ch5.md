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
  - Lisp 리스트 구조를 '레지스터 기계DSL(=~ 기계어)'로 리스트 구조 메모리list-structured memory로 표현하는 방법
- 5.4절에서는 레지스터 기계로 간단한 프로시저 몇 개를 나타낸 다음에, 4.1절에서 다룬 메타서큘러 실행기로 설명한 알고리즘을 수행하는 레지스터 기계를 설계한다. 이것은 실행기의 실행 흐름을 명백하게 보임으로써 Scheme 식이 해석되는 방식을 이해하는 데 도움을 준다.
  - 숨김없이 드러낸 제어 실행기:
  - 'Scheme 실행기'를 '레지스터 기계 DSL(=~ 기계어)'로 구현
  - =~ 컴퓨터 기계어와 비슷한 언어로 쓰인, Scheme 실행기의 구현으로 볼 수 있다.
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

Lisp 시스템이 어떻게 돌아가는지 더 구체적으로 설명하려면 리스트 구조를 전통적인 컴퓨터 메모리와 호환되는 방식으로 표현할 수 있는 방법을 알아내야 한다.

리스트 구조를 구현할 때 고려해야 할 일 두가지

1. 표현 방법의 문제: 메모리와 전형적인 컴퓨터 메모리의 주소 지정 성능만으로 '상자와 포인터box-and-pointer' 구조로 된 Lisp 쌍을 어떻게 나타낼지 생각해 봐야 한다.
2. 계산이 진행될 때 메모리를 어떻게 관리할 것인가의 문제: 유한한 메모리에 무한한 메모리를 갖는 느낌을 제공하기 위해 '자동 메모리 할당memory allocation' 설비를 둔다. 이런 자동 메모리 할다을 다루는 기법 중 논의할 방법은 '메모리 재활용garbage collection'이다.

### 벡터로 나타낸 메모리

대체로 다수이 중요한 데이터 연산에서는 주소를 데이터처럼 사용해야 한다. 주소는 데이터처럼 메모리의 어떤 장소에 저장되고 기계 레지스터에서 조작된다.

- 주소 계산address arithmetic: _바닥 주소base address_ + _오프셋offset(인덱스)_

### Lisp 데이터 나타내기

`the-cars`와 `the-cdrs`라는 두 벡터로 컴퓨터 메모리가 나뉘었다고 하자. 쌍을 가리키는 포인터는 이 두 벡터들의 인덱스다. 그 쌍의 `car`는 인덱스가 가리키는 `the-cars` 벡터에 있는 데이터고, 그 쌍의 `cdr`는 `the-cdrs` 벡터에 있는 데이다.

- **타입을 갖춘 포인터typed pointer**: 데이터 타입 정보를 포함하도록 '포인터'를 확장한다.
  - 타입 갖춘 포인터는 쌍(데이터 타입과 메모리 인덱스로 만든 쌍)을 가리키는 포인터와, 다른 데이터 종류(다른 데이터 타입과 그 데이터를 나타내는 데 쓰이는 데이터)를 가리키는 포인터를 구별하는 시스템을 만들 수 있게 한다.
  - 두 데이터는 그 포인터가 일치하면 같은(`eq?`) 것으로 간주한다.
- **기호 인터닝interning**: 문자열을 유일한 포인터로 바꾸어 놓는 과정.
  - `obarray`라는 표로 관리한다.

### 기본 리스트 연산 만들기

레지스터 기계의 '기본' 리스트 연산은, 하나 또는 그 이상의 기본 벡터 연산으로 바꿀 수 있다.

```txt
(vector-ref ⟨vector⟩ ⟨n⟩)
(vector-set! ⟨vector⟩ ⟨n⟩ ⟨value⟩)
```

- 메모리 벡터를 구별하기 위해 `the-cars`와 `the-cdrs` 레지스터를 쓸 것이고, `vertor-ref`와 `vector-set!`는 기본 연산으로 쓸 수 있다고 하자. 포인터의 숫자 연산(포인터를 증가시키고, 벡터에 번호를 매기기 위해 쌍 포인터를 쓰고, 두 수를 더하는 일 등)은 오로지 타입 포인터의 인덱스 부분만 사용할 것이라고 하자.

```txt
(assign ⟨reg₁⟩ (op vector-ref) (reg the-cars) (reg ⟨reg₂⟩))
(assign ⟨reg₁⟩ (op vector-ref) (reg the-cdrs) (reg ⟨reg₂⟩))

(perform (op vector-set!) (reg the-cars) (reg ⟨reg₁⟩) (reg ⟨reg₂⟩))
(perform (op vector-set!) (reg the-cdrs) (reg ⟨reg₁⟩) (reg ⟨reg₂⟩))

(perform (op vector-set!) (reg the-cars) (reg free) (reg ⟨reg₂⟩))
(perform (op vector-set!) (reg the-cdrs) (reg free) (reg ⟨reg₃⟩))
(assign ⟨reg₁⟩ (reg free))
(assign free (op +) (reg free) (const 1))

(op eq?) (reg ⟨reg₁⟩) (reg ⟨reg₂⟩)
```

### 스택 구현

- 스택은 따로 마련한 레지스터 `the-stack`이 가리키는 값이 저장된 리스트

```txt
; (save ⟨reg⟩)
(assign the-stack (op cons) (reg ⟨reg⟩) (reg the-stack))

; (restore ⟨reg⟩)
(assign ⟨reg⟩ (op car) (reg the-stack))
(assign the-stack (op cdr) (reg the-stack))

(assign the-stack (const ()))
```

### 메모리 재활용garbage collection

- 쌍을 다시 쓰려면, 필요하지 않은 쌍을 정하는 방법이 있어야 한다. 그 아이디어는 나중에 계산할 때 필요할 수 있는 데이터는 현재의 기계 레지스터에서 가리키는 포인터부터 시작하는 `car`, `cdr` 연산으로 접근 할 수 있는 데이터들뿐이라는 점이다. 그렇게 해서 접근하지 못하는 메모리는 재활용할 수 있다.

#### stop-and-copy algorithm

- memory = working memory + free memory
- 작업 메모리가 가득 차면 필요한 쌍들만 비워둔 메모리에 복사한 후 비워둔 메모리를 작업메모리로 교체 후 이후의 메모리 할당을 진행한다.
- 쓸모있는 데이터는 연속적인 메모리 위치로 옮겨진다.(compacting)
- 또 다시 메모리가 가득 차면 위 작업을 반복한다.

```scheme
begin-garbage-collection
  (assign free (const 0))
  (assign scan (const 0))
  (assign old (reg root))
  (assign relocate-continue (label reassign-root))
  (goto (label relocate-old-result-in-new))
reassign-root
  (assign root (reg new))
  (goto (label gc-loop))
gc-loop
  (test (op =) (reg scan) (reg free))
  (branch (label gc-flip))
  (assign old (op vector-ref) (reg new-cars) (reg scan))
  (assign relocate-continue (label update-car))
  (goto (label relocate-old-result-in-new))
update-car
  (perform (op vector-set!) (reg new-cars) (reg scan) (reg new))
  (assign  old (op vector-ref) (reg new-cdrs) (reg scan))
  (assign  relocate-continue (label update-cdr))
  (goto (label relocate-old-result-in-new))
update-cdr
  (perform (op vector-set!) (reg new-cdrs) (reg scan) (reg new))
  (assign  scan (op +) (reg scan) (const 1))
  (goto (label gc-loop))
relocate-old-result-in-new
  (test (op pointer-to-pair?) (reg old))
  (branch (label pair))
  (assign new (reg old))
  (goto (reg relocate-continue))
pair
  (assign  oldcr (op vector-ref) (reg the-cars) (reg old))
  (test (op broken-heart?) (reg oldcr))
  (branch  (label already-moved))
  (assign  new (reg free)) ; new location for pair
  ;; Update free pointer.
  (assign free (op +) (reg free) (const 1))
  ;; Copy the car and cdr to new memory.
  (perform (op vector-set!) (reg new-cars) (reg new) (reg oldcr))
  (assign  oldcr (op vector-ref) (reg the-cdrs) (reg old))
  (perform (op vector-set!) (reg new-cdrs) (reg new) (reg oldcr))
  ;; Construct the broken heart.
  (perform (op vector-set!) (reg the-cars) (reg old) (const broken-heart))
  (perform (op vector-set!) (reg the-cdrs) (reg old) (reg new))
  (goto (reg relocate-continue))
already-moved
  (assign  new (op vector-ref) (reg the-cdrs) (reg old))
  (goto (reg relocate-continue))
gc-flip
  (assign temp (reg the-cdrs))
  (assign the-cdrs (reg new-cdrs))
  (assign new-cdrs (reg temp))
  (assign temp (reg the-cars))
  (assign the-cars (reg new-cars))
  (assign new-cars (reg temp))
```

#### mark & sweep algorithm

```scheme
; mark
gc (assign thing (fetch root))
   (assign continue sweep)
mark (branch (not-pair? (fetch thing))
             done)
pair (assign mark-flag
        (vector-ref (fetch the-marks)
                    (fetch thing)))
     (branch (= (fetch mark-flag) 1)
             done)
     (perform)
      (vector-set! (fetch the-marks)
                   (fetch thing)
                   1)
mcar (push thing)
     (push continue)
     (assign continue mcdr)
     (assign thing
        (vector-ref (fetch the-cars)
                    (fetch thing)))
     (goto mark)
mcdr (pop continue)
     (pop thing)
     (assign thing
        (vector-ref (fetch the-cdrs)
                    (fetch thing)))
     (goto mark)
done (goto (fetch continue))

; sweep
sweep (assign free '())
      (assign scan (-1+ (fetch memtop)))
slp (branch (negative? (fetch scan))
            end)
    (assign mark-flag
      (vector-ref (fetch the-marks)
                  (fetch scan)))
    (branch (= (fetch mark-flag) 1)
            unmk)
(perform
  (vector-set! (fetch the-cdrs)
               (fetch scan)
               (fetch free)))
(assign free (fetch scan))
(assign scan (-1+ (fetch scan)))
(goto slp)
unmk (perform
        (vector-set! (fetch the-marks)
                     (fetch scan)
                     0))
     (assign scan (-1+ (fetch scan)))
     (goto slp)
end
```

## 제어가 다 보이는 실행기

```

  Escher Pict     Digital     Query
      \           Logic        /
       \            |         /
        \           |        /
         `------.   ↓  ,----'
                  LISP
                   || Metacircular
                  LISP
```

이 절에서 만들 **숨김없이 드러낸 제어 실행기explicit-control evaluator**는 계산evaluation 과정에서 프로시저 호출procedure-calling과 인자 전달argument-passing의 작동 구조를 레지스터와 스택 연산을 써서 설명할 수 있다.

- 숨김없이 드러낸 제어 실행기는 보통의 컴퓨터 기계어와 비슷한 언어로 쓰인, Scheme 실행기의 구현으로 볼 수 있다. 이 실행기는 5.2절에서 만든 레지스터 기계 시뮬레이터로 돌릴 수 있다.

```
                                                  .---------------.
                                                  | PRIMITIVE OPS |
                                                  '---------------'
                                                /
     char .--------.  List Structure  .------. /
USER ~~~> | READER | ---------------> | EVAL |x
  ↑       '--------'                  '------' \
  |           |                                 \
  |           ↓                                  \
  |    .-----------------------.                 .-----------.
  |    | List Structure Memory |                 | PRINTER   |
  |    '-----------------------'                 '-----------'
  |                                                   |
  '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'
            character
```

### Register usage in evaluator machine

- EXP: 평가할 표현식
- ENV: 평가 환경
- FUN: 적용할 절차
- ARGL: 평가된 인수 목록
- CONTINUE: 다음에 이동할 위치
- VAL: 평가 결과
- UNEV: 임시 레지스터로 사용되는 표현식
- Sample evaluator-machine operations

cf) 레지스터 FUN, ARGL, UNEV 는 여러 기본 연산을 한데 합쳐 나타낸 복잡한 식(엮은 식)을 계산하는 데 쓴다.

```scheme
(assign val (fetch exp))

(branch
  (conditional? (fetch exp))
  ev-cond)

(assign exp (first-clause (fetch exp)))

(assign val
  (lookup-variable-value (fetch exp)
                         (fetch env)))
```

Contract that `eval-dispatch` fulfills

- EXP 레지스터는 평가할 표현식을 보유하고 있어야 합니다.
- ENV 레지스터는 해당 표현식을 평가할 환경을 보유하고 있어야 합니다.
- CONTINUE 레지스터는 다음에 이동할 위치를 보유하고 있어야 합니다.
- 결과는 VAL 레지스터에 남게 됩니다. 다른 모든 레지스터의 내용은 파괴될 수 있습니다.

Contract that `apply-dispatch` fulfills

- ARGL 레지스터는 인수 목록을 포함하고 있습니다.
- FUN 레지스터는 적용할 절차를 포함하고 있습니다.
- 스택의 맨 위는 다음에 이동할 위치를 보유하고 있습니다.
- 결과는 VAL 레지스터에 남게 됩니다. 스택은 팝됩니다. 다른 모든 레지스터의 내용은 파괴될 수 있습니다.

평가기에 재귀가 필요한 이유?

- 평가 과정 자체가 재귀적이기 때문입니다.
- 이것은 스택에 아무 것도 남지 않았다는 것을 의미합니다. 머신은 이제 같은 상태에 있으며, 단지 VAL 레지스터에 값이 있습니다. 이것은 어떤 하위 문제의 일부가 아닙니다. 되돌아갈 것이 없습니다.

### ITERATIVE PROCEDURE

- 이 시점에서 머신은 이터레이터라는 루프를 평가하는 것이 반복 팩토리얼이라는 것의 일부임을 기억하지 않습니다.
- 이제 원칙적으로 환경 프레임에서 누적이 발생하는지 물을 수 있는데, 답은 '예'입니다. 새로운 환경 프레임을 만들어야 하지만, 완료되면 보관할 필요가 없습니다. 그것들은 가비지 수집되거나 공간이 자동으로 재사용될 수 있습니다. 그러나 평가기의 제어 구조는 실제로 이 절차들이 반복 절차라는 것을 반영하고 있습니다.

### RECURSIVE PROCEDURE

- 반복 절차와 공간이 축적되는 재귀 절차의 차이점을 이해하기 위해 대비해보겠습니다.
- 그것을 어떻게 관리하고 있을까요? 그 이유는 평가기가 나중에 필요한 것만 저장하도록 설정되어 있기 때문입니다.
- 따라서 이 인터프리터가 매우 "똑똑한" 이유는 전혀 똑똑하지 않고, 단지 필요한 것만 저장하고 있기 때문입니다.
- 이 모든 상세한 내용들을 요약하면, 큰 프로그램의 세부 사항들입니다.
  - 그러나 주요 요점은 이것이 다른 프로그램을 번역하는 것과 개념적으로 다르지 않다는 것입니다.
    - 주요 아이디어는 이 범용 평가기 프로그램, 즉 메타-순환 평가기를 가지고 있고, 이것을 LISP로 번역하면 전체 LISP를 얻게 된다는 것입니다.
  - 두 번째 요점은 마법이 사라졌다는 것입니다. 이제 이 시스템 전체에는 더 이상 마법이 없어야 합니다.
    - 원칙적으로, 목록 구조 메모리가 어떻게 작동하는지 빼고는 모든 것이 매우 명확해야 합니다. 이는 나중에 다룰 것입니다. 그러나 이는 그렇게 어렵지 않습니다.
  - 세 번째 요점은 이러한 모든 꼬리 재귀가 평가가 다음 번에 필요한 것만 저장하는 것의 규율에서 비롯되었다는 것입니다.
    - 이는 우리가 서브루틴을 호출할 때 모든 레지스터를 저장하고 돌아올 필요가 없다는 것을 의미합니다.
    - 효율성을 걱정하는 것은 유용할 때가 있습니다. 평가기 머신의 핵심 부분에서 효율성을 고려하는 것은 큰 차이를 만들 수 있습니다.

## 번역compilation
