# Reviewing The Elm Architecture


## `sandbox`

This chapter started by creating programs with [`Browser.sandbox`][sandbox]. We designed a `Model` and wrote functions to `update` and `view` it.

You can think of `Browser.sandbox` as setting up a system like this:

![](diagrams/sandbox.svg)

We get to stay in the world of Elm, writing functions and transforming data. This hooks up to Elm&rsquo;s **runtime system**. The runtime system figures out how to render `Html` efficiently. Did anything change? What is the minimal DOM modification needed? It also figures out when someone clicks a button or types into a text field. It turns that into a `Msg` and feeds it into your Elm code.

By cleanly separating out all the DOM manipulation, it becomes possible to use extremely aggresive optimizations. So Elm&rsquo;s runtime system is a big part of why Elm is [one of the fastest options available][benchmark].

[sandbox]: https://package.elm-lang.org/packages/elm/browser/latest/Browser#sandbox
[benchmark]: http://elm-lang.org/blog/blazing-fast-html-round-two


## `embed`

From there we started creating programs with [`Browser.embed`][embed]. We were working with `Model`, `update`, and `view` like before, but we introduced the ideas of commands and subscriptions. This allowed us to start interacting with the outside world.

You can think of `Browser.embed` as setting up a system like this:

![](diagrams/embed.svg)

Like before, you get to program in the nice Elm world, but now you can send `Cmd` and `Sub` values as well! This lets you make HTTP requests, ask about the current time, generate random values, etc.

[embed]: https://package.elm-lang.org/packages/elm/browser/latest/Browser#embed


## Who Cares?

Why have this runtime system? Why have these `Html`, `Cmd`, and `Sub` values that we have to mess around with? Why not just have `Math.random()` like in JavaScript?

Well, pretty much everything that is uniquely nice about Elm is a result of separating **computation** from **effects**! For example, you can compile any Elm program with `--debug` and get access to a time-travel debugger. You can go back through all the messages and see the `Model` and UI at that point in time. How is this possible? Well, we can swap out the runtime system entirely:

![](diagrams/debug.svg)

When we go back in time, our `update` is going to run a second time (computation) but it is up to the runtime system to handle the resulting commands (effects). For example, say you have a `Cmd` to tell the database to erase a user. Or add a comment. Or change some values. What happens when your database gets these requests the second time? Out of order? In reverse order? By having the runtime system sitting between your Elm code and the outside world, it is super simple to handle these questions. Do not send HTTP requests when going back in time! We already know the results, and in fact, we need them to be exactly the same when debugging so lets just reuse them!

If you had unmediated access to effects (like `Math.random()` in JavaScript) this would not be possible. Your debugger would be introducing new stuff on replay. Making new HTTP requests. Generating new random values. Printing new stuff in the console. Modifying local state. Etc. There would be no guarantee that running the code a second time would produce the same results.

But to take a step back, separating computation from effects is how we get the **&ldquo;same input, same output&rdquo;** guarantee. No matter how complex the function, when you give it the same arguments, it always gives the same result. **This guarantee is a cornerstone of reliability in Elm.** Testing is simplified. Refactoring is less risky. Adding new code cannot break old code. No sneaky mutation to debug for hours. So time-travel is just one example of many!
