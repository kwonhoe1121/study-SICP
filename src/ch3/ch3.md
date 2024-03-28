# 모듈, 물체, 상태

무엇보다 '자연스럽게' 시스템을 여러 부품으로 따로 만들어서 다듬을 수 있도록, 관련된 정의들을 따로 모아 포장하는 방법, 곧 *모듈 방식modular*에 따라 큰 시스템을 구성할 줄 알아야 한다.

## 두 가지 설계 방법

*시간*을 어떤 관점으로 바라보느냐에서 비롯된다.

- '물체', '변화', '독자성' 같이 다루기 어려운 개념은 모두 프로그램 실행 중에 시간 흐름을 어떻게 나타내느냐 하는 문제에서 비롯된 것이다.

### 물체 Object

- 한 물체의 성질이 시간에 따라 변화할 수 있는데, 변화 하더라도 그 물체는 같은 이름으로 부를 수 있어야 한다.
- Lisp에서 물체의 '독자성'은 `eq?`로 알아낼 수 있는 성질, 곧 포인터가 같으냐 다르냐를 따지는 것에 지나지 않는다.
- 변수 값을 덮어쓴다는 것은 환경을 고쳐 쓴다는 말과 같다. 다시 말해, 환경 자체가 변형 가능한 데이터 구조다.

#### **환경 계산법environment model of computation**

```
        ---------
              (1)
        x = 3
        y = 5
        ---------
        ↑   ↑
      C |   `-----. D
        |         |
---------         ---------
      (2)               (3)
z = 6             m = 1
x = 7             y = 2
---------         ---------
 |                  |
 A                  B
```

#### ENVIRONMENT MODEL

```
(set! ⟨name⟩ ⟨new-value⟩)
(begin ⟨exp₁⟩ ⟨exp₂⟩ … ⟨expₖ⟩)
```

#### BOUND VARIABLES

- `∀x ∃y P(x,y)`
- `(λ (y) ((λ (x) (* x y)) 3))`

#### Free Variables

- `(λ (x) (* x y))`: y is free variable
- `(λ (y) ((λ (x) (* x y)) 3))`: \* is free variable

#### Scope

```
(λ (x) (* x y))
        -----
        scope of x
(λ (y) ((λ (x) (* x y)) 3))
               ------
               scope of x
        -----------------
        scope of y
```

#### Procedure

##### 프로시저 생성

- 어떤 환경에서 `lambda` 식을 계산하면 새 프로시저 객체가 나온다. 이 객체는 코드와 환경 꼬리를 쌍으로 묶어 만들어진다. 꼬리가 가리키는 환경은 `lambda` 식의 값을 구할 때 쓴 환경이다.

```
  A
----> [·][·]
       |  |
       ↓  ↓
       C  B
```

- A is (a pointer to) a PROCEDURE OBJECT.
- B is (a pointer to) an environment.
- C is the code of the procedure.

```
[define ~> lambda expression -- evaluate --> procedure object]

procedure object := <code, env>
code := <parameters, body>
```

##### 프로시저 적용

- 프로시저를 인자에 적용하기 위해서는, 먼저 *새 환경*을 만들고 그 환경 속에서 인자 값으로 건네받은 인자를 정의한다.
- **프로시저가 인자를 받으면, 새 환경이 생긴다.** 새 환경을 둘러싸는 환경은 프로시저 객체가 가리키던 환경이다.
- 부분식을 계산하고 나서, 그 값은 이어지는 계산 과정으로 넘어간다.

#### 상태 자료구조

```
(set-car! <pair> <pair>)
(set-cdr! <pair> <pair>)
```

`set-car!`와 `set-cdr!`로 쌍을 고쳐 쓸 수 있으면 `cons`, `car`, `cdr`로는 만들지 못하던 여러 데이터 구조를 표현할 수 있다.

- 큐(queue): `queue := <front-ptr, rear-ptr>`
  - 실행 순서가 중요한 경우.
- 테이블(table)
  - 캐시, 메모화(memoization):
    - 먼저 어떤 프로시저 속에 표를 숨긴 다음, 이 프로시저를 적용하고 얻은 값을 이 표에다 메모한다. 이때 표에서 값을 찾는 키는 인자다.

```txt
table := (list <*table*(dummy)> <record1> <record2> ... )
records := (cdr table)
record := (cons key value)
```

#### 상태 시스템

- 디지털 회로 시뮬레이터
  - 실행 순서가 중요함. 계산 방향이 한 쪽으로 흐르는 시스템
- 관계 시스템
  - 계산 방향이 양방향으로 흐르는 시스템

### 동시성: 시간은 중요하다.

- 상태가 바뀔 때마다 그 시간의 변화(시점)를 나타낸다.
- 물체가 시간에 따라 달라지는 상태를 가지게 되면서 물체의 *같음*과 *달라짐*에 얽힌 복잡한 문제가 생겨난다.
- 사실 실제 물체들을 살펴보면, 그 상태가 한번에 하나씩 차례로 바뀌는 게 아니라, _병행으로concurrently_ 바뀐다.
- 병행처리를 한다는 사실 자체가 시간 개념을 더 복잡하고 이해하기 어려운 문제로 만들 수 밖에 없다.
- 이렇게 문제가 복잡해진 까닭은, 변수 하나에 여러 프로세스가 값을 덮어쓰려고 하는 데 있다.

#### 동시성을 다스리는 방법 - 줄 세우개serializer

1. 여러개의 연산이 같은 시간에 돌아가지 않게끔 한다. (락)
2. 여러 프로세스가 어떤 정해진 차례대로 돌아가는 것처럼 해서, 병행 시스템이 같은 결과를 만들어 내게끔 보장한다.

- 프로세스를 차례대로 돌려야한다는 조건은 아니지만, 차례대로 돌아가는 것과 결과가 같기만 하면 된다.
- 병행 프로그램의 '올바른' 결과는 여러 개일 수 있다.

한 상태를 여럿이 같이 쓸 때 그 차례를 정하는 방법

- 더 정확히 말해서, 줄을 세운다는 말은 프로시저들을 여러 그룹으로 나누고 같은 그룹에 속하는 프로시저들이 동시에 실행되는 일이 없도록 하는 것이다.

### 스트림 Stream

- 끝없이 정보가 흘러간다는 개념(stream)을 빌어 시간에 따라 달라지는 정보를 나타낼 때에는, 그 시간과 컴퓨터 계산 차례는 아무런 관계가 없다.
- 시간에 따른 시스템의 변화(상태)를 모두 차례열에 담아서, 상태 변화를 흉내내는 방법

```txt
순차열
|- 목록 list := <head, tail>
`- 스트림 stream := <head, promise>
```

#### **셈미룸 계산법delayed evaluation**

- *리스트*와 _스트림_ 둘 다 차례열 데이터를 요약했다는 점은 같지만, 그 원소를 언제 계산하는지가 다르다. 다시 말해서, 리스트에서는 리스트를 만들 때 `car`와 `cdr`를 모두 계산하지만, 스트림에서는 `cdr`를 뽑아 쓸 때 `cdr`를 계산한다.
- 스트림 프로세스의 각 단계에서는 다음 단계에서 쓸 만큼만 계산을 하게 된다.
- 어떤 계산 시점에서 스트림의 원소가 필요한 만큼 계산되어 있어서 다시 그 스트림을 다음 계산을 하는 정의속으로 집어넣을 수 있다.

```txt
[stream]
data-abstraction := cons-stream, stream-car, stream-cdr, stream-null?
evaluation := delay, force

stream structure

.----------.    .---------.
| item | · | -> | promise |
'----------'    '---------'

* A promise to generate the list. And by promise, technically I mean procedure. So it doesn't get built up.

(cons-stream x y)
abbreviation for  (cons x (delay y))
(head s) -> (car s)
(tail s) -> (force (cdr s))

(delay <exp>)
abbreviation for (lambda () <exp>) || (memo-proc (lambda () <exp>))
(force p) = (p)
```

##### 무한 스트림

- 에라스토스테네스의 체

```lisp
(define (sieve stream)
  (cons-stream
   (stream-car stream)
   (sieve (stream-filter
           (lambda (x)
             (not (divisible?
                   x (stream-car stream))))
           (stream-cdr stream)))))
```

```sh
    ,-------------------------------------------------.
    | sieve                                           :
    |                                                 |
    |         head                                    :
    |   ,---.-----------.------------------>.------.  |
-->-:--*    |           ↓                   | cons |--:->
    |   `---'--->-,-----------.             |      |  |
    |        tail | filter:   :-->[sieve]-->`------'  :
    |             | not       |                       |
    |             | divisible?|                       :
    |             `-----------'                       |
    `-------------------------------------------------'
```
