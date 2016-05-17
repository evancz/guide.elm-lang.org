# List of Counters

**[Run Locally](https://github.com/evancz/elm-architecture-tutorial/)**

In this example we will make a *list* of counters. You will be able to create and destroy counters as you please.


## Overall Approach

In the last example, we saw a pair of counters. The `Counter` module created a abstraction barrier, allowing us to use counters without knowing any of their internal details. To get two counters, we had two entries in our model. But if we want the user to be able to add unlimited counters, we cannot just keep adding fields to our model by hand!

So to have a list of counters, **we will associate each counter with a unique ID**. This will allow us to refer to each counter uniquely. &ldquo;Please update counter 42 with this message.&rdquo; or &ldquo;Please delete counter 13.&rdquo;

The code in this example is really just an exercise in instantiating that core trick into code.


## The Code

Like in the last example, we start by importing the `Counter` module.

```elm
import Counter
```

We will be relying on the exact same `Counter` module as in the last example. Yay, reuse! You can check out [that code](https://github.com/evancz/elm-architecture-tutorial/blob/master/nesting/Counter.elm) again, but all you need to know is that it exposes `Model`, `Msg`, `init`, `update`, and `view`.

From there, we will set up our model which tracks a list of counters with unique IDs:

```elm
type alias Model =
  { counters : List IndexedCounter
  , uid : Int
  }

type alias IndexedCounter =
  { id : Int
  , model : Counter.Model
  }
```

The `IndexedCounter` type represents a particular counter. It is a unique ID and the model of a counter. Our actual `Model` is a list of these indexed counters and `uid` which keeps track of the &ldquo;next&rdquo; unique ID we have to hand out. Our `init` will create an empty model like this:

```elm
init : Model
init =
  { counters = []
  , uid = 0
  }
```

No counters and the first ID we will hand out is zero.

Now that we have a model, we need to figure out how to update it. Our requirements are pretty simple. First, we want to be able to add and remove counters. Second, we need to be able to update each of those counters independently. Our `Msg` type covers these three cases:

```elm
type Msg
  = Insert
  | Remove
  | Modify Int Counter.Msg
```

Notice that `Modify` holds an `Int` and a `Counter.Msg`. This way we can refer to the unique ID of a particular counter, ensuring the messages get to the right place. From there, we do our `update` function:

```elm
update : Msg -> Model -> Model
update message ({counters, uid} as model) =
  case message of
    Insert ->
      { model
        | counters = counters ++ [ IndexedCounter uid (Counter.init 0) ]
        , uid = uid + 1
      }

    Remove ->
      { model | counters = List.drop 1 counters }

    Modify id msg ->
      { model | counters = List.map (updateHelp id msg) counters }


updateHelp : Int -> Counter.Msg -> IndexedCounter -> IndexedCounter
updateHelp targetId msg {id, model} =
  IndexedCounter id (if targetId == id then Counter.update msg model else model)
```

Let&rsquo;s say a few words about each case:

  - `Insert` &mdash; First we create a new counter with `Counter.init` and pair it with the latest unique ID. The new model for our app is the result of adding that new counter to our list and incrementing the &ldquo;next&rdquo; ID.

  - `Remove` &mdash; Just remove one counter from the list.

  - `Modify` &mdash; Go through the counters, and update when you find the one with a matching ID.

> **Note:** It might be better to use a data structure like `Dict` here so that updating individual counters is quicker. I have kept it simple for the sake of this guide though.

Finally we get to the `view`:

```elm
view : Model -> Html Msg
view model =
  let
    remove =
      button [ onClick Remove ] [ text "Remove" ]

    insert =
      button [ onClick Insert ] [ text "Add" ]

    counters =
      List.map viewIndexedCounter model.counters
  in
    div [] ([remove, insert] ++ counters)


viewIndexedCounter : IndexedCounter -> Html Msg
viewIndexedCounter {id, model} =
  App.map (Modify id) (Counter.view model)
```

We need buttons for adding and removing counters. Those work like normal. The kind of new thing here is the `viewIndexedCounter` helper. It uses the `Counter.view` function to actually generate HTML, and then uses [`Html.App.map`](http://package.elm-lang.org/packages/elm-lang/html/latest/Html-App#map) to associate any counter messages with their unique ID. From there, we use `List.map` to turn all of our indexed counters into HTML nodes like the add and remove buttons.