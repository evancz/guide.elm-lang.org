# 함수언어 살펴보기

이 단원에선 간단하게 Elm을 살펴볼거에요.

여러분이 따라서 해보는 방법이 가장 좋으실 거에요. [설치](install.md) 부분을 마치신 뒤 , `elm-repl`을 터미널에서 실행하세요. \(또는 [온라인 REPL](http://elmrepl.cuberoot.in/)을 사용하세요\) 어떤 방법으로 하셨든 여러분은 다음과 같은 걸 보실 수 있을 거에요.

```elm
---- elm repl 0.18.0 -----------------------------------------------------------
 :help for help, :exit to exit, more at <https://github.com/elm-lang/elm-repl>
--------------------------------------------------------------------------------
>
```

REPL은 모든 결과마다 타입을 설명해주지만, 이 튜토리얼에서는 점차적으로 개념을 소개하기 위해 **해당 기능이 없는 생태로 진행할 거에요. **

우리는 [값\(values\)](#values), [함수\(functions\)](#functions), [리스트\(lists\)](#lists), [튜플\(tuples\)](#tuples), 그리고 [레코드\(records\)](#records)에 대해 배워볼텐데요. 이 부분들의 구조는 JavaScript, Python, Java와 비슷한 구조를 가지고 있어요.

## 값\(values\)

일단 문자열\(strings\)부터 시작해봅시다.

```elm
> "hello"
"hello"

> "hello" ++ "world"
"helloworld"

> "hello" ++ " world"
"hello world"
```

Elm은 `(++)` 연산자를 사용해 문자열을 합쳐요. 두개의 문자열은 해당 형태를 유지하면서 정확하게 합쳐지기 때문에, `"hello"`와 `"world"` 를 합친 결과는 공백이 없습니다.

수학도 일반적으로 동작합니다.

```elm
> 2 + 3 * 4
14

> (2 + 3) * 4
20
```

JavaScript와는 다르게 Elm은 부동소수점과 정수와는 차이가 있습니다. Python3 처럼 부동소수점 연산자인 `(/)` 와 정수 연산자 `(//)`가 존재합니다.

```elm
> 9 / 2
4.5

> 9 // 2
4
```

## 함수\(Functions\)

자 이제 함수를 작생해 봅시다. `isNegative` 함수는 숫자를 받아서 해당 숫자가 0보다 작은지를 확인하고, True 또는 False가 결과가 될 거에요.

```elm
> isNegative n = n < 0
<function>

> isNegative 4
False

> isNegative -7
True

> isNegative (-3 * -4)
False
```

함수 어플리케이션이 JavaScript와 Python, Java 등과는 다르게 보이네요. 괄호를 사용해 모든 인자들을 감싸서 콤마\(comma\)로 구분하는 대신에,  공백을 통하여 함수를 적용하죠. 그래서 `(add(3,4))` 은 `(add 3 4)` 로 표현되어 더 많은 공백과 콤마를 피할 수 있게 됩니다. 궁극적으로는, 익숙해지면 훨씬 깔끔해 보이죠! [elm-html 패키지](http://elm-lang.org/blog/blazing-fast-html) 는 이 방법이 좀 더 가벼운 느낌이 든다는 걸 보여주는 좋은 예제에요.

## If 표현식\(If Expressions\)

만약 Elm에서 조건문 같은 걸 사용하고 싶다면, if 표현식을 사용하세요.

```elm
> if True then "hello" else "world"
"hello"

> if False then "hello" else "world"
"world"
```

키워드인 `if` `then` `else` 등을 사용하여 각 조건별로 분기 처리 할 수 있고, 소괄호\(parentheses\)나 중괄호\(curly braces\) 등을 쓸 필요가 없죠.

Elm에선 True로 분류되는 값 이란 개념이 없습니다. 따라서 숫자\(numbers\)와 문자열, 리스트 등을 boolean 값으로 사용할 수 없어요. 만약 이런 짓을 한다면,  Elm은 boolean 값이 필요하다고 알려줘요.

자 이제 9000이 넘는 숫자인지 알려주는 함수를 만들어 봅시다.

```elm
> over9000 powerLevel = \
|   if powerLevel > 9000 then "It's over 9000!!!" else "meh"
<function>

> over9000 42
"meh"

> over9000 100000
"It's over 9000!!!"
```

REPL에선 역슬래시\(\\)를 이용하여 여러줄로 동작을 분리할 수 있습니다. 이를 통해 `over9000` 이라는 함수를 선언할 수 있었죠. 또한, 이렇게 함수 선언부 아래에 내용을 적는 것은 가장 추천하는 방법이에요. 형식을 맞춰 쓰면 읽기도 쉽죠. 일반적인 코드에서도 모든 함수와 값들을 이런식으로 선언할 수 있죠.

## 리스트\(Lists\)

리스트는 Elm에서 가장 일반적인 자료구조 중 하나에요. 연속적인 관계를 가진 것들을 담으며, JavaScript의 배열\(array\)과 비슷해요.

리스트는 많은 값들을 담을 수 있지만, 이 값들은 같은 타입을 가지고 있어야 해요. 다음은[ `리스트` 라이브러리](http://package.elm-lang.org/packages/elm-lang/core/latest/List)를 이용한 몇가지 예제입니다.

```elm
> names = [ "Alice", "Bob", "Chuck" ]
["Alice","Bob","Chuck"]

> List.isEmpty names
False

> List.length names
3

> List.reverse names
["Chuck","Bob","Alice"]

> numbers = [1,4,3,2]
[1,4,3,2]

> List.sort numbers
[1,2,3,4]

> double n = n * 2
<function>

> List.map double numbers
[2,8,6,4]
```

다시 한번 말씀드리지만, 리스트의 모든 요소들은 같은 타입을 가지고 있어야 해요.

## 튜플\(Tuples\)

또 다른 유용한 자료구조 중엔 튜플이 있어요. 튜플은 값의 수를 고정해서 담을 수 있고, 각 값들은 어떤 타입이든 될 수 있어요. 보통 함수에서 한개 이상의 값을 반환해야 할 때 사용해요. 다음은 이름을 받아서 사용자에게 메시지를 주는 함수입니다.

```elm
> import String

> goodName name = \
|   if String.length name <= 20 then \
|     (True, "name accepted!") \
|   else \
|     (False, "name was too long; please limit it to 20 characters")

> goodName "Tom"
(True, "name accepted!")
```

튜플은 매우 사용하기 편리해요. 하지만 복잡해지기 시작한다면, 보통 튜플보단 레코드를 사용하는 게 가장 좋은 방법이에요.

## 레코드\(Records\)

레코드는 키와 값이 한쌍을 이뤄요. JavaScript나 Python의 객체\(object\)와 비슷하죠. A record is a set of key-value pairs, similar to objects in JavaScript or Python. You will find that they are extremely common and useful in Elm! Let's see some basic examples.

```elm
> point = { x = 3, y = 4 }
{ x = 3, y = 4 }

> point.x
3

> bill = { name = "Gates", age = 57 }
{ age = 57, name = "Gates" }

> bill.name
"Gates"
```

So we can create records using curly braces and access fields using a dot. Elm also has a version of record access that works like a function. By starting the variable with a dot, you are saying _please access the field with the following name_. This means that `.name` is a function that gets the `name` field of the record.

```elm
> .name bill
"Gates"

> List.map .name [bill,bill,bill]
["Gates","Gates","Gates"]
```

When it comes to making functions with records, you can do some pattern matching to make things a bit lighter.

```elm
> under70 {age} = age < 70
<function>

> under70 bill
True

> under70 { species = "Triceratops", age = 68000000 }
False
```

So we can pass any record in as long as it has an `age` field that holds a number.

It is often useful to update the values in a record.

```elm
> { bill | name = "Nye" }
{ age = 57, name = "Nye" }

> { bill | age = 22 }
{ age = 22, name = "Gates" }
```

It is important to notice that we do not make _destructive_ updates. When we update some fields of `bill` we actually create a new record rather than overwriting the existing one. Elm makes this efficient by sharing as much content as possible. If you update one of ten fields, the new record will share the nine unchanged values.

### Comparing Records and Objects

Records in Elm are _similar_ to objects in JavaScript, but there are some crucial differences. The major differences are that with records:

* You cannot ask for a field that does not exist.
* No field will ever be undefined or null.
* You cannot create recursive records with a `this` or `self` keyword.

Elm encourages a strict separation of data and logic, and the ability to say `this` is primarily used to break this separation. This is a systemic problem in Object Oriented languages that Elm is purposely avoiding.

Records also support [structural typing](https://en.wikipedia.org/wiki/Structural_type_system "Structural Types") which means records in Elm can be used in any situation as long as the necessary fields exist. This gives us flexibility without compromising reliability.

