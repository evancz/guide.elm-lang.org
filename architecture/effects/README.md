# The Elm Architecture + Effects

The Elm Architecture is neat, but how do you send HTTP requests?!

Things are not exactly like languages like JavaScript, Python, etc. So we need to start with some facts about how Elm actually works.


## `sandbox`

I have not made a big deal about it, but so far all of our programs were created with [`Browser.sandbox`][sandbox]. We gave an initial `Model` and describe how to `update` and `view` it.

You can think of `Browser.sandbox` as setting up a system like this:

![](diagrams/sandbox.svg)

We get to stay in the world of Elm, writing functions and transforming data. This hooks up to Elm&rsquo;s **runtime system**. The runtime system figures out how to render `Html` efficiently. Did anything change? What is the minimal DOM modification needed? It also figures out when someone clicks a button or types into a text field. It turns that into a `Msg` and feeds it into your Elm code.

By cleanly separating out all the DOM manipulation, it becomes possible to use extremely aggresive optimizations. So Elm&rsquo;s runtime system is a big part of why Elm is [one of the fastest options available][benchmark].

[sandbox]: https://package.elm-lang.org/packages/elm/browser/latest/Browser#sandbox
[benchmark]: http://elm-lang.org/blog/blazing-fast-html-round-two


## `embed`

In the next few examples, we will instead create programs with [`Browser.embed`][embed]. This will introduce the ideas of **commands** and **subscriptions** which will allow us to interact more with the outside world.

You can think of `Browser.embed` as setting up a system like this:

![](diagrams/embed.svg)

Like before, you get to program in the nice Elm world, but these `Cmd` and `Sub` values can tell the runtime system to make HTTP requests, ask about the current time, generate random values, etc.

I think commands and subscriptions make more sense when you start seeing examples, so let&rsquo;s do that!

[embed]: https://package.elm-lang.org/packages/elm/browser/latest/Browser#embed


> **Note 1:** Some readers may be worrying about asset size. &ldquo;A runtime system? That sounds big!&rdquo; It is not. In fact, [Elm assets are exceptionally small](https://elm-lang.org/blog/TODO) when compared to React, Angular, Ember, etc.

> **Note 2:** We are going to use packages from [`package.elm-lang.org`](https://package.elm-lang.org) in the upcoming examples. We have already been working with a couple:
>
> - [elm/core](https://package.elm-lang.org/packages/elm/core/latest/)
> - [elm/html](https://package.elm-lang.org/packages/elm/html/latest/)
>
> But now we will start getting into some fancier ones:
>
> - [elm/random](https://package.elm-lang.org/packages/elm/random/latest/)
> - [elm/http](https://package.elm-lang.org/packages/elm/http/latest/)
> - [elm/time](https://package.elm-lang.org/packages/elm/time/latest/)
>
> There are tons of other packages on there though! So when you are making your own Elm programs locally, it will probably involve running some commands like this in the terminal:
>
>    elm init --embed
>    elm install elm/random
>    elm install elm/http
>
> That would set up a small project with `elm/random` and `elm/http` as dependencies.
>
> I will be mentioning the packages we are using in the following examples, so I hope this gives some context on what that is all about.