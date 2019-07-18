# Random

---
#### [Clone the code](https://github.com/evancz/elm-architecture-tutorial/) or follow along in the [online editor](https://elm-lang.org/examples/numbers).
---

So far we have only seen commands to make HTTP requests, but we can command other things as well, like generating random values! So we are going to make an app that rolls dice, producing a random number between 1 and 6.

We need the [`elm/random`][readme] package for this. The [`Random`][random] module in particular. Let&rsquo;s start by just looking at all the code:

[readme]: https://package.elm-lang.org/packages/elm/random/latest
[random]: https://package.elm-lang.org/packages/elm/random/latest/Random

```elm
import Browser
import Html exposing (..)
import Html.Events exposing (..)
import Random



-- MAIN


main =
  Browser.element
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
    [ h1 [] [ text (String.fromInt model.dieFace) ]
    , button [ onClick Roll ] [ text "Roll" ]
    ]
```

The new thing here is command issued in the `update` function:

```elm
Random.generate NewFace (Random.int 1 6)
```

Generating random values works a bit different than in languages like JavaScript, Python, Java, etc. So let&rsquo;s see how it works in Elm!


## Random Generators

The core idea is that we have random `Generator` that describes _how_ to generate a random value. For example:

```elm
import Random

probability : Random.Generator Float
probability =
  Random.float 0 1

roll : Random.Generator Int
roll =
  Random.int 1 6

usuallyTrue : Random.Generator Bool
usuallyTrue =
  Random.weighted (80, True) [ (20, False) ]
```

So here we have three random generators. The `roll` generator is saying it will produce an `Int`, and more specifically, it will produce an integer between `1` and `6` inclusive. Likewise, the `usuallyTrue` generator is saying it will produce a `Bool`, and more specifically, it will be true 80% of the time.

The point is that we are not actually generating the values yet. We are just describing _how_ to generate them. From there you use the [`Random.generate`][gen] to turn it into a command:

```elm
generate : (a -> msg) -> Generator a -> Cmd msg
```

When the command is performed, the `Generator` produces some value, and then that gets turned into a message for your `update` function. So in our example, the `Generator` produces a value between 1 and 6, and then it gets turned into a message like `NewFace 1` or `NewFace 4`. That is all we need to know to get our random dice rolls, but generators can do quite a bit more!

[gen]: https://package.elm-lang.org/packages/elm/random/latest/Random#generate


## Combining Generators

Once we have some simple generators like `probability` and `usuallyTrue`, we can start snapping them together with functions like [`map3`](https://package.elm-lang.org/packages/elm/random/latest/Random#map3). Imagine we want to make a simple slot machine. We could create a generator like this:

```elm
import Random

type Symbol = Cherry | Seven | Bar | Grapes

symbol : Random.Generator Symbol
symbol =
  Random.uniform Cherry [ Seven, Bar, Grapes ]

type alias Spin =
  { one : Symbol
  , two : Symbol
  , three : Symbol
  }

spin : Random.Generator Spin
spin =
  Random.map3 Spin symbol symbol symbol
```

We first create `Symbol` to describe the pictures that can appear on the slot machine. We then create a random generator that generates each symbol with equal probability.

From there we use `map3` to combine them into a new `spin` generator. It says to generate three symbols and then put them together into a `Spin`.

The point here is that from small building blocks, we can create a `Generator` that describes pretty complex behavior. And then from our application, we just have to say something like `Random.generate NewSpin spin` to get the next random value.


> **Exercises:** Here are a few ideas to make the example code on this page a bit more interesting!
>
>   - Instead of showing a number, show the die face as an image.
>   - Instead of showing an image of a die face, use [`elm/svg`][svg] to draw it yourself.
>   - Create a weighted die with [`Random.weighted`][weighted].
>   - Add a second die and have them both roll at the same time.
>   - Have the dice flip around randomly before they settle on a final value.

[svg]: https://package.elm-lang.org/packages/elm/svg/latest/
[weighted]: https://package.elm-lang.org/packages/elm/random/latest/Random#weighted
