# Types

One of Elm's major benefits is that **users do not see runtime errors in practice**. This is possible because the Elm compiler can analyze your source code very quickly to see how values flow through your program. If a value can ever be used in an invalid way, the compiler tells you about it with a friendly error message. This is called *type inference*. The compilers figures out what *type* of values flow in and out of all your functions.

## An Example of Type Inference

The following code defines a `toFullName` function which extracts a persons full name as a string:

```elm
toFullName person =
  person.firstName ++ " " ++ person.lastName

fullName =
  toFullName { fistName = "Hermann", lastName = "Hesse" }
```

Just writing down the code with no extra clutter like in JavaScript or Python. Do you see the bug though? 

In JavaScript, the equivalent code spits out `"undefined Hesse"`. Not even an error! Hopefully one of your users will tell you about it when they see it in the wild. In contrast, the Elm compiler just looks at the source code and tells you:

```
-- TYPE MISMATCH ---------------------------------------------------------------

The argument to function `toFullName` is causing a mismatch.

6│   toFullName { fistName = "Hermann", lastName = "Hesse" }
                ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Function `toFullName` is expecting the argument to be:

    { …, firstName : … }

But it is:

    { …, fistName : … }

Hint: I compared the record fields and found some potential typos.
    
    firstName <-> fistName
```

It sees that `toFullName` is getting the wrong *type* of argument. Like the hint in the error message says, someone accidentally wrote `fist` instead of `first`.

It is great to have an assistant for simple mistakes like this, but it is even more valuable when you have hundreds of files and a bunch of collaborators making changes. No matter how big and complex things get, the Elm compiler checks that *everything* fits together properly just based on the source code.

Let's learn more about how this works.

## Types

In the [Core Language](../core_language.md) section of this book, we ran a bunch of code in the REPL. Well, we are going to do it again, but now with an emphasis on the types that are getting spit out. So type `elm repl` in your terminal again. You should see this:

```elm
---- elm repl 0.17.0 -----------------------------------------------------------
 :help for help, :exit to exit, more at <https://github.com/elm-lang/elm-repl>
--------------------------------------------------------------------------------
>
```




## Type Annotations

Elm can figure out types automatically, but it also lets you write a *type annotation* on the line above a definition if you want.

```elm
fortyTwo : Int
fortyTwo =
  42

names : List String
names =
  [ "Alice", "Bob", "Charles" ]
```

They are just describing the general shape of the data we are working with.  `fortyTwo` is an integer and `names` is a list of strings. Nothing too crazy.

We can add type annotations to functions as well. So say we write `isNegative` that figures out if a number is less than zero.

```elm
isNegative : Int -> Bool
isNegative number =
  number < 0
```

Here the type annotation is saying 

I like to think of types as a contract. The contract says something like "this function only accepts string arguments" 



## Why so many arrows?!

If you have been looking around at examples, you probably have seen type annotations with more than one arrows. For example, `add` would be defined like this:

```elm
add : number -> number -> number
add x y =
  x + y
```

The first time people see this, the obvious question is "what is the deal with all the arrows?!"

Well, you actually can define `add` so there is only one arrow, like this:

```elm
addPair : (number, number) -> number
addPair (x, y) =
  x + y
```

It looks a lot more like JavaScript, Java, Python, etc. which is kind of cool. So we *can* define functions that way, but you pretty much never want to do this. There are better ways in Elm!

To understand the distinction between these two functions and how exactly they work, we need to learn about **anonymous functions**. These are the basic building blocks of all functions in Elm. Once we have this primitive concept, we will work back up to defining both of these versions of `add`.


### Anonymous Functions

First we need to get a feeling for how anonymous functions work. So in `elm-repl` let’s define an anonymous function that increments numbers:

```elm
> \\n -> n + 1
<function> : number -> number
```

You can read this as “I take in some value and will call it `n` in `n + 1`”. The backslash is supposed to look like a lambda if you squint, a wink to the intellectual history that lead to languages like Elm.

We can use these anonymous functions directly, never giving them a name. Here is us using our increment function with 3 as the argument:

```elm
> (\\n -> n + 1) 3
4 : number
```

It is important that we put parentheses around the anonymous function. After the arrow, Elm is just going to keep reading code as long as it can, so the parentheses put bounds on it and indicate that this one is a function and the next thing is an argument.

We can even get crazy and name our anonymous functions. So rebellious!

```elm
> increment = \\n -> n + 1
<function> : number -> number

> increment 3
4 : number
```

When we are evaluating `increment 3` we can imagine the process going like this:

```elm
increment 3
(\\n -> n + 1) 3
3 + 1
4
```

Just like any other variable name in Elm, you substitute in whatever it is equal to.

Here is the crazy secret though: this is how all functions are defined! You are just giving a name to an anonymous function. So when you see things like this:

```elm
increment n = n + 1
```

You can think of it as a convenient shorthand for:

```elm
increment = \\n -> n + 1
```

You can move any arguments in a function declaration over to the other side of the equals sign and they just become an anonymous function. Now let’s take that a step farther and think about what it means for functions with *multiple* arguments. Here are a bunch of equivalent functions:

```elm
add : number -> number -> number
add x y =
  x + y

add : number -> (number -> number)
add x =
  \\y -> x + y

add : number -> (number -> number)
add =
  \\x -> (\\y -> x + y)
```

We started with the typical definition of `add` and then moved the arguments over, turning them into anonymous functions one at a time. This reveals the true nature of the `add` function. It is not a function that takes two arguments and returns a number, it is a function that returns a function that returns a number. Normally folks leave off the parentheses in the type annotation for convenience, which is why it looks so weird at first.

> **Note:** This is called “currying” and appears in many ML-family languages. The wikipedia article for this concept is not ideal, which is why this documentation exists specifically for Elm!

It may be helpful to step through an expression like `add 1 42` to see exactly what is going on. The craziest part of this is where the implicit parentheses go, so I will add them all in.

```elm
-- add 1 42
-- (add 1) 42
-- ((\\x -> (\\y -> x + y)) 1) 42
-- (\\y -> 1 + y) 42
-- 1 + 42
-- 43
```

You expand out `add` and then provide the arguments one at a time, eventually getting down to adding two numbers together.

Okay, but what was going on with the definition of `add` with only one arrow though? Let’s expand it out to see:

```elm
> addPair (x,y) = x + y
<function> : (number, number) -> number

> addPair = \\(x,y) -> x + y
<function> : (number, number) -> number

> addPair (3,4)
7 : number
```

It is possible to have pattern matches in anonymous functions. So what we are really doing is putting our two numbers into a tuple, and then extracting them in the anonymous function. So `addPair` is *really* is a function that takes one argument. It just so happens that we are jamming multiple things in that one argument.

Now like I said earlier, you would never define a function like this in Elm. Defining functions in this way means we cannot “partially apply” functions, a trick that can make Elm code shockingly concise. So consice that some people go overboard with it!


### Partial Application

Because of how we define functions in Elm, you do not need to give all the arguments at once. It is possible to say things like this:

```elm
> add 1
<function> : number -> number
```

Let’s break down what is happening here by showing the evaluation steps:

```elm
add 1
(\\x -> (\\y -> x + y)) 1
\\y -> 1 + y
```

You give the first argument, and then you get back a function with that filled in! This lets us write functions like this:

```elm
> increment = add 1
<function> : number -> number

> increment 42
43 : number
```

When we actually evaluating `increment 42` it expands out like this:

```elm
-- increment 42
-- (add 1) 42
-- ((\\x -> (\\y -> x + y)) 1) 42
-- (\\y -> 1 + y) 42
-- 1 + 42
-- 43
```

So now we have seen the foundation of functions in Elm, but what does it look like when we really start using them to make cool stuff in Elm?