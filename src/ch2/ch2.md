# 데이터를 요약해서 표현력을 끌어올리는 방법

## 데이터 요약(data abstraction)

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

### 성질

- 닫힘 성질(closure property)
- 공통 인터페이스(conventional interface)

## 일반화된 연산(generic operation)

서로 다른 타입 데이터를 다룰 수 있도록 *일반화된 연산*을 만들어야 한다.

### 데이터 중심으로 프로그램 짜는 법(data-oriented programming)

이 기법은 프로그램에서 데이터만 따로 놓고 이를 서로 다르게 표한한 다음, 이런 데이터 표현을 프로그램에 덧대어additively(즉, 가산적으로) 묶는 것이다.

- 계층화 설계 방식 사용(abstraction barrier)
