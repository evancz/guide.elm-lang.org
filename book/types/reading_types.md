# Reading Types

In the [Core Language](/core_language.html) section of this book, we ran a bunch of code in the REPL. Well, we are going to do it again, but now with an emphasis on the types that are getting spit out. So type `elm repl` in your terminal again. You should see this:

```elm
---- Elm 0.19.0 ----------------------------------------------------------------
Read <https://elm-lang.org/0.19.0/repl> to learn more: exit, help, imports, etc.
--------------------------------------------------------------------------------
>
```


## Primitives and Lists

Let's enter some simple expressions and see what happens:

```elm
> "hello"
"hello" : String

> not True
False : Bool

> round 3.1415
3 : Int
```

In these three examples, the REPL tells us the resulting value along with what *type* of value it happens to be. The value `"hello"` is a `String`. The value `3` is an `Int`. Nothing too crazy here.

Let's see what happens with lists holding different types of values:

```elm
> [ "Alice", "Bob" ]
[ "Alice", "Bob" ] : List String

> [ 1.0, 8.6, 42.1 ]
[ 1.0, 8.6, 42.1 ] : List Float

> []
[] : List a
```

In the first case, we have a `List` filled with `String` values. In the second, the `List` is filled with `Float` values. In the third case the list is empty, so we do not actually know what kind of values are in the list. So the type `List a` is saying "I know I have a list, but it could be filled with anything". The lower-case `a` is called a *type variable*, meaning that there are no constraints in our program that pin this down to some specific type. In other words, the type can vary based on how it is used.


## Functions

Let's see the type of some functions:

```elm
> String.length
<function> : String -> Int
```

The function `String.length` has type `String -> Int`. This means it *must* take in a `String` argument, and it will definitely return an integer result. So let's try giving it an argument:

```elm
> String.length "Supercalifragilisticexpialidocious"
34 : Int
```

So we start with a `String -> Int` function and give it a `String` argument. This results in an `Int`.

What happens when you do not give a `String` though?

```elm
> String.length [1,2,3]
-- error!

> String.length True
-- error!
```

A `String -> Int` function *must* get a `String` argument!

> **Note:** Functions that take multiple arguments end up having more and more arrows. For example, here is a function that takes two arguments:
>
>```elm
String.repeat : Int -> String -> String
```
>
> Giving two arguments like `String.repeat 3 "ha"` will produce `"hahaha"`. It works to think of `->` as a weird way to separate arguments, but I explain the real reasoning [here](/appendix/function_types.md). It is pretty neat!


## Type Annotations

So far we have just let Elm figure out the types, but it also lets you write a **type annotation** on the line above a definition if you want. So when you are writing code, you can say things like this:

```elm
half : Float -> Float
half n =
  n / 2

-- half 256 == 128
-- half "3" -- error!

hypotenuse : Float -> Float -> Float
hypotenuse a b =
  sqrt (a^2 + b^2)

-- hypotenuse 3 4  == 5
-- hypotenuse 5 12 == 13

checkPower : Int -> String
checkPower powerLevel =
  if powerLevel > 9000 then "It's over 9000!!!" else "Meh"

-- checkPower 9001 == "It's over 9000!!!"
-- checkPower True -- error!
```

Adding type annotations is not required, but it is definitely recommended! Benefits include:

1. **Error Message Quality** &mdash; When you add a type annotation, it tells the compiler what you are _trying_ to do. Your implementation may have mistakes, and now the compiler can compare against your stated intent. &ldquo;You said argument `powerLevel` was an `Int`, but it is getting used as a `String`!&rdquo;
2. **Documentation** &mdash; When you revisit code later (or when a colleague visits it for the first time) it can be really helpful to see exactly what is going in and out of the function without having to read the implementation super carefully.

People can make mistakes in type annotations though, so what happens if the annotation does not match the implementation? The compiler figures out all the types on its own, and it checks that your annotation matches the real answer. In other words, the compiler will always verify that all the annotations you add are correct. So you get better error messages _and_ documentation always stays up to date!


## Type Variables

As you look through the functions in [`elm/core`][core], you will see some type signatures with lower-case letters in them. We can check some of them out in `elm repl`:

```elm
> List.length
<function> : List a -> Int
```

Notice that lower-case `a` in the type? That is called a **type variable**. It can vary depending on how [`List.length`][length] is used:

```elm
> List.length [1,1,2,3,5,8]
6 : Int

> List.length [ "a", "b", "c" ]
3 : Int

> List.length [ True, False ]
2 : Int
```

We just want the length, so it does not matter what is in the list. So the type variable `a` is saying that we can match any type. Let&rsquo;s look at another common example:

```elm
> List.reverse
<function> : List a -> List a

> List.reverse [ "a", "b", "c" ]
["c","b","a"] : List String

> List.reverse [ True, False ]
[False,True] : List Bool
```

Again, the type variable `a` can vary depending on how [`List.reverse`][reverse] is used. But in this case, we have an `a` in the argument and in the result. This means that if you give a `List Int` you must get a `List Int` as well. Once we decide what `a` is, that’s what it is everywhere.

> **Note:** Type variables must start with a lower-case letter, but they can be full words. We could write the type of `List.length` as `List value -> Int` and we could write the type of `List.reverse` as `List element -> List element`. It is fine as long as they start with a lower-case letter. Type variables `a` and `b` are used by convention in many places, but some type annotations benefit from more specific names.

[core]: https://package.elm-lang.org/packages/elm/core/latest/
[length]: https://package.elm-lang.org/packages/elm/core/latest/List#length
[reverse]: https://package.elm-lang.org/packages/elm/core/latest/List#reverse


## Constrained Type Variables

There are a few “constrained” type variables. The most common example is probably the `number` type. The [`negate`][negate] function uses it:

```elm
negate : number -> number
```

Normally type variables can get filled in with _anything_, but `number` can only be filled in by `Int` and `Float` values. It constrains the possibilities.

The full list of constrained type variables is:

- `number` permits `Int` and `Float`
- `appendable` permits `String` and `List a`
- `comparable` permits `Int`, `Float`, `Char`, `String`, and lists/tuples of `comparable` values
- `compappend` permits `String` and `List comparable`

These constrained type variables exist to make operators like `(+)` and `(<)` a bit more flexible.

[negate]: https://package.elm-lang.org/packages/elm/core/latest/Basics#negate