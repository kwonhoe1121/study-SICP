# 모듈, 물체, 상태

무엇보다 '자연스럽게' 시스템을 여러 부품으로 따로 만들어서 다듬을 수 있도록, 관련된 정의들을 따로 모아 포장하는 방법, 곧 *모듈 방식modular*에 따라 큰 시스템을 구성할 줄 알아야 한다.

## 두 가지 설계 방법

*시간*을 어떤 관점으로 바라보느냐에서 비롯된다.

- '물체', '변화', '독자성' 같이 다루기 어려운 개념은 모두 프로그램 실행 중에 시간 흐름을 어떻게 나타내느냐 하는 문제에서 비롯된 것이다.

### 물체 Object

- 한 물체의 성질이 시간에 따라 변화할 수 있는데, 변화 하더라도 그 물체는 같은 이름으로 부를 수 있어야 한다.

### **환경 계산법environment model of computation**

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

```
(set-car! <pair> <pair>)
(set-cdr! <pair> <pair>)
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

- 프로시저를 인자에 적용하기 위해서는, 먼저 *새 환경*을 반들고 그 환경 속에서 인자 값으로 건네받은 인자를 정의한다.
- **프로시저가 인자를 받으면, 새 환경이 생긴다.** 새 환경을 둘러싸는 환경은 프로시저 객체가 가리키던 환경이다.
- 부분식을 계산하고 나서, 그 값은 이어지는 계산 과정으로 넘어간다.

### 스트림 Stream

- 끝없이 정보가 흘러간다는 개념(stream)을 빌어 시간에 따라 달라지는 정보를 나타낼 때에는, 그 시간과 컴퓨터 계산 차례는 아무런 관계가 없다.

### **셈미룸 계산법delayed evaluation**
