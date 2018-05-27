# The Elm Architecture + Effects

I have not made a big deal about it, but so far all the programs we have looked at started with a `main` value like this:

```elm
main =
  Browser.sandbox
    { init = init
    , update = update
    , view = view
    }
```

We have been using [`Browser.sandbox`][sandbox] for all of our programs. This gives us a sandboxed environment that cannot interact with the outside world too much. It is a great way to get started, but we want to start making HTTP requests now. We need to get out of the sandbox!

So in this section we will start using [`Browser.embed`][embed] and learn some new concepts (like commands and subscriptions) along the way!

[sandbox]: https://package.elm-lang.org/packages/elm/browser/latest/Browser#sandbox
[embed]: https://package.elm-lang.org/packages/elm/browser/latest/Browser#embed


## Using Packages

We are also going to start using packages from [`package.elm-lang.org`](https://package.elm-lang.org) in the upcoming examples. We have already been working with a couple:

- [elm/core](https://package.elm-lang.org/packages/elm/core/latest/)
- [elm/html](https://package.elm-lang.org/packages/elm/html/latest/)

But now we will start getting into some fancier ones:

- [elm/random](https://package.elm-lang.org/packages/elm/random/latest/)
- [elm/http](https://package.elm-lang.org/packages/elm/http/latest/)
- [elm/time](https://package.elm-lang.org/packages/elm/time/latest/)

There are tons of other packages on there though! So when you are making your own Elm programs locally, it will probably involve running some commands like this in the terminal:

```bash
elm init --embed
elm install elm/random
elm install elm/http
```

That would set up a small project with `elm/random` and `elm/http` as dependencies.

Now that you have some context about hom Elm packages work, let&rsquo;s look at some examples with effects!