# Modules

Elm has **modules** to help you grow your codebase in a nice way. On the most basic level, modules let you break your code into multiple files.


## Defining Modules

Elm modules work best when you define them around a central type. Like how the `List` module is all about the `List` type. So say we want to build a module around a `Post` type for a blogging website. We can create something like this:

```elm
module Post exposing (Post, estimatedReadTime, encode, decoder)

import Json.Decode as D
import Json.Encode as E


-- POST

type alias Post =
  { title : String
  , author : String
  , content : String
  }


-- READ TIME

estimatedReadTime : Post -> Float
estimatedReadTime post =
  toFloat (wordCount post) / 220

wordCount : Post -> Int
wordCount post =
  List.length (String.words post.content)


-- JSON

encode : Post -> E.Value
encode post =
  E.object
    [ ("title", E.string post.title)
    , ("author", E.string post.author)
    , ("content", E.string post.content)
    ]

decoder : D.Decoder Post
decoder =
  D.map3 Post
    (D.field "title" D.string)
    (D.field "author" D.string)
    (D.field "content" D.string)
```

The only new syntax here is that `module Post exposing (..)` line at the very top. That means the module is known as `Post` and only certain values are available to outsiders. As written, the `wordCount` function is only available _within_ the `Post` module. Hiding functions like this is one of the most important techniques in Elm!

> **Note:** If you forget to add a module declaration, Elm will use this one instead:
>
>```elm
module Main exposing (..)
```
>
> This makes things easier for beginners working in just one file. They should not be confronted with the module system on their first day!


## Growing Modules

As your application gets more complex, you will end up adding things to your modules. It is normal for Elm modules to be in the 400 to 1000 line range, as I explain in [The Life of a File](https://youtu.be/XpDsk374LDE). But when you have multiple modules, how do you decide _where_ to add new code?

I try to use the following heuristics when code is:

- **Unique** &mdash; If logic only appears in one place, I break out top-level helper functions as close to the usage as possible. Maybe use a comment header like `-- POST PREVIEW` to indicate that the following definitions are related to previewing posts.
- **Similar** &mdash; Say we want to show `Post` previews on the home page and on the author pages. On the home page, we want to emphasize the interesting content, so we want longer snippets. But on the author page, we want to emphasize the breadth of content, so we want to focus on titles. These cases are _similar_, not the same, so we go back to the **unique** heuristic. Just write the logic separately.
- **The Same** &mdash; At some point we will have a bunch of **unique** code. That is fine! But perhaps we find that some definitions contain logic that is _exactly_ the same. Break out a helper function for that logic! If all the uses are in one module, no need to do anything more. Maybe put a comment header like `-- READ TIME` if you really want.

These heuristics are all about making helper functions within a single file. You only want to create a new module when a bunch of these helper functions all center around a specific custom type. For example, you start by creating a `Page.Author` module, and do not create a `Post` module until the helper functions start piling up. At that point, creating a new module should make your code feel easier to navigate and understand. If it does not, go back to the version that was clearer. More modules is not more better! Take the path that keeps the code simple and clear.

To summarize, assume **similar** code is **unique** by default. (It usually is in user interfaces in the end!) If you see logic that is **the same** in different definitions, make some helper functions with appropriate comment headers. When you have a bunch of helper functions about a specific type, _consider_ making a new module. If a new module makes your code clearer, great! If not, go back. More files is not inherently simpler or clearer.

> **Note:** One of the most common ways to get tripped up with modules is when something that was once **the same** becomes **similar** later on. Very common, especially in user interfaces! Folks will often try to create a Frankenstein function that handles all the different cases. Adding more arguments. Adding more _complex_ arguments. The better path is to accept that you now have two **unique** situations and copy the code into both places. Customize it exactly how you need. Then see if any of the resulting logic is **the same**. If so, move it out into helpers. **Your long functions should split into multiple smaller functions, not grow longer and more complex!**


## Using Modules

It is customary in Elm for all of your code to live in the `src/` directory. That is the default for [`elm.json`](https://github.com/elm/compiler/blob/0.19.0/docs/elm.json/application.md) even. So our `Post` module would need to live in a file named `src/Post.elm`. From there, we can `import` a module and use its exposed values. There are four ways to do that:

```elm
import Post
-- Post.Post, Post.estimatedReadTime, Post.encode, Post.decoder

import Post as P
-- P.Post, P.estimatedReadTime, P.encode, P.decoder

import Post exposing (Post, estimatedReadTime)
-- Post, estimatedReadTime
-- Post.Post, Post.estimatedReadTime, Post.encode, Post.decoder

import Post as P exposing (Post, estimatedReadTime)
-- Post, estimatedReadTime
-- P.Post, P.estimatedReadTime, P.encode, P.decoder
```

I recommend using `exposing` pretty rarely. Ideally on zero or one of your imports. Otherwise, it can start getting hard to figure out where things came from when reading though. “Wait, where is `filterPostBy` from again? What arguments does it take?” It gets harder and harder to read through code as you add more `exposing`. I tend to use it for `import Html exposing (..)` but not on anything else. For everything else, I recommend using the standard `import` and maybe using `as` if you have a particularly long module name!