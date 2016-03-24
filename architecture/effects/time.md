# Time

We are going to make a simple clock.

So far we have focused on commands. With the randomness example, we *asked* for a random value. With the HTTP example, we *asked* for info from a server. That pattern does not really work for a clock. In this case, we want to sit around and hear about clock ticks whenever they happen. This is where **subscriptions** come in.

The code is not too crazy here, so I am going to include it in full. After you read through, we will come back to normal words that explain it in more depth.

```elm
import Html.App as Html
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Time exposing (second)


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
update action model =
  case action of
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
      turns (Time.inMinutes time)

    handX =
      toString (50 + 40 * cos angle)

    handY =
      toString (50 + 40 * sin angle)
  in
    svg [ viewBox="0 0 100 100" ]
      [ circle [ cx "50", cy "50", r "45" ] []
      , line [ x1 "50", y1 "50", x2 handX, y2 handY ] []
      ]
```
