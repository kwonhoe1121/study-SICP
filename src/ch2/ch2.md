# 데이터를 요약해서 표현력을 끌어올리는 방법

## 데이터 요약(data abstraction) ~> wishful thinking

데이터 요약이란 '_판단을 한껏 미루자는 원칙principle of least commitment_'에 따라 프로그램을 설계하는 것이라 볼 수 있다.

1. 데이터를 만드는 부품(constructor)
2. 데이터를 쓰는 부품(selector)

```lisp
(define (linear-combination a b x y)
  (+ (* a x) (* b y)))
```

`+`, `*` -- compound data, data abstraction --> `add`, `mul`

```lisp
(define (linear-combination a b x y)
  (add (mul a x) (mul b y)))
```

> 사실 우리 언어에서는 묶음 데이터를 만들기 위해 따로 연산을 만들지 않더라도 프로시저만 있으면 복잡한 '데이터'를 얼마든지 나타낼 수 있다. 이런 까닭에, 벌써 1장 후반부부터 **'프로시저'와 '데이터'의 경계가 허물어지기 시작하는데, 이 장에서 그 경계가 더욱 흐릿해진다.**

기본 데이터 -- 프로시저, 데이터 --> 묶음 데이터

## 묶음 데이터(compound data)

### 데이터 구조

단순한 데이터를 모아 복잡한 데이터를 만들어 내는 데도 여러 방법이 있으며 이때 어떤 방법을 골라 쓰느냐에 따라 계산 프로세스가 잡아먹는 시간과 공간이 크게 달라진다.

- 차례열sequence 구조

```
(list ⟨a₁⟩ ⟨a₂⟩ … ⟨aₙ⟩)
```

```
(cons ⟨a₁⟩
      (cons ⟨a₂⟩
            (cons …
                  (cons ⟨aₙ⟩
                        nil)…)))
```

- 나무tree 구조

```
((1 2) 3 4)

(cons (list 1 2) (list 3 4))
```

```
      ((1 2) 3 4)
           |
    .------+------.
    |      |      |
  (1 2)    3      4
    |
 .--+--.
 |     |
 1     2
```

- 집합set 구조
  - 인터페이스
    - `union-set`, `intersection-set`, `element-of-set?`, `adjoin-set`
  - 자료 구조 표현 방식
    - unordered list - `O(n²)`
    - ordered list - `O(n)`
    - binary tree - `O(log(n))`

### 성질

- 닫힘 성질(closure property)
  - `cons` -> `cons`
- 공통 인터페이스(conventional interface)
  - list 인터페이스 연산: `range`, `map`, `filter`, `reduce`

## 일반화된 연산(generic operation)

서로 다른 타입 데이터(여러 방식으로 표현된 데이터)를 다룰 수 있도록 *일반화된 연산*을 만들어야 한다.

일반화된 연산 3가지 방식

1. 직접 나눠 맡기는 방식(explicit dispatch) - '똑똑한 연산'
2. 데이터 중심 방식 - '연산(가로축)', '타입(세로축)' 테이블
3. 메시지 패싱 방식 - '똑똑한 물체(타입별)'

### 데이터 중심으로 프로그램 짜는 법(data-oriented programming)

이 기법은 프로그램에서 데이터만 따로 놓고 이를 서로 다르게 표한한 다음, 이런 데이터 표현을 프로그램에 덧대어additively(즉, 가산적으로) 묶는 것이다.

- '수직' 경계
  - '세로로 그은' 추상화 경계는 한 데이터를 표현하는 데 여러 방식이 있을 수 있고 이를 따로 설계하거나 구현하여 덧붙여 넣을 수 있음을 알려준다.
- 일반화된 프로시저를 정의할 때 주로 쓰는 기법은, 데이터 속에 그 표현 방식을 알려주는 글귀로 '타입 표시type tag'를 붙여서, 프로시저가 그 표시를 읽고 그에 맞추어 데이터를 처리하도록 하는 것이다.

  - type dispatch: 데이터 흐름이 하위 계층으로 내려갈때.
  - type attach: 데이터 흐름이 상위 계층으로 올라갈때.

- 일반화된 연산, 곧 서로 다른 여러 데이터 타입 사이에 공통된 연산을 다룬다는 것이, *연산op-가로축*과 *타입type-세로축*을 두 축으로 하는 *이차원 표*를 다루는 것과 같다는 사실부터 깨우쳐야 한다.
  - `(put ⟨op⟩ ⟨type⟩ ⟨item⟩)`
  - `(get ⟨op⟩ ⟨type⟩)`
  - `apply-generic`: 표를 뒤져서 연산 이름과 인자 타입에 맞는 프로시저를 찾아낸 다음에 그 프로시저를 인자에 적용한다.

```lisp
(define (apply-generic op . args)
  (let ((type-tags (map type-tag args)))
    (let ((proc (get op type-tags)))
      (if proc
          (apply proc (map contents args))
          (error
            "No method for these types:
             APPLY-GENERIC"
            (list op type-tags))))))
```

### 메시지 패싱(message passing)

'똑똑한 연산'이 데이터 타입에 다라 일을 나누어 맡긴다고 보지 않고, '똑똑한 데이터 물체'가 연산 이름에 따라 일을 나누어 처리한다고 보는 방식

- 이는 표를 (타입에 다라) 세로줄로 쪼갤 때 세로 줄 하나에 데이터 물체 하나가 대응하는 것이라 하겠다.
- 데이터 물체가 연산 이름을 '메시지, 말' 처럼 받는다는 생각에서 비롯된 이름이다.

```lisp
(define (some-type-obj . args)
  (define (dispatch op)
    (cond ((eq? op 'message1) ...)
          ((eq? op 'message2) ...)
          ...
          (else (error "~~~" op))))
  dispatch)
```

```lisp
(define (apply-generic op arg) (arg op))
```

## 계층화 설계 방식 사용(abstraction barrier)

- **다층 설계stratified design**방식이라 일컫는 것으로, 단계별로 여러 언어를 쌓아올려서 복잡한 시스템을 층층이 짜맞추어 가는 방법이다.
- 한 층에서 만들어 낸 부품들은 차례로 그 다음 층에서 쓸 기본 부품들이 된다.
- 이에 따라, 다층 설계 방식에서는 층마다 그 표현 수준에 알맞은 1. '원시 요소', 2. '조합 수단', 3. '추상화 수단'이 갖추어져 있다.

- ex) 일반적인 산술 시스템 구조

```
                ADD SUB MUL DIV                    <---- GENERIC OPERATORS
==================================================
            ||   +,-,*,/complex  ||
            || ----------------- ||
   RATIONAL ||      COMPLEX      || ORDINARY NUMS
 ---------- || ----------------- || -------------
     +RAT   ||   +c -c *c /c     ||      +
     -RAT   || ================= ||      -
     *RAT   || REAL IMAG MAG ANG ||      *
     /RAT   || ================= ||      /
            ||  RECT  ||  POLAR  ||
            || ================= ||
==================================================
```
