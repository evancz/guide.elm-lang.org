# The Elm Architecture + Reusable Components

So we are doing pretty well so far. We can handle user input. We can make HTTP requests. We can communicate on web sockets. That is a solid start, but **what happens when our code starts getting big?** It would be crazy to just grow your `Model` and `update` functions endlessly. This is where Elm's module system comes in!

The basic idea is: **nest The Elm Architecture pattern again and again.** So you will create modules with a public API like this:

```elm
module Story exposing (Model, Msg, init, update, view, subscriptions)
```

In fact, this is what we have been doing in all the examples so far, just without explicitly adding a `module` declaration.

Once we make it a `module`, anyone can `import` it and use it how they please. And most importantly, they can only see the exposed values like `view`. All of the details of how that is implemented are hidden away.

The following sections will cover:

  - **Nesting** &mdash; How does it actually look when we start nesting modules like this?
  - **Communication** &mdash; Once we have a bunch of nested modules, we may need them to talk amongst themselves. How do design modules that make this pleasant?

Like normal, we do this by stepping through examples.