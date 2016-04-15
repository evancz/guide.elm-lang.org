# Types

One of Elm's major benefits is that **users do not see runtime errors in practice**. This is only possible because Elm has types and type inference.

> **Note:** The term "types" will be used to mean "types as they appear in Elm". This is an important distinction because types in Elm are very different than types in most other languages! Many programmers have only seen types in Java, so their experience is roughly "using types is verbose and annoying, and at the end of the day, I still get the same runtime errors and null pointer exceptions. What's the point?!" Most Elm programmers feel exactly the same way about Java!


## Contracts

Think of types as a contract that can be checked by the compiler. The contract says something like "this function only accepts string arguments" so you can make sure that bad data *never* gets in.

The way we write down these contracts is with "type annotations" where we define the exact shape of the data we are working with.


```elm
fortyTwo : Int
fortyTwo =
  42


names : List String
names =
  [ "Alice", "Bob", "Charles" ]
```

Here we are just describing the general shape of the data we are working with. `fortyTwo` is an integer and `names` is a list of strings. Nothing crazy, just describing the shape of our data.

This becomes much more valuable when you start using it with functions. In the following example, we will pick out the longest name from a list.

```elm
import String

longestName : List String -> Int
longestName names =
  List.maximum (List.map String.length names)
  
-- longestName names == "Charles"
```

Now imagine if someone tried to pass in a list of numbers or books.

```
-- longestName [1,2,3]
```

The `String.length` function would break, not knowing how to get the length of a number. Well, the contract for `longestName` rules that out! We only accept lists of strings and only return integers.

Now the cool thing is that all these type annotations are optional. **The compiler can always figure them out automatically, so the contract exists whether you write it down or not.** The annotation go on the line above the actual definition because people will often prototype without them, adding them later when they want a more professional code base.

The `isLong` example is doing exactly the same thing. It requires a record with a field name `pages` that holds integers. Any record will do, with however many other fields you want, but we definitely need the `pages` field!

So in both cases we are writing contracts that say &ldquo;I require input with this shape, and I will give you output with that shape.&rdquo; This is the essence of ruling out runtime errors in Elm. We always know what kind of values a function needs and what kind it produces, so we can just check that we always follow these rules.

> **Note:** All of these types can be inferred, so you can leave off the type annotations and Elm can still check that data is flowing around in a way that works. This means you can just *not* write these contracts and still get all the benefits!

So far we have seen some simple cases where we make sure our data is the right shape, but these contracts become extremely powerful when you start making your own types.

book : { title : String, author : String, pages : Int }
book =
  { title = "Demian", author = "Hesse", pages = 176 }

The `book` type was kind of a lot to read, so we can create a `type alias` to make it 



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