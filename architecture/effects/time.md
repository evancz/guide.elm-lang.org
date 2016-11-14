# Time

---
#### [Clone the code](https://github.com/evancz/elm-architecture-tutorial/) or follow along in the [online editor](http://elm-lang.org/examples/time).
---

We are going to make a simple clock.

So far we have focused on commands. With the randomness example, we *asked* for a random value. With the HTTP example, we *asked* for info from a server. That pattern does not really work for a clock. In this case, we want to sit around and hear about clock ticks whenever they happen. This is where **subscriptions** come in.

The code is not too crazy here, so I am going to include it in full. After you read through, we will come back to normal words that explain it in more depth.

```elm
import Html exposing (Html)
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Time exposing (Time, second)



main =
  Html.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }


-- MODEL

type alias Model = Time


init : (Model, Cmd Msg)
init =
  (0, Cmd.none)


-- UPDATE

type Msg
  = Tick Time


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Tick newTime ->
      (newTime, Cmd.none)


-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
  Time.every second Tick


-- VIEW

view : Model -> Html Msg
view model =
  let
    angle =
      turns (Time.inMinutes model)

    handX =
      toString (50 + 40 * cos angle)

    handY =
      toString (50 + 40 * sin angle)
  in
    svg [ viewBox "0 0 100 100", width "300px" ]
      [ circle [ cx "50", cy "50", r "45", fill "#0B79CE" ] []
      , line [ x1 "50", y1 "50", x2 handX, y2 handY, stroke "#023963" ] []
      ]

```

There is nothing new in the `MODEL` or `UPDATE` sections. Same old stuff. The `view` function is kind of interesting. Instead of using HTML, we use the `Svg` library to draw some shapes. It works just like HTML though. You provide a list of attributes and a list of children for every node.

The important thing comes in `SUBSCRIPTIONS` section. The `subscriptions` function takes in the model, and instead of returning `Sub.none` like in the examples we have seen so far, it gives back a real life subscription! In this case `Time.every`:

```elm
Time.every : Time -> (Time -> msg) -> Sub msg
```

The first argument is a time interval. We chose to get ticks every second. The second argument is a function that turns the current time into a message for the `update` function. We are tagging times with `Tick` so the time 1458863979862 would become `Tick 1458863979862`.

That is all there is to setting up a subscription! These messages will be fed to your `update` function whenever they become available.


> **Exercises:**
>
>   - Add a button to pause the clock, turning the `Time` subscription off.
>   - Make the clock look nicer. Add an hour and minute hand. Etc.