# Function Types

As you look through packages like [`elm/core`][core] and [`elm/html`][html], you will definitely see functions with multiple arrows. For example:

```elm
String.repeat : Int -> String -> String
String.join : String -> List String -> String
```

Why so many arrows? What is going on here?!

[core]: https://package.elm-lang.org/packages/elm/core/latest/
[html]: https://package.elm-lang.org/packages/elm/html/latest/


## Hidden Parentheses

It starts to become clearer when you see all the parentheses. For example, it is also valid to write the type of `String.repeat` like this:

```elm
String.repeat : Int -> (String -> String)
```

It is a function that takes an `Int` and then produces _another_ function. So if we go into `elm repl` we can see this in action:

```elm
> String.repeat 4
<function> : String -> String

> String.repeat 4 "ha"
"hahahaha" : String

> String.join "|"
<function> : List String -> String

> String.join "|" ["red","yellow","green"]
"red|yellow|green" : String
```

So conceptually, **every function accepts one argument.** It may return another function that accepts one argument. Etc. At some point it will stop returning functions.

We _could_ always put the parentheses to indicate that this is what is really happening, but it starts to get pretty unwieldy when you have multiple arguments. It is the same logic behind writing `4 * 2 + 5 * 3` instead of `(4 * 2) + (5 * 3)`. It means there is a bit extra to learn, but it is so common that it is worth it.

Fine, but what is the point of this feature in the first place? Why not do `(Int, String) -> String` and give all the arguments at once?


## Partial Application

It is quite common to use the `List.map` function in Elm programs:

```elm
List.map : (a -> b) -> List a -> List b
```

It takes two arguments: a function and a list. From there it transforms every element in the list with that function. Here are some examples:

- `List.map String.reverse ["part","are"] == ["trap","era"]`
- `List.map String.length ["part","are"] == [4,3]`

Now remember how `String.repeat 4` had type `String -> String` on its own? Well, that means we can say:

- `List.map (String.repeat 2) ["ha","choo"] == ["haha","choochoo"]`

The expression `(String.repeat 2)` is a `String -> String` function, so we can use it directly. No need to say `(\str -> String.repeat 2 str)`.

Elm also uses the convention that **the data structure is always the last argument** across the ecosystem. This means that functions are usually designed with this possible usage in mind, making this a pretty common technique.

Now it is important to remember that **this can be overused!** It is convenient and clear sometimes, but I find it is best used in moderation. So I always recommend breaking out top-level helper functions when things get even a _little_ complicated. That way it has a clear name, the arguments are named, and it is easy to test this new helper function. In our example, that means creating:

```elm
-- List.map reduplicate ["ha","choo"]

reduplicate : String -> String
reduplicate string =
  String.repeat 2 string
```

This case is really simple, but (1) it is now clearer that I am interested in the linguistic phenomenon known as [reduplication](https://en.wikipedia.org/wiki/Reduplication) and (2) it will be quite easy to add new logic to `reduplicate` as my program evolves. Maybe I want [shm-reduplication](https://en.wikipedia.org/wiki/Shm-reduplication) support at some point?

In other words, **if your partial application is getting long, make it a helper function.** And if it is multi-line, it should _definitely_ be turned into a top-level helper! This advice applies to using anonymous functions too.

> **Note:** If you are ending up with “too many” functions when you use this advice, I recommend using comments like `-- REDUPLICATION` to give an overview of the next five or ten functions. Old school! I have shown this with `-- UPDATE` and `-- VIEW` comments in previous examples, but it is a generic technique that I use in all my code. And if you are worried about files getting too long with this advice, I recommend watching [The Life of a File](https://youtu.be/XpDsk374LDE)!


## Pipelines

Elm also has a [pipe operator][pipe] that relies on partial application. For example, say we have a `sanitize` function for turning user input into integers:

```elm
-- BEFORE
sanitize : String -> Maybe Int
sanitize input =
  String.toInt (String.trim input)
```

We can rewrite it like this:

```elm
-- AFTER
sanitize : String -> Maybe Int
sanitize input =
  input
    |> String.trim
    |> String.toInt
```

So in this “pipeline” we pass the input to `String.trim` and then that gets passed along to `String.toInt`.

This is neat because it allows a “left-to-right” reading that many people like, but **pipelines can be overused!** When you have three or four steps, the code often gets clearer if you break out a top-level helper function. Now the transformation has a name. The arguments are named. It has a type annotation. It is much more self-documenting that way, and your teammates and your future self will appreciate it! Testing the logic gets easier too.

> **Note:** I personally prefer the `BEFORE`, but perhaps that is just because I learned functional programming in languages without pipes!

[pipe]: https://package.elm-lang.org/packages/elm/core/latest/Basics#|&gt;

