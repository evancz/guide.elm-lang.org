# Pair of Counters

**[Run Locally](https://github.com/evancz/elm-architecture-tutorial/)**

The very first thing we created with The Elm Architecture was [a simple counter](../user_input/buttons.md) that you could increment and decrement. In this example, we will:

  1. Turn our counter code into a *module* that can be reused again and again.
  2. Use that module to make a pair of counters.

This will be the foundation for all sorts of other tricks.


## The Counter Module

Take a moment to check out [the `Counter` module](https://github.com/evancz/elm-architecture-tutorial/blob/master/nesting/Counter.elm). The code is *very* similar to what we had before. We could even add a `main` to this and start it up as is. The key thing to notice right now is [the module declaration](https://github.com/evancz/elm-architecture-tutorial/blob/master/nesting/Counter.elm#L1):

```elm
module Counter exposing ( Model, Msg, init, update, view )
```

This is creating a module called `Counter` that publicly exposes a limited subset of details. When used effectively, **modules create strong contracts.** I will do exactly X and Y. Do not worry about how I do it. Do not worry about if I change how I do it. All you need to know is that X and Y will work as we agreed.

As an example from our `Counter` module, an outsider will know that the `Msg` type exists, but they will not know that `Increment` and `Decrement` are the only values of this type. This means that it is *impossible* for an outsider to write code dependent on the particulars of a `Msg`. So the maintainer of the `Counter` module is free to add and remove messages with no risk of breaking code far away. These details are private.

As another example, an outsider is able to use `view` without knowing about the `countStyle` helper function. We could add twenty helper functions, but all you would see from the outside is `init`, `update`, and `view`. Again, this gives the maintainer of the `Counter` module the freedom to change the implementation dramatically without breaking tons of far away code in surprising ways.

By creating a **strong contract**, we give ourselves the freedom to change and evolve our code more efficiently. When working in a large team setting, these contracts can be an extremely powerful way of collaborating. If you create a contract at the beginning of your project (much like the `Counter` module does) you can split off into two groups. One to make the `Counter` and one to pretend it is done and work on the code it is embedded in.

Speaking of the code it is embedded in.


## A Pair of Counters

