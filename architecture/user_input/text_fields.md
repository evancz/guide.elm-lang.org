# Text Fields

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
    [ input
        [ placeholder "Text to reverse"
        , value model.input
        , onInput Input
        , myStyle
        ]
        []
    , div [ myStyle ] [ text (String.reverse string) ]
    ]


myStyle : Attribute msg
myStyle =
  style
    [ ("width", "100%")
    , ("height", "40px")
    , ("padding", "10px 0")
    , ("font-size", "2em")
    , ("text-align", "center")
    ]
```