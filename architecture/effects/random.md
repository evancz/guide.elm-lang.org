# Random

---
#### [Clone the code](https://github.com/evancz/elm-architecture-tutorial/) or follow along in the [online editor](https://elm-lang.org/examples/random).
---

We are going to make an app that rolls dice, producing a random number between 1 and 6.

Let&rsquo;s start by installing the [`elm/random`][readme] package in our project:

```bash
elm install elm/random
```

Now we can `import Random` and use anything in the [`Random`][random] module. We need to do that for our dice rolling program:

[readme]: https://package.elm-lang.org/packages/elm/random/latest
[random]: https://package.elm-lang.org/packages/elm/random/latest/Random

```elm
import Browser
import Html exposing (..)
import Html.Events exposing (..)
import Random



-- MAIN


main =
  Html.program
    { init = init
    , update = update
    , subscriptions = subscriptions
    , view = view
    }



-- MODEL


type alias Model =
  { dieFace : Int
  }


init : () -> (Model, Cmd Msg)
init _ =
  ( Model 1
  , Cmd.none
  )



-- UPDATE


type Msg
  = Roll
  | NewFace Int


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Roll ->
      ( model
      , Random.generate NewFace (Random.int 1 6)
      )

    NewFace newFace ->
      ( Model newFace
      , Cmd.none
      )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none



-- VIEW


view : Model -> Html Msg
view model =
  div []
    [ h1 [] [ text (toString model.dieFace) ]
    , button [ onClick Roll ] [ text "Roll" ]
    ]
```

Now there are a couple new things in this program. Let&rsquo;s work through them!


## `update`

In the previous examples, the `update` function just produced a new `Model`. The new code is doing a bit more:

```elm
update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Roll ->
      ( model
      , Random.generate NewFace (Random.int 1 6)
      )

    NewFace newFace ->
      ( Model newFace
      , Cmd.none
      )
```

Rather than just giving a new `Model`, we are now producing commands as well. That is what that `Cmd Msg` type means. So when `update` gets a message to `Roll` a new number we:

1. Give back the `model` without changes. Nothing to do right now.
2. Create a command to generate a random integer between `1` and `6`.

This data goes to Elm&rsquo;s runtime system (RTS) which turns it into effects. So for these two cases:

1. When the RTS gets a new `Model`, it calls your `view` function. Does the DOM need to change? In this case, it does not!
2. When the RTS gets a command, it immediately starts working on it. In this case, the RTS generates a random number and sends a message like `NewFace 3` or `NewFace 5` back to our `update` function. So `Cmd Msg` is saying &ldquo;this is a command for the RTS, and the RTS will give us back a `Msg` about what happened.&rdquo;

Now when the RTS gives us a message like `NewFace 3` it will trigger the second branch of our `update` function. In this case, we update our `Model` with the new value and give [`Cmd.none`](https://package.elm-lang.org/packages/elm/core/latest/Platform-Cmd#none) to the RTS to indicate that we have no commands this time.

> **Aside:** One crucial detail here is that **commands are data**. So just because you create a command does not mean it is happening. Here are some analogies:
>
> - Maybe you find a cake recipe (command) on the internet. It outlines exactly how to make a delicious cake. You have to give it to a baker (RTS) to actually turn it into a cake!
> - Maybe you have a grocery list (command) on your fridge. You need a sack of potatoes. You can only get those potatoes if you (RTS) go to the store and buy them!
> - Maybe I tell you to eat an entire watermelon in one bite (command) right this second. Did you do it? No! You (RTS) kept reading before you even *thought* about buying a tiny watermelon.
>
> None of these analogies are perfect, particularly because the Elm runtime system is much more reliable than you or a baker! When you give it a command, it starts working on it immediately and it follows your exact directions. Metaphorically, it is a very efficient baker that never deviates from the recipe.


## `init`

In previous examples, `init` was a value specifying the initial `Model` for our Elm program. In our new version, it is a function:

```elm
init : () -> (Model, Cmd Msg)
init _ =
  ( Model 1
  , Cmd.none
  )
```

Like our new `update` function, we are now producing (1) a new model and (2) some commands for the RTS. In our dice rolling program, we give `Cmd.none` because we do not need to do anything on initialization, but later you may want to do things like trigger HTTP requests from here.

> **Note:** Why is it taking that `()` argument though? We are just ignoring it. What is the point? Well, one of the other changes in this program is that we switched from [`Browser.sandbox`][sandbox] to [`Browser.embed`][embed]. That is what enables the extra command features we have been looking at so far. It _also_ allows the program to get &ldquo;flags&rdquo; from JavaScript on initialization. So the `()` is saying that we are not getting any interesting flags for our program. We will talk about this more later!

[sandbox]: https://package.elm-lang.org/packages/elm/browser/latest/Browser#sandbox
[embed]: https://package.elm-lang.org/packages/elm/browser/latest/Browser#embed


## `subscriptions`

The final new thing that we need to specify if we subscribe to anything. For now we are saying [`Sub.none`](https://package.elm-lang.org/packages/elm/core/latest/Platform-Sub#none) to indicate that there are no subscriptions. We will get into subscriptions in one of the next examples!


# Summary


So the big lessons here are:

  - Write your programs bit by bit. Start with a simple skeleton, and gradually add the tougher stuff.
  - The `update` function now produces a new model *and* a command.
  - You cannot just get random values willy-nilly. You create a command, and Elm will go do some work behind the scenes to provide it for you. In fact, any time our program needs to get unreliable values (randomness, HTTP, file I/O, database reads, etc.) you have to go through Elm.

At this point, the best way to improve your understanding of commands is just to see more of them! They will appear prominently with the `Http` and `WebSocket` libraries, so if you are feeling shaky, the only path forward is practicing with randomness and playing with other examples of commands!

> **Exercises:** Here are some that build on stuff that has already been introduced:
>
>   - Instead of showing a number, show the die face as an image.
>   - Add a second die and have them both roll at the same time.
>
> And here are some that require new skills:
>
>   - Instead of showing an image of a die face, use the `elm-lang/svg` library to draw it yourself.
>   - After you have learned about tasks and animation, have the dice flip around randomly before they settle on a final value.


