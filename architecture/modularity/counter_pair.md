# Pair of Counters

**[Run Locally](https://github.com/evancz/elm-architecture-tutorial/)**

The very first thing we created with The Elm Architecture was [a simple counter](../user_input/buttons.md) that you could increment and decrement. In this example, we will:

  1. Turn our counter code into a *module* that can be reused again and again.
  2. Use that module to make a pair of counters. The counters can be changed independently, and we will have a reset button to put them both back to zero.

We will start with the `Counter` module.


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

Okay, so far so good. Now we should figure out what kinds of messages we may get from user interactions. We know we need to handle the reset button. We also need to be able to handle all the messages produced by the top and bottom counters.

```elm
type Msg
  = Reset
  | Top Counter.Msg
  | Bottom Counter.Msg
```

We represent `Reset` like normal. The `Top` and `Bottom` cases are a bit different. They are saying we will get counter messages from the top and bottom counters. The cool thing is that we do not need to know any details of a `Counter.Msg`. All we know is that we have one.

Let&rsquo;s see how this plays out in our `update` function:

```elm
update : Msg -> Model -> Model
update message model =
  case message of
    Reset ->
      init 0 0

    Top msg ->
      { model | topCounter = Counter.update msg model.topCounter }

    Bottom msg ->
      { model | bottomCounter = Counter.update msg model.bottomCounter }
```

When we get a `Reset` message, we just set everything back to zero. When we get a `Top` message, we only have one thing we really *can* do. The `Counter.update` function is the only thing exposed by `Counter` that lets us handle a `Counter.Msg`.  So we call `Counter.update` on the top counter. This gives us a new `Counter.Model` which we place in our model. We do exactly the same thing for the bottom counter. Just pass the message along to the code that knows how to deal with it.

This architecture means that when someone adds a ton of new features to `Counter` in three years, our code here will keep working exactly the same. All those details are locked inside the `Counter` module.

Finally, we should make a `view` function.

```elm
view : Model -> Html Msg
view model =
  div
    []
    [ App.map Top (Counter.view model.topCounter)
    , App.map Bottom (Counter.view model.bottomCounter)
    , button [ onClick Reset ] [ text "RESET" ]
    ]
```

We create a `<button>` just like normal for resetting the counters. The other two entries are where all the interesting stuff happens.

The first thing to notice is that we rely on the implementation provided by `Counter` to do the heavy lifting. To render `topCounter` and `bottomCounter` we just call `Counter.view`. So when we evaluate `(Counter.view model.topCounter)` we will produce a value of type `Html Counter.Msg`. This means it is a chunk of HTML that can produce counter messages.

We cannot be producing `Counter.Msg`. We need *our* kind of `Msg`. We need to use one of the following functions to create a `Msg` that will work with our `update` function:

```elm
Top : Counter.Msg -> Msg
Bottom : Counter.Msg -> Msg
```

This brings us to the [`Html.App.map`](http://package.elm-lang.org/packages/elm-lang/html/latest/Html-App#map) function:

```elm
Html.App.map : (a -> msg) -> Html a -> Html msg
```

This function lets us say, we have this HTML that was going to produce `a` values, but let&rsquo;s transform all of those to be `msg` values. So when the top counter produces an `Increment` message, it will get wrapped up as `Top Increment` before it is passed into our `update` function. This lets us route the message to the appropriate counter.

The basic pattern here is:

  1. Create a **strong contract** that follows The Elm Architecture to wrap up a &ldquo;component&rdquo;.
  2. Build everything you need in terms of other people&rsquo;s work. You need a model, use theirs. You need to update that model, use their `update` function. Need a view? Use theirs.


> **Exercises:** This code will make more sense if you start playing around with it, so here are a few ideas of how to extend what we have now.
> 
> First, just add a button that swaps the two counters.
> 
> Okay, now add some of the following features to the `Counter` module:
>
>   - Track the maximum number reached.
>   - Track the minimum number reached.
>   - Count how many times the user has clicked one of the buttons
>
> Now the only rule here is **you *cannot* touch the parent module**. You need to implement all these features by changing the `Counter` module only. The pair of counters should just keep working with no changes.