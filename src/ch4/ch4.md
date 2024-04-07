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

## Scheme 바꿔보기 - 비결정적 계산

한 언어에서 *비결정적 계산 방법nondeterministic computing*을 표현할 수 있으면, 식이 나타낼 수 있는 모든 값을 늘어놓고 그 가운데 조건에 맞아떨어지는 값을 찾아내는 프로세스를 자연스럽게 표현할 수 있다. 계산 모형과 시간의 관점으로 따져 보았을 때, 계산 과정의 한 시점에서 '앞으로 일어날 수 있는 일'을 모두 나뭇가지처럼 펼처놓고 그 가운데 알맞은 가지를 골라잡아 계산을 이어 가는 것과 같다.

## 논리로 프로그램 짜기

데이터 사이의 관계를 바탕으로 지식을 나타내는 *논리 프로그래밍logic-programming*언어를 만든다.
