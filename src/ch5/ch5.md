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
  - Scheme 프로그램 --> interperter(기계어 프로그램 by 레지스터 기계 DSL(=~ 기계어)) --> interpret
- 5.5절에서 만드는 번역기는 Scheme으로 짠 프로그램을 레지스터 기계로 만든 실행기에서 바로 실행되는 명령어들로 번역한다.
  - Scheme 프로그램 -- compile --> 오브젝트 프로그램(by 레지스터 기계 DSL(=~ 기계어)) --> execute

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

```txt
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

> "언어 실행기란, 프로그래밍 언어로 나타낸 식이 무엇을 뜻하는지 밝히는 것으로, 이 또한 그저 또 하나의 프로그램일 뿐이다."

```txt
| Scheme 프로그램 - by Scheme                                          |
|----------------------------------------------------------------------|
| 명시적 제어 평가기(해석기) - by Scheme (레지스터 기계DSL 작성)       |
|----------------------------------------------------------------------|
| 시뮬레이터(가상머신) - by Scheme (레지스터 기계DSL 실행기)           |
|----------------------------------------------------------------------|
| Scheme 해석기                                                        |
'----------------------------------------------------------------------'
```

```txt
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
- FUN(PROC): 적용할 절차
- ARGL: 평가된 인수 목록
- CONTINUE: 다음에 이동할 위치(재귀를 구현하는데 사용-부분식 계산)
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
- 결과는 VAL 레지스터에 남게 됩니다. 다른 모든 레지스터의 내용은 삭제될 수 있습니다.

Contract that `apply-dispatch` fulfills

- ARGL 레지스터는 인수 목록을 포함하고 있습니다.
- FUN 레지스터는 적용할 절차를 포함하고 있습니다.
- 스택의 맨 위는 다음에 이동할 위치를 보유하고 있습니다.
- 결과는 VAL 레지스터에 남게 됩니다. 스택은 팝됩니다. 다른 모든 레지스터의 내용은 삭제될 수 있습니다.

### ITERATIVE PROCEDURE

- `eval-dispatch`가 처리 시작점entry point으로 돌아오도록 `continue`값을 설정하고 스택에서 `continue` 값을 가져와 처리를 계속하기 보다는, `eval-dispatch`로 가기 전에 스택에서 `continue`를 가져온다.
- 식 시퀀스의 마지막 식을 계산하기 위해 스택에 어떤 정보도 저장하지 않고 바로 `eval-dispatch`로 옮겨가기 때문. 그러므로 시퀀스의 마지막 식을 계산할 때 어떤 정보도 스택에 쌓지 않는다.
- 이렇게되면 `eval-dispatch`가 식을 계산한 다음에 그 시점부터 계속 진행할 수 있다.
- ∴ **요점은 이러한 모든 꼬리 재귀가 평가가 다음 번에 필요한 것만 저장하는 것의 규율에서 비롯되었다는 것입니다.**
  - 이는 우리가 서브루틴을 호출할 때 모든 레지스터를 저장하고 돌아올 필요가 없다는 것을 의미합니다.

```scheme
ev-sequence-last-exp
  (restore continue) ; 꼬리 재귀가 가능하도록 하는 부분.
  (goto (label eval-dispatch)) ;
```

## 번역compilation

- 고수준 언어와 레지스터 기계어의 틈을 메우는 두 가지 전략(interpretation, compilation)

```txt
program/code/text
|
|<-- parse()
|
`-- AST/some data structure
    |
    |`--> interpret by explicit-control-evaluator ∴ 1. strategy of interpretation
    |
    |<-- compile()
    |
    `-- ObjectCode (linear structure)
        |
        `--> execute by explicit-control-evaluator ∴ 2. strategy of compilation
```

### INTERPRETATION

- 해석될 프로그램(소스 프로그램)은 데이터 구조(AST)로 표현된다. 실행기는 이 데이터 구조를 따라 움직이며 소스 프로그램을 분석한다. 이렇게 하면서 실행기는 라이브러리에서 적절한 기본 서브루틴을 불러와 소스 프로그램이 실행해야 할 동작을 시뮬레이트 한다.

```txt
      .-----------------------------------.
      : LISP INTERPRETER                  :
      :                                   :
      :     .---------------------.       :
      :     : REGISTER LANGUAGE   :       :
      :     :     INTERPRETER     :       :
      :     '---------------------'       :
  5   :         /            \            :  120
----> :        /              \           : ----->
      : .----------------.  .---------.   :
      : : (assign val    ;  : LIBRARY :   :
      : :   (fetch exp)) :  '---------'   :
      : '----------------'  primitive op  :
      : explicit-control-eval             :
      :                                   :
      '-----------------------------------'
            /
           /
      .------------------.
      : (define (fact n) :
      :   (if ...))      :
      '------------------'
```

### COMPILATION

- 대개 번역기는 소스 프로그램을 오브젝트 프로그램으로 바꾸는데, 오브젝트 프로그램은 소스 프로그램을 실행하는 데 실행기가 했던 레지스터 연산과 본질적으로 같은 레지스터 연산을 한다.
- 실행기가 식을 계산하는 데 수행할 레지스터 명령을 바로 수행하는 대신 명령을 모아 일렬로 쌓아 놓을 수 있다. 결국 이렇게 모인 명령어들이 오브젝트 코드가 될 것이다.
- 번역기를 쓰면 번역 시에 명령문들이 만들어질 때 식은 한번만 분석된다.
  - 레지스터와 스택 최적화. 불필요한 스택 연산을 피하는 코드를 만들어 낼 수 있다.
  - 환경에 대한 접근을 최적화할 수 있다. 코드를 분석한 후 번역기는 변수가 어떤 변수 frame에 들어 있는지 아는 경우가 많아서 `lookup-variable-value`에서 찾지 않아도 변수에 바로 접근할 수 있다.
- 실제로 우리가 만들 컴파일러는 컴파일된 코드와 인터프리터 코드가 서로 호출할 수 있도록, 컴파일러가 인터프리터와 동일한 레지스터 규칙을 사용하도록 할 것입니다.

```txt
  .----------------.
  : DEFINE         :  SOURCE CODE   .----------.
  : (fact n ...)   : -------------> : COMPILER :
  '----------------'                '----------'
                                        /
                          OBJECT CODE  / TRANSLATE INTO REGISTER LANGUAGE
                                      /
                                     ↓
                            .-----------.
                            : ASSIGN    :
                            :  VAL .... :
                            '-----------'
                              /
                             ↓
                    .----------.
                    : LINKER/  : LOAD MODULE
                    : LOADER   :
                    '----------'
                       ↑    \
                      /      `--> .-------------.
        .---------.--'        5   : REGISTER    :  120
        : LIBRARY :         ----->: LANGUAGE    : ----->
        '---------'               : INTERPRETER :
                                  '-------------'
```

#### COMPILER STRUCTURE

- 4.1.7절에서 쓴 방법처럼 프로그램을 분석한다. 하지만 실행 프로시저를 만드는 것이 아니라 레지스터 기계로 돌리는 명령들을 만들 것이다.

```scheme
;; linkage := <next, return, label>
(assign val (const 5)) ; next
(goto (reg continue)) ; return
(goto (reg <linkage>)) ; label

;; Instruction sequences and stack usage (AOP) ~> target register
(append-instruction-sequences ⟨seq₁⟩ ⟨seq₂⟩) ; independent regs
(preserving (list ⟨reg₁⟩ ⟨reg₂⟩) ⟨seg₁⟩ ⟨seg₂⟩) ; dependent regs (=> add save, restore)

; instruction := <needs, modifies, statements>
(define (make-instruction-sequence needs modifies statements)
  (list needs modifies statements))
```

- 레지스터 최적화를 수행하는 방법은 어떤 것들이 보존되어야 하는지에 대한 전략을 갖는 것입니다.

```txt
(op a₁ a₂)
---> ... compile ...

{compile op; result in fun}                     ↓ preserving env

{compile a₁; result in val}                     |                  |
(assign argl (cons (fetch val) '()))            ↓ preserving env   |
                                                                   | preserving fun
{compile a₂; result in val}                     ↓ preserving argl  |
(assign argl (cons (fetch val) (fetch argl)))                      ↓

(go to apply-dispatch)
```

- 이 아이디어는 한 레지스터를 보존하는 데 주의하면서 두 코드 시퀀스를 추가하는 것입니다.
- 이는 무엇을 함께 놓는다는 것이 무엇을 의미하는지에 따라 달라집니다. 어떤 것을 보존하는 것은 이러한 코드 조각들이 어떤 레지스터를 필요로 하고 수정하는지 아는 것에 달려 있습니다.
  - 모든 덮어쓰기assignment 명령은 모두 target 레지스터를 고치고modify, 변수를 참조하는 명령은 env 레지스터를 요구need한다.

```txt
append seq1 and seq2 preserving reg

if seq2 needs reg
and seq1 modifyes reg
→
(save reg)
<seq1>
(restore reg)
<seq2>

ohterwise
→
<seq1>
<seq2>
```

- 이러한 관점에서 보면, 인터프리터와 컴파일러의 차이점은 어떤 면에서는 컴파일러가 보존해야 할 지점을 알고, 필요하다면 저장과 복원을 실제로 생성할지 아니면 그렇지 않을지를 결정할 수 있다는 점입니다. 반면, 인터프리터는 최대한 비관적으로 접근하여 항상 저장과 복원을 여기에 둡니다. 이것이 본질적인 차이점입니다.
- 이것이 컴파일러가 이 작업을 수행하기 위해 참조하는 정보입니다.
  이 작업은 작은 데이터 구조를 갖추고 있다는 점에 달려 있습니다. 여기서 코드 시퀀스는 실제 명령과 그것이 수정하고 필요로 하는 것이 무엇인지를 나타냅니다. 이는 기본 수준에서 이를 구축하는 것에서 나옵니다.
- 기본 수준에서는 어떤 것이 무엇을 필요로 하고 수정하는지가 완전히 명확할 것입니다. 또한, 이것은 다음과 같은 특정 방식으로 구성됩니다. 더 큰 코드 시퀀스를 구축할 때, 수정된 레지스터의 새로운 집합과 필요한 레지스터의 새로운 집합을 생성하는 방법입니다.

```txt
<sequence of inst; set of registers modified; set of regs needed>

<(assign r₁ (fetch r₂)); {r₁}; {r₂}>

<s₁;m₁;n₁> and <s₂;m₂;n₂>
→
s₁; m₁ union m₂; n₁ union [n₂ - m₁]
and
s₂
```

### Applying compiled procedures

- `compile-proc-appl`는 호출하는 타깃이 `val`인지 아닌지, 연결이 `return`인지 아닌지 등 네 가지 경우를 고려해 아래의 프로시저 계산 코드를 나타낸다.

#### RECURSIVE

- `val`이 target register가 아닌 경우.

```txt
; 연결이 label일 경우
 (assign continue (label proc-return))
 (assign val (op compiled-procedure-entry) (reg proc))
 (goto (reg val))
proc-return
 (assign ⟨target⟩ (reg val))   ; included if target is not val
 (goto (label ⟨linkage⟩))   ; linkage code
```

```txt
; 연결이 return일 경우
 (save continue)
 (assign continue (label proc-return))
 (assign val (op compiled-procedure-entry) (reg proc))
 (goto (reg val))
proc-return
 (assign ⟨target⟩ (reg val))   ; included if target is not val
 (restore continue)
 (goto (reg continue))   ; linkage code
```

#### ITERATIVE

- `val`이 target register인 경우
- 그렇지만 보통 타깃은 `val`이다. (번역기가 다른 레지스터를 지정하는 유일한 경우는 타깃이 `proc`일 때뿐이다.)
  - 타깃이 `proc`일 때는 함수를 재귀적으로 호출할때이다.
- 따라서 프로시저 결과는 타깃 레지스터에 바로 들어가며 그 내용을 복사해 놓은 특정 위치로 돌아갈 필요가 없다. 그 대신 프로시저가 호출자의 연결caller's linkage로 바로 '돌아가도록'continue를 설정하는 것으로 코드를 간단하게 만든다.
- ∴ 프로시저 인자, 내부 변수를 저장하는데만 스택을 사용한다. 리턴 주소를 저장하는데에는 스택을 사용하지 않는다.

```txt
; 연결이 label일 경우
(assign continue (label ⟨linkage⟩))
(assign val (op compiled-procedure-entry) (reg proc))
(goto (reg val))
```

```txt
; 연결이 return일 경우
; - 전혀 continue를 둘 필요가 없다. 이미 지정한 번지를 갖고 있기 때문이다.
(assign val (op compiled-procedure-entry) (reg proc))
(goto (reg val))
```
