# 언어를 처리하는 기법(metalinguistic abstraction)

프로그램 전문가가 복잡한 시스템을 설계하는 데 쓰는 기법이란, 곧 큰 눈으로 시스템의 구조를 바라보고 모듈 방식modularity을 잃지 않도록 설계하려 애쓰는 일임을 알게 되었다.

사실(풀어야 할 문제에 딱 들어맞는) 언어를 새로 만들어 쓰는 기술은 모든 공학에서 복잡한 설계 문제를 다루는 데 아주 뛰어난 방법이다.

- DSL(Domain-Specific Language) = 1. 기본원소 + 2. 조합수단 + 3. 추상화 수단

프로그램을 짠다는 것은 본디부터 갖가지 수많은 언어가 한데 어우러져 일어나는 일이다.

**언어를 처리하는 기법metalinguistic abstraction**, 곧 언어를 새로 만드는 방법은 새로 만든 언어의 이론적 체계를 입증하는 방법과 실제 그 언어의 실행기를 구현하는 방법을 아우른다. 여기서 프로그래밍 언어의 실행기evaluator(또는 해석기interperter)란, 그 언어로 적은 식을 입력으로 받아서 그 식을 실행하여 값을 계산하는 프로시저를 말한다.

그러므로 프로그램 분야의 가장 바탕이 되는 생각은 다음과 같다.

> "언어 실행기란, 프로그래밍 언어로 나타낸 식이 무엇을 뜻하는지 밝히는 것으로, 이 또한 그저 또 하나의 프로그램일 뿐이다."

이 말 뜻을 알아들었다는 것은 프로그램 짜는 사람이 누구인가에 대한 생각을 바꾼다는 것과 같다. **드디어 남이 설계한 언어를 받아서 쓰기만 하는 사람이 아니라 그런 언어를 스스로 설계하는 사람으로 자신을 바라보아야 할 시점에 이른 것이다.**

이렇게 바라보면, 큰 컴퓨터 시스템을 설계하는 기술과 컴퓨터 언어를 만드는 기술이 본디 하나임을 알게 되고, 더 나아가서 컴퓨터 과학 자체가 문제마다 그 풀이에 알맞은 표현 수단을 갖출 수 있도록 새 언어를 만들어 내는 분야에 지나지 않음을 깨닫게 된다.

- `Computer System = { <PL = DSL(문법) + evaluator(의미)> }`

이 장에서는 Lisp를 바탕언어로 삼아, 언어를 처리하는 Lisp 프로시저를 짜 볼 참이다. (사실 모든 언어 처리기processor에는 어딘가 깊숙한 곳에 조그만 'Lisp' 실행기가 들어 있다고 봐도 된다.)

## 메타써큘러 실행기(meta-circular evaluator)

처음에는 언어를 어떻게 만드는지 이해하기 위하여 lisp 언어 실행기를 lisp 으로 짠다 (Scheme의 부분집합). 이처럼 언어 실행기가 처리하려는 언어로 다시 그 실행기를 만들 때, 그런 실행기를 *메타써큘러metacircular 실행기*라고 한다.

- 환경 계산법 두 가지 규칙

  - (특별한 형태special form를 제외하고)식combination의 값을 구하려면, 부분 식의 값부터 모두 구해야 한다. 그런 다음에, 연산자(연산자에 해당하는 부분 식의 값, 곧 프로시저)를 피연산자(나머지 부분 식의 값)에 적용한다.
  - 프로시저를 인자에 적용하려면, 프로시저의 몸(식)을 계산하기 위하여 새 환경부터 만든다. 새 환경은, 인자 이름에 해당하는 인자 값을 찾아 쓸 수 있도록 새 (변수) 일람표를 만들어서 이미 있던 환경에다 덧댄 것이다.

- 위의 돌고 도는 두 규칙이 식의 값을 구하는 프로세스의 핵심이다. 이 규칙에 따라 어떤 식을 정해진 환경 속에서 계산하면, 프로시저를 인자에 적용하는 식이 나온다. 이런 계산 과정을 언어 실행기의 핵심 프로시저인 `eval`과 `apply`가 맞물려 돌아가는 모습으로 나타낼 수 있다.
- 식의 값을 구하는 프로세스는 `eval`과 `apply`라는 두 프로시저가 맞물려 돌아가는 것이라 볼 수 있다.

```
          proc, args
       ,-----------------.
      /                  ↓
  [ EVAL ]            [ APPLY ]
      ↑                 /
      '----------------'
           exp, env
```

### EVAL

- 언어 실행기의 구현 방식은 처리할 *식의 문법syntax*을 정의하는 프로시저에 따라 다르다. 이 책에서는 데이터를 요약하여 *언어 실행기*와 *언어의 표현 방식*을 따로 떼어내고자 한다.
- eval 함수는 프로그램의 한 1. 구성요소(component)와 2. 환경(env)을 받는다.
- 여기서 프로그램의 구성요소는 문장 아니면 표현식이다.
- eval 프로시저는 계산할 식의 문법을 갈래별로 따져보는 구조를 갖추고 있다.
  - 기본 식primitive expression
  - 특별한 형태special form
  - 엮은 식combination
    - lisp 시스템에는 언어 실행기를 고치지 않고도 프로그래머가 필요한 문법을 만들어 쓸 수 있도록, 엮은 식을 문법 변환기로 처리하는 기능이 있다. 이런 문법 변환 기능을 **매크로macro**라 한다.
    - ex) `cond->if`, `let->combination`

```txt
[SPECIAL FORM]
that's where the reserve words go.

number: 3 -> 3
symbol: x -> 3; car -> #[procedure]
quote : 'foo => (quote foo) -> foo
lambda: (lambda (x) (+ x y)) -> (closure ((x) (+ x y)) <env>)
                                          --- ------    ---
                   bound variable list  --'     `-body   `-- environment
cond: (cond (p₁ e₂) (p₂ e₂) ...)

[DEFAULT COMBINATION]
default being a general application of combination

(+ x 3)
```

#### Eval is a "Universal Machine"

```txt
      simulator
   6  .------. 720
 ---->| EVAL |---->
      '------'
        ↑
        | input
        /
       |
 n  .------. nl
--->| Fact |---->
    '------'
    description of another machine
```

- 간단한 프로시저로 구현한 언어 실행기에서 그보다 훨씬 복잡한 프로그램을 돌릴 수 있다는 사실, 만능 언어 실행기 기계(universal evaluator machine)가 있다는 점은 (컴퓨터) 계산의 깊고도 멋들어진 성질 가운데 하나다.
- Code is Data, Data is Code
  - 언어 실행기에는 프로그래밍 언어로 처리하는 데이터 객체와 그 프로그래밍 언어 자체를 이어주는 다리 구실을 한다
  - 프로그램을 언어 실행기(관점)에서 데이터로 본다

### APPLY

- apply 함수는 두 개의 인수를 받는다. 1.함수 2.(그 함수를 적용할)인수들의 목록
- apply 함수는 주어진 함수를 두 종류로 분류한다.
  - 1. 원시 함수(primitive function): `apply-primitive-function`을 호출해서 원시 함수를 적용한다.
  - 2. 복합 함수: 복합 함수의 본문 블록을 평가하되, 현재 환경에 함수의 매개변수들을 함수 적용의 인수들과 묶는 프레임을 추가해서 만든 새 환경에서 평가한다.

### BIND

```scheme
(define eval
  (lambda (exp env)
          (cond ((number? exp) exp)
                ((symbol? exp) (lookup exp env))
                ((eq? (car exp) 'quote) (cadr exp))
                ((eq? (car exp) 'lambda)
                 (list 'closure (cdr exp) env))
                ((eq? (car exp) 'cond)
                 (evcond (cdr exp env))
                 (else (apply (eval (car exp) env)
                              (evlist (cdr exp) env)))))))

(define apply
  (lambda (proc args)
          (cond ((primitive? proc)
                 (apply-primop proc args))
                ((eq? (car proc) 'closure)
                 (eval (cadadr proc)
                       (bind (caadr proc)
                             args
                             (caddr proc))))
                (else error))))

(define evlist
  (lambda (l env)
          (cond ((eq? l '()) '())
                (else
                  (cons (eval (car l) env)
                        (evlist (cdr l) env))))))

(define evcond
  (lambda (clauses env)
          (cond ((eq? clauses '()) '())
                ((eq? (caar clauses) 'else)
                 (eval (cadar clauses) env))
                ((false? (eval (caar clauses) env))
                 (evcond (cdr clauses) env))
                (else
                  (eval (cadar clauses) env)))))

(define bind
  (lambda (vars vals env)
          (cons (pair-up vars vals)
                env)))

(define pair-up
  (lambda (vars vals)
          (cond
            ((eq? vars '())
             (cond ((eq? vals '()) '())
                   (else (error TMA))))
            ((eq? vals '()) (error TFA))
            (else
              (cons (cons (car vars)
                          (car vlas))
                    (pair-up (cdr vars)
                             (cdr vals)))))))

(define lookup
  (lambda (sym env)
          (cond ((eq? env '()) (error UBV))
                (else
                  ((lambda (vcell)
                           (cond ((eq? vcell '())
                                  (lookup sym
                                          (cdr env)))
                                 (else (cdr vcell))))
                   (assq sym (car env)))))))

(define assq
  (lambda (sym alist)
          (cond ((eq? alist '()) '())
                ((eq? sym (caar alist))
                 (car alist))
                (else
                  (assq sym (cdr alist))))))
```

### PRACTICE

```scheme
(eval '(((lambda (x) (lambda (y) (+ x y))) 3) 4) e0)
```

```scheme
(apply (apply (eval '(lambda (x) (lambda (y) (+ x y))) e0)
                '(3))
        '(4))

(apply (apply '(closure ((x) (lambda (y) (+ x y))) e0)
                '(3))
        '(4))

(apply (eval '(lambda (y) (+ x y)) e1)
        '(4))

(apply '(closure ((y) (+ x y)) e1)
        '(4))

(eval '(+ x y) e2)

(apply (eval '+ e2))
       (evlist '(x y) e2))

(apply 'primop '(3 4))

7
```

```
                .---------------------.
e0 -----------> :  global environment :
                :                     :
                :  + - * / car cdr .. :
                '---------------------'
                              ↑
                      .--------------.
e1 -----------------> : x = 3        :
                      '--------------'
                      /       ↑
    [·, ·] ----------'        |
     ↓                .--------------.
(lambda (y) (+ x y))  : y = 4        : <---------- e2
                      '--------------'
```

### Y combinator

#### FIXED POINT

```scheme
(define expt
  (lambda (x n)
    (cond ((= n 0) 1)
          (else
            (* x (expt x (- n 1)))))))

F = (λ (g)
      (λ (x n)
        (cond ((= n 0) 1)
              (else
                (* x
                   (g x (- n 1))))))
```

#### **∴ (Y F) = (F (Y F))**

```txt
Y = (λ (f)
      ((λ (x) (f (x x)))
       (λ (x) (f (x x)))))

(Y F) = ((λ (x) (F (x x)))
         (λ (x) (F (x x))))
      = (F ((λ (x) (F (x x))) (λ (x) (F (x x)))))
           -------------------------------------
            바로 위의 단계와 같다.
            바로 위 단계에 F 를 한번 적용 한다.

∴ (Y F) = (F (Y F))
```

## Scheme 바꿔보기 - 제때 계산법(lazy evaluation)

바탕이 되는 언어(스킴)를 바꾸어서 더 깔끔한 방법으로 스트림 데이터 기법을 프로그래밍 할 수 있도록, *정의대로 계산법normal-order evaluation*을 적용한 실행기를 만든다.

- 보통 제때 계산법이라고 하면, call-by-need와 같이, 식의 값을 참말 쓸 때까지 계산하지 않고 미뤄두었다가 그 값을 처음 셈한 뒤 메모해 두는 것까지 아울러 일컫는 말이다.
- 이 방식은 3장에서 스트림의 표현 방식을 선보일 때 delay 한 물체에 force를 쓰던 것과 아주 비슷하다. 하나, 지금 여기서 하는 일은 언어 실행기 자체에 '미루고 강제하는' 기능을 집어넣어서, 언어 전체가 똑같은 계산 방식을 저절로 따르도록 만든다는 점에서 3장에서 한 일과는 큰 차이가 있다.

### '평가기 메커니즘' 용어 정리

| 언어의 의미론 관점 | 평가기의 메커니즘을 서술하는 관점 | 인수 평가 관점 | 비고                                                           |
| ------------------ | --------------------------------- | -------------- | -------------------------------------------------------------- |
| 정상 순서          | 느긋한                            | 비엄격         | 함수 인수들의 평가를 가능한 한 나중으로 미루는 것(최대한 전개) |
| 적용적 순서        | 인수 우선 평가                    | 엄격           | 함수 적용 시 인수 우선 평가                                    |

### APPLY

- 기본 프로시저: 프로시저를 적용하기 전에 모든 인자 값을 계산한다.
- 복합 프로시저: 모든 인자 계산을 뒤로 미룬 상태에서 프로시저를 적용한다.
  - 인자 계산을 뒤로 미루고 썽크를 짜맞추려면 환경이 필요하므로, apply에 환경 인자도 넘겨야 한다.

#### 썽크(thunk)의 표현

새 언어 실행기에서는 프로시저를 인자에 적용할 때 썽크를 만들기도 해야 하고 강제force도 해야 한다. 따라서 올바른 인자 값을 때맞춰 구할 수 있도록 식과 환경을 썽크로 묶어야 한다.

## Scheme 바꿔보기 - 비결정적 계산

한 언어에서 *비결정적 계산 방법nondeterministic computing*을 표현할 수 있으면, 식이 나타낼 수 있는 모든 값을 늘어놓고 그 가운데 조건에 맞아떨어지는 값을 찾아내는 프로세스를 자연스럽게 표현할 수 있다. 계산 모형과 시간의 관점으로 따져 보았을 때, 계산 과정의 한 시점에서 '앞으로 일어날 수 있는 일'을 모두 나뭇가지처럼 펼처놓고 그 가운데 알맞은 가지를 골라잡아 계산을 이어 가는 것과 같다.

```scheme
(define (prime-sum-pair list1 list2)
  (let ((a (an-element-of list1))
        (b (an-element-of list2)))
    (require (prime? (+ a b)))
    (list a b)))
```

`(amb ⟨e₁⟩ ⟨e₂⟩ … ⟨eₙ⟩)`

- 여기서 핵심이 되는 개념은, 비결정적 언어에서 한 식의 값을 셈할 때 그 값이 여러 개 나올 수 있다는 것이다.
- 간추려 생각하면, `amb` 식을 계산한다는 것은 시간을 여러 갈래로 나누는 것이라 볼 수 있다. 그리하여, 갈래마다 답이 될 수 있는 값을 하나씩 쥐고 계산이 진행된다. 다시 말해, `amb`는 *비결정적 선택 지점nondeterministic choice point*을 나타낸다고 말할 수 있다.
- 이 절에서 만들어서 돌려 보고자 하는 `amb` 언어 실행기는 _체계적으로 찾는systematically search_ 방법을 쓴다.
- 프로그래밍 언어에 저절로 (값을) 찾는 기능을 집어넣으려는 노력(~> Planner, Prolog)
  - search and automatic backtracking
  - depth-first search, chronological backtracking, dependency-directed backtracking

### 서로 다른 시간 개념

| 스트림 처리법                                                                                 | 비결정적 계산법                                                                                                 |
| --------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------- |
| 가능한 값들을 스트림으로 엮어내는 시점과 그 스트림 원소를 진짜로 만들어 내는 시점을 분리한다. | 시간이 여러 갈래로 나란히 뻗어나아가는 가운데, 프로그램 하나가 여러 실행 경로를 따라간다는 착각을 불러일으킨다. |
| 값을 어떻게 미루었다가 필요할 때 강제할 것인가 하는 고민에서 벗어날 수 있다.                  | 값을 어떻게 골라내느냐 하는 고민에서 자유로워 질 수 있다.                                                       |

## 논리로 프로그램 짜기

데이터 사이의 관계를 바탕으로 지식을 나타내는 *논리 프로그래밍logic-programming*언어를 만든다.

| CS     | Math    |
| ------ | ------- |
| How to | What is |

- 논리 중심 프로그래밍 언어는, (amb 실행기/제약 시스템) 여기서 한 발짝 더 나아가, 관계로 프로그램을 짠다는 생각에다 **동일화unification**이라는 **기호 패턴 매칭symbolic pattern matching**의 한 기법을 합쳐서 훨씬 편리하고 뛰어난 표현력을 제공한다.
- **특히, '무엇what is'을 밝히는 사실fact 하나를 가지고 수 많은 문제 풀이 속에서 서로 다른 '어떻게how to'를 표현해낼 수 있다는 게 뛰어난 점이다.**
- 논리 프로그래밍의 목표는, 프로그래머가 컴퓨터 계산 문제 하나를 두 문제로 나눠 다루는 기법을 쓸 수 있도록 해주는 데 있다.
  - 컴퓨터로 계산할 것이 '무엇인지(what)' 밝히는 문제
  - 컴퓨터에서 이를 '어떻게(how)' 계산할지 밝히는 문제
- 논리 프로그래밍 언어에서 프로시저를 짠다는 것은 규칙을 밝히는 것과 같다. 이때 '어떻게how to'에 관한 지식은 그 실행기가 저절로 제공한다.
- 논리 프로그래밍은 데이터베이스에서 정보를 찾아내는 일에 잘 들어맞는 인터페이스다.
- 규칙이란 논리적 함의logical implication의 한 가지라 할 수 있다. 즉, 규칙의 몸을 만족하도록 패턴 변수에 값을 집어넣는 방법이 있다고 하자. 그렇다면then 그 방법으로 결론을 만족할 수 있다. 결국, 쿼리 언어는 규칙에 바탕을 두고 *논리에 따라 연역식 추론logical deduction*을 해내는 능력을 갖춘 것이라 볼 수 있다.
- 그렇다고 하여 수학 논리와 쿼리 언어를 진짜로 같다고 볼 수는 없다. 왜냐하면 쿼리 언어는 (수학과 달리) 어떤 절차에 따라 논리식을 해석하는 *제어 구조control structure*를 갖추기 때문이다.
  - 시스템의 연역 과정에서 되돌아오지 못하는 길로 빠져드는 현상을 막아내는 데 딱히 믿을 만한 방법이 있을 수 없다.
  - `not` 과 관련된 문제들
    - 인자 몇 개가 정의되지 않았다면 Lisp 술어가 제대로 돌아가지 않는다.
    - 논리 프로그래밍 언어에서 `not`은 이른바 **닫힌 세계 가정closed world assumption**, 즉 데이터베이스에 관련 정보가 모두 들어 있다는 사실을 바탕으로 한다.

### 쿼리 언어에서 간단한 질문을 처리하는 과정

- 쿼리 시스템은 쿼리 패턴 속 여러 변수 자리에 그 패턴에 _맞아떨어지도록satisfy_ 값을 집어 넣는 방법을 모두 찾아낸다. 다시 말해, 패턴 변수에 넣을 수 있는 값의 집합이 여러 개 있고, 그 가운데 한 집합의 값으로 패턴 변수를 모두 *찍어낸instantiated*다음 (또는 맞바꾼 다음), 그렇게 얻어낸 데이터가 데이터베이스에 들어 있는 경우, 그런 값의 집합들만 추려낸다.
- 시스템은 쿼리 패턴에 맞아떨어지도록 값을 집어넣어서 정해진 쿼리 패턴에서 나올 수 있는 모든 데이터 패턴을 차례대로 보여준다.

```
          PROCEDURE
    x
--------> .---------.   ans
    y     : merge   : -------->
--------> .---------.

Not the program, the underlying rules of logic.

      LOGIC (RELATIONS)
  .---------------------.
  : merge-to-from       :
  :    x, y, z          :
  `---------------------'

```

### Logic Language DSL = 1. query + 2. compound query(and, or, not) + 3. rule

- PRIMITIVES - a primitive query

```scheme
(job ?x (computer programmer))
(job ?x (computer ?type)) ;; excat match
(job ?x (computer . ?type)) ;; like match
```

- MEANS OF COMBINATION - a compound query (`and`, `or`, `not`) = LOGICAL OPERATIONS

```scheme
(and (job ?x (computer . ?y))
     (supervisor ?x ?z))
(and (salary ?p ?a)
     (lisp-value > ?a 30000)) ;; lisp 원시 연산자 연결해서 사용
(and
  (job ?x (computer . ?y))
  (not (and (supervisor ?x ?z)
            (job ?z (computer . ?w)))))
```

- MEANS OF ABSTRACTION - `rule`

규칙에서 리스트의 `car`와 `cdr`를 가리키는 데 꼬리점 표기범을 어떻게 쓰는지 눈여겨 보자.

```scheme
;; if you know that the body of the rule is true, then you can conclude that the conclusion is true.
(rule ;; 1. rule 정의
  (bigshot ?x ?dept) ;; 2. rule conclusion
  (and ;; 3. rule body
    (job ?x (?dept . ?y))
    (not (and (supervisor ?x ?z)
              (job ?z (?dept . ?w))))))
```

### 쿼리 시스템의 동작 방식 - frame & stream

#### 패턴 매칭pattern matching - 쿼리query 구현

- 패턴 매처pattern matcher는 데이터가 지정된 패턴에 들어맞는지 알아보는 프로그램이다.
- 단순한 쿼리만 다루는 방식은 꽤 실용적이나, 복잡한 쿼리를 다루는 일은 지나치게 어렵다고 할 수 있다.

- BASIC MECHANISM (PRIMITIVE)

```
            (job ?x (?d . ?y))
                    |
                    |                 All MATCH DIC
      DIC           ↓         [?y=PROG ?x=... ?d=...] ...
   [?y=PROG]    .---------.   [?y=PROG ?x=... ?d=...] ...
--------------> :         : ------------->
                '---------'
                    ↑
                    |
                    |
                    |
                 DATA BASE
```

#### 동일화unification - 규칙rule 구현

- 패턴 두개를 받고, 그 변수 자리에 알맞은 값을 집어넣어서 두 패턴을 같게 만들 수 있는지 없는지를 판단한다.
- 동일화 알고리즘unification algorithm은 쿼리 시스템에서 쓰는 기술 가운데 가장 어려운 부분이다. 복잡한 패턴들을 동일화하는 과정에서는 연역 추론이 필요할 때가 있다. 이런 과정은 여러 패턴에 걸쳐 있는 방정식들을 한데 엮어 푸는 것아리 볼 수 있는데, 보통 이런 연립 방정식의 풀이 과정은 거쳐야 할 단계가 만만치 않다.

```
unify     (?x ?x)
with    ((a ?y c) (a b ?z))

          ?x : (a b c)
          ?y : b
          ?z : c
```

```
?x = (a ?y c)
?x = (a b ?z)
(a ?y c) = (a b ?z)
a = a, ?y = b, c = ?z
∴ ?x = (a b c)
```

1. 처음 스트림은 (패턴 매처를 가지고) 데이터베이스에 있는 모든 사실에 패턴을 맞추어 보는 과정에서 확장된 frame들의 스트림이다.
2. 두 번째는 (동일화 함수를 가지고)쓸 수 있는 모든 규틱을 적용하는 과정에서 확장된 frame들의 스트림이다.

- ∴ 추상화된 복합 요소 평가 방법: 표현식을 평가해서 환경을 확장시킨다. -> 확장된 환경을 기준으로 본문을 평가한다.

| 언어  | 평가       | 적용        | 추상화 수단 | 환경  | 적용 과정                                                                                   |
| ----- | ---------- | ----------- | ----------- | ----- | ------------------------------------------------------------------------------------------- |
| Lisp  | eval       | apply       | 함수 정의   | env   | 1. 함수 인수(표현식) 평가 후 환경 확장. <br>2. 확장된 환경 기준으로 함수 본문 표현식 평가   |
| query | eval_query | apply_query | 규칙 정의   | frame | 1. 질의와 규칙의 결론을 통합 후 프레임 확장. <br>2. 확장된 프레임 기준으로 규칙의 본문 평가 |
