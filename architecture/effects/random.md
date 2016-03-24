# Random


We are about to make an app that "rolls dice", producing a random number between 1 and 6.

When I write code with effects, I usually break it into two phases. Phase one is about getting something on screen, just doing the bare minimum to have something to work from. Phase two is filling in details, gradually approaching the actual goal. We will use this process here too.


## Phase One - The Bare Minimum

As always, you start out by guessing at what your `Model` should be:

```elm
type alias Model =
  { dieFace : Int
  }
```

For now we will just track `dieFace` as an integer between 1 and 6. Then I would quickly sketch out the `view` function because it seems like the easiest next step.

```elm
view : Model -> Html Msg
view model =
  h1 [ onClick Roll ] [ text model.dieFace ]
```

So this is typical. Same stuff we have been doing with the user input examples of The Elm Architecture. When you click our `<h1>` it is going to produce a `Roll` messages, so I guess it is time to take a first pass at the `update` function as well.

```elm
type Msg = Roll

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Roll ->
      (model, Cmd.none)
```

Now the `update` function has the same overall shape as before, but the return type is a bit different. Instead of just giving back a `Model`, it produces both a `Model` and a command. The idea is: **we still want to step the model forward, but we also want to do some stuff.** In our case, we want to ask Elm to give us a random value. For now, I just fill it in with [`Cmd.none`](TODO) which means "I have no commands, do nothing." We will fill this in with the good stuff in phase two.

Finally, I would create an `init` value like this:

```elm
init : (Model, Cmd Msg)
init =
  (Model 1, Cmd.none)
```

Here we specify both the initial model and some commands we'd like to run immediately when the app starts. This is exactly the kind of stuff that `update` is producing now too.

At this point, it is possible to wire it all up and take a look. You can click the `<h1>`, but nothing happens. Let's fix that!


## Phase Two - Adding the Cool Stuff

