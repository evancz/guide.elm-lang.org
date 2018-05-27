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
