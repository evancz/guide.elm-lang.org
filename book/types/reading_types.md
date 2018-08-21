# Reading Types

In the [Core Language](../core_language.md) section of this book, we ran a bunch of code in the REPL. Well, we are going to do it again, but now with an emphasis on the types that are getting spit out. So type `elm repl` in your terminal again. You should see this:

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
> import String
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

So far we have just let Elm figure out the types, but it also lets you write a *type annotation* on the line above a definition if you want. So when you are writing code, you can say things like this:

```elm
half : Float -> Float
half n =
  n / 2

divide : Float -> Float -> Float
divide x y =
  x / y

askVegeta : Int -> String
askVegeta powerLevel =
  if powerLevel > 9000 then
    "It's over 9000!!!"

  else
    "It is " ++ toString powerLevel ++ "."
```

People can make mistakes in type annotations, so what happens if they say the wrong thing? The compiler still figures out the type on its own, and it checks that your annotation matches the real answer. In other words, the compiler will always verify that all the annotations you add are correct!

> **Note:** Some folks feel that it is odd that the type annotation goes on the line above the actual definition. The reasoning is that it should be easy and noninvasive to add a type annotation *later*. This way you can turn a sloppy prototype into higher-quality code just by adding lines.


## Type Variables

As you look through the functions in [`elm/core`][core], you will see some type signatures with lower-case letters in them. [`List.reverse`][reverse] is a good example:

```elm
List.reverse : List a -> List a
```

That lower-case `a` is called a **type variable**. It means we can use `List.reverse` as if it has type:

- `List String -> List String`
- `List Float -> List Float`
- `List Int -> List Int`
- ...

The `a` can vary and match any type. The `List.reverse` function does not care. But once you decide that `a` is a `String` in the argument, it must also be a `String` in the result. That means `List.reverse` can never be `List String -> List Int`. All `a` values must match in any specific reversal!

> **Note:** Type variables must start with a lower-case letter, and they do not have to be just one character! Imagine we create a function that takes an argument and then gives it back without changes. This is often called the identity function:
>
>```elm
identity : value -> value
identity x =
  x
```
>
> I wrote the type signature as `value -> value`, but it could also be `a -> a`. The only thing that matters is that the type of values going in matches the type of values going out!

[core]: https://package.elm-lang.org/packages/elm/core/latest/
[reverse]: https://package.elm-lang.org/packages/elm/core/latest/List#reverse


## Constrained Type Variables

There are a few “constrained” type variables. The most common example is probably the `number` type. The [`negate`][negate] function uses it:

```elm
negate : number -> number
```

Normally type variables can get filled in with _anything_, but `number` can only be filled in by `Int` and `Float` values. It constrains the possibilities.

The full list of constrained type variables is:

- `number` = `Int` or `Float`
- `appendable` = `String` or `List a`
- `compappend` = `String` or `List comparable`
- `comparable` = `Int`, `Float`, `Char`, `String`, lists and tuples of `comparable` values

These constrained type variables exist to make operations like `(+)` and `(<)` a bit more flexible.

[negate]: https://package.elm-lang.org/packages/elm/core/latest/Basics#negate