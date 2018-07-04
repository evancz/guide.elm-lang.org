
# Core Language

This section will walk you through Elm's simple core language.

This works best when you follow along, so after [installing](install.md), start up `elm-repl` in the terminal. (Or use the [online REPL](http://elmrepl.cuberoot.in/).) Either way, you should see something like this:

```elm
---- elm repl 0.18.0 -----------------------------------------------------------
 :help for help, :exit to exit, more at <https://github.com/elm-lang/elm-repl>
--------------------------------------------------------------------------------
>
```

The REPL prints out the type of every result, but **we will leave the type annotations off in this tutorial** for the sake of introducing concepts gradually.

We will cover [values](#values), [functions](#functions), [lists](#lists), [tuples](#tuples), and [records](#records). These building blocks all correspond pretty closely with structures in languages like JavaScript, Python, and Java.


## Values

Let's get started with some strings:

```elm
> "hello"
"hello"

> "hello" ++ "world"
"helloworld"

> "hello" ++ " world"
"hello world"
```

Elm uses the `(++)` operator to put strings together. Notice that both strings are preserved exactly as is when they are put together so when we combine `"hello"` and `"world"` the result has no spaces.

Math looks normal too:

```elm
> 2 + 3 * 4
14

> (2 + 3) * 4
20
```

Unlike JavaScript, Elm makes a distinction between integers and floating point numbers. Just like Python 3, there is both floating point division `(/)` and integer division `(//)`.

```elm
> 9 / 2
4.5

> 9 // 2
4
```

## Functions

Let's start by writing a function `isNegative` that takes in some number and checks if it is less than zero. The result will be `True` or `False`.

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

Notice that function application looks different than in languages like JavaScript and Python and Java. Instead of wrapping all arguments in parentheses and separating them with commas, we use spaces to apply the function. So `(add(3,4))` becomes `(add 3 4)` which ends up avoiding a bunch of parens and commas as things get bigger. Ultimately, this looks much cleaner once you get used to it! [The elm-html package][elm-html] is a good example of how this keeps things feeling light.

[elm-html]: http://elm-lang.org/blog/blazing-fast-html


## If Expressions

When you want to have conditional behavior in Elm, you use an if-expression.

```elm
> if True then "hello" else "world"
"hello"

> if False then "hello" else "world"
"world"
```

The keywords `if` `then` `else` are used to separate the conditional and the two branches so we do not need any parentheses or curly braces.

Elm does not have a notion of &ldquo;truthiness&rdquo; so numbers and strings and lists cannot be used as boolean values. If we try it out, Elm will tell us that we need to work with a real boolean value.

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

> **Note:** Make sure that you add a whitespace before the second line of the function. Elm has a "syntactically significant whitespace" meaning that indentation is a part of its syntax.


## Lists

Lists are one of the most common data structures in Elm. They hold a sequence of related things, similar to arrays in JavaScript.

Lists can hold many values. Those values must all have the same type. Here are a few examples that use functions from [the `List` library][list]:

[list]: http://package.elm-lang.org/packages/elm-lang/core/latest/List

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

A record is a set of key-value pairs, similar to objects in JavaScript or dictionaries in Python. You will find that they are extremely common and useful in Elm! Let's see some basic examples.


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

So we can create records using curly braces and access fields using a dot. Elm also has a version of record access that works like a function. By starting the variable with a dot, you are saying *please access the field with the following name*. This means that `.name` is a function that gets the `name` field of the record.

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

It is important to notice that we do not make *destructive* updates. When we update some fields of `bill` we actually create a new record rather than overwriting the existing one. Elm makes this efficient by sharing as much content as possible. If you update one of ten fields, the new record will share the nine unchanged values.


### Comparing Records and Objects

Records in Elm are *similar* to objects in JavaScript, but there are some crucial differences. The major differences are that with records:

- You cannot ask for a field that does not exist.
- No field will ever be undefined or null.
- You cannot create recursive records with a `this` or `self` keyword.

Elm encourages a strict separation of data and logic, and the ability to say `this` is primarily used to break this separation. This is a systemic problem in Object Oriented languages that Elm is purposely avoiding.

Records also support [structural typing][st] which means records in Elm can be used in any situation as long as the necessary fields exist. This gives us flexibility without compromising reliability.

 [st]: https://en.wikipedia.org/wiki/Structural_type_system "Structural Types"
