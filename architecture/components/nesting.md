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

By creating a **strong contract**, we give ourselves the freedom to change and evolve our code more efficiently. When working in a large team setting, these contracts can be an extremely powerful way of collaborating. If you create a contract at the beginning of your project (much like the `Counter` module does) you can split off into two groups. One to make the `Counter` and one to pretend it is done and work on the code that uses it.

Speaking of the code that uses it, let&rsquo;s take a look!


## A Pair of Counters

[The counter pair code](https://github.com/evancz/elm-architecture-tutorial/blob/master/nesting/1-counter-pair.elm) starts by importing the `Counter` module:

```elm
import Counter
```

This gives us access to `Counter.Model`, `Counter.init`, etc. so we can use these things without knowing how they work. From there, it is exactly like all the code we have written before. We just follow The Elm Architecture.

So let&rsquo;s start by guessing at the model. We know we want to have two counters. We also know that we already have a complete representation of a counter thanks to the `Counter.Model` type. So let&rsquo;s just reuse that:

```elm
type alias Model =
  { topCounter : Counter.Model
  , bottomCounter : Counter.Model
  }
```

Our model is a top counter and a bottom counter. Now let&rsquo;s write an `init` to create a new pair of counters:

```elm
init : Int -> Int -> Model
init top bottom =
  { topCounter = Counter.init top
  , bottomCounter = Counter.init bottom
  }
```

The `Counter` module gives us exactly one way to create a `Counter.Model` so that is what we have to use. You give `Counter.init` an integer, it gives you a `Counter.Model`.


```elm
type Msg
  = Reset
  | Top Counter.Msg
  | Bottom Counter.Msg


update : Msg -> Model -> Model
update msg model =
  case msg of
    Reset ->
      init 0 0

    Top topMsg ->
      let
        newCounter =
          Counter.update topMsg model.topCounter
      in
        { model | topCounter = newCounter }

    Bottom bottomMsg ->
      let
        newCounter =
          Counter.update bottomMsg model.bottomCounter
      in
        { model | bottomCounter = newCounter }
```