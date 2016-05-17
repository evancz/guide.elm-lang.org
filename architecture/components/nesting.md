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

This is creating a module called `Counter` that publicly exposes a limited subset of details. For example, an outsider will know that the `Msg` type exists, but they will not know that `Increment` and `Decrement` are the only values of this type. This means that it is *impossible* for an outsider to write code dependent on the particulars of a `Msg`. So the maintainer of the `Counter` module is free to add and remove messages with no risk of breaking code far away. These details are private. As another example, an outsider is able to use `view` without knowing about the `countStyle` helper function. We could add twenty helper functions, but all you would see from the outside is `init`, `update`, and `view`. Again, this gives the maintainer of the `Counter` module the freedom to change the implementation dramatically without breaking tons of far away code in surprising ways.



It is only exposing the definitions necessary for The Elm Architecture.

From there you create the "parent" module and import the "child".

```elm
module CounterPair exposing (..)

import Counter

type alias Model =
  { top : Counter.Model
  , bottom : Counter.Model
  }
  
...
```

Whenever you have to deal with a `Counter.Model` you use the relevant publicly exposed functions.

You can check out some full examples of this in the `nesting/` directory of [this repo](https://github.com/evancz/elm-architecture-tutorial).