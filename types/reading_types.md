# Reading Types

In the [Core Language](../core_language.md) section of this book, we ran a bunch of code in the REPL. Well, we are going to do it again, but now with an emphasis on the types that are getting spit out. So type `elm repl` in your terminal again. You should see this:

```elm
---- elm repl 0.17.0 -----------------------------------------------------------
 :help for help, :exit to exit, more at <https://github.com/elm-lang/elm-repl>
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

The important thing to understand here is how the type of the result `Int` is built up from the initial expression. We have a `String -> Int` function and give it a `String` argument. This results in an `Int`.

What happens when you do not give a `String` though?

```elm
> String.length [1,2,3]
-- error!

> String.length True
-- error!
```

A `String -> Int` function *must* get a `String` argument!


### Anonymous Functions

Elm has a feature called *anonymous functions*. Basically, you can create a function without naming it, like this:

```elm
> \n -> n / 2
<function> : Float -> Float
```

Between the backslash and the arrow, you list the arguments of the function, and on the right of the arrow, you say what to do with those arguments. In this example, it is saying: I take in some argument I will call `n` and then I am going to divide it by two.

We can use anonymous functions directly. Here is us using our anonymous function with `128` as the argument:

```elm
> (\n -> n / 2) 128
64 : Float
```

We start with a `Float -> Float` function and give it a `Float` argument. The result is another `Float`.

> **Notes:** The backslash that starts an anonymous function is supposed to look like a lambda `λ` if you squint. This is a possibly ill-conceived wink to the intellectual history that led to languages like Elm.
>
> Also, when we wrote the expression `(\n -> n / 2) 128`, it is important that we put parentheses around the anonymous function. After the arrow, Elm is just going to keep reading code as long as it can. The parentheses put bounds on this, indicating where the function body ends.


### Named Functions

In the same way that we can name a value, we can name an anonymous function. So rebellious!

```elm
> oneHundredAndTwentyEight = 128.0
128 : Float

> half = \n -> n / 2
<function> : Float -> Float

> half oneHundredAndTwentyEight
64 : Float
```

In the end, it works just like when nothing was named. You have a `Float -> Float` function, you give it a `Float`, and you end up with another `Float`.

Here is the crazy secret though: this is how all functions are defined! You are just giving a name to an anonymous function. So when you see things like this:

```elm
> half n = n / 2
<function> : Float -> Float
```

You can think of it as a convenient shorthand for:

```elm
> half = \n -> n / 2
<function> : Float -> Float
```

This is true for all functions, no matter how many arguments they have. So now let's take that a step farther and think about what it means for functions with *multiple* arguments:

```elm
> divide x y = x / y
<function> : Float -> Float -> Float

> divide 3 2
1.5 : Float
```

That seems fine, but why are there *two* arrows in the type for `divide`?! To start out, it is fine to think that "all the arguments are separated by arrows, and whatever is last is the result of the function". So `divide` takes two arguments and returns a `Float`.

To really understand why there are two arrows in the type of `divide`, it helps to convert the definition to use anonymous functions.

```elm
> divide x y = x / y
<function> : Float -> Float -> Float

> divide x = \y -> x / y
<function> : Float -> Float -> Float

> divide = \x -> (\y -> x / y)
<function> : Float -> Float -> Float
```

All of these are totally equivalent. We just moved the arguments over, turning them into anonymous functions one at a time. So when we run an expression like `divide 3 2` we are actually doing a bunch of evaluation steps:

```elm
  divide 3 2
  (divide 3) 2                 -- Step 1 - Add the implicit parentheses
  ((\x -> (\y -> x / y)) 3) 2  -- Step 2 - Expand `divide`
  (\y -> 3 / y) 2              -- Step 3 - Replace x with 3
  3 / 2                        -- Step 4 - Replace y with 2
  1.5                          -- Step 5 - Do the math
```

After you expand `divide`, you actually provide the arguments one at a time. Replacing `x` and `y` are actually two different steps.

Let's break that down a bit more to see how the types work. In evaluation step #3 we saw the following function:

```elm
> (\y -> 3 / y)
<function> : Float -> Float
```

It is a `Float -> Float` function, just like `half`. Now in step #2 we saw a fancier function:

```elm
> (\x -> (\y -> x / y))
<function> : Float -> Float -> Float
```

Well, we are starting with `\x -> ...` so we know the type is going to be something like `Float -> ...`. We also know that `(\y -> x / y)` has type `Float -> Float`.

So if you actually wrote down all the parentheses in the type, it would instead say **`Float -> (Float -> Float)`**. You provide arguments one at a time. So when you replace `x`, the result is actually *another function*.

It is the same with all functions in Elm:

```elm
> import String
> String.repeat
<function> : Int -> String -> String
```

This is really `Int -> (String -> String)` because you are providing the arguments one at a time.

Because all functions in Elm work this way, you do not need to give all the arguments at once. It is possible to say things like this:

```elm
> divide 128
<function> : Float -> Float

> String.repeat 3
<function> : String -> String
```

This is called *partial application*. It lets us use [the `|>` operator][pipe] to chain functions together in a nice way, and it is why function types have so many arrows!

[pipe]: http://package.elm-lang.org/packages/elm-lang/core/latest/Basics#|&gt;


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

People can make mistakes in type annotations, so what happens if they say the wrong thing? Well, the compiler does not make mistakes, so it still figures out the type on its own. It then checks that your annotation matches the real answer. In other words, the compiler will always verify that all the annotations you add are correct.

> **Note:** Some folks feel that it is odd that the type annotation goes on the line above the actual definition. The reasoning is that it should be easy and noninvasive to add a type annotation *later*. This way you can turn a sloppy prototype into higher-quality code just by adding lines.