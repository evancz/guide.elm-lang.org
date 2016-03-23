# Text Fields

In the last section we made a counter with increment and decrement buttons.

```elm
import Html exposing (Html, Attribute, div, input, text)
import Html.App as Html
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)
import String


main =
  Html.simpleProgram { model = model, view = view, update = update }


-- MODEL

type alias Model =
  { input : String
  }

model =
  Model ""


-- UPDATE

type Msg
  = Input String

update : Msg -> Model -> Model
update (Input newInput) model =
  { model | input = newInput }


-- VIEW

view : Model -> Html Msg
view model =
  div []
    [ input [ placeholder "Text to reverse", value model.input, onInput Input ] []
    , div [] [ text (String.reverse string) ]
    ]

```