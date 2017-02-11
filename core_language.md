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

## 값

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

## 함수

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

Notice that function application looks different than in languages like JavaScript and Python and Java. Instead of wrapping all arguments in parentheses and separating them with commas, we use spaces to apply the function. So `(add(3,4))` becomes `(add 3 4)` which ends up avoiding a bunch of parens and commas as things get bigger. Ultimately, this looks much cleaner once you get used to it! [The elm-html package](http://elm-lang.org/blog/blazing-fast-html) is a good example of how this keeps things feeling light.

## If Expressions

When you want to have conditional behavior in Elm, you use an if-expression.

```elm
> if True then "hello" else "world"
"hello"

> if False then "hello" else "world"
"world"
```

The keywords `if` `then` `else` are used to separate the conditional and the two branches so we do not need any parentheses or curly braces.

Elm does not have a notion of “truthiness” so numbers and strings and lists cannot be used as boolean values. If we try it out, Elm will tell us that we need to work with a real boolean value.

Now let's make a function that tells us if a number is over 9000.

```elm
> over9000 powerLevel = \
|   if powerLevel > 9000 then "It's over 9000!!!" else "meh"
<function>

> over9000 42
"meh"

> over9000 100000
"It's over 9000!!!"
```

Using a backslash in the REPL lets us split things on to multiple lines. We use this in the definition of `over9000` above. Furthermore, it is best practice to always bring the body of a function down a line. It makes things a lot more uniform and easy to read, so you want to do this with all the functions and values you define in normal code.

## Lists

Lists are one of the most common data structures in Elm. They hold a sequence of related things, similar to arrays in JavaScript.

Lists can hold many values. Those values must all have the same type. Here are a few examples that use functions from [the `List` library](http://package.elm-lang.org/packages/elm-lang/core/latest/List):

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

Again, all elements of the list must have the same type.

## Tuples

Tuples are another useful data structure. A tuple can hold a fixed number of values, and each value can have any type. A common use is if you need to return more than one value from a function. The following function gets a name and gives a message for the user:

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

This can be quite handy, but when things start becoming more complicated, it is often best to use records instead of tuples.

## Records

A record is a set of key-value pairs, similar to objects in JavaScript or Python. You will find that they are extremely common and useful in Elm! Let's see some basic examples.

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

