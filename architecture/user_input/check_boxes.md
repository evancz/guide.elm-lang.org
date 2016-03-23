# Check Boxes

```elm
import Html exposing (Html, Attribute, text, toElement, div, input)
import Html.App as Html
import Html.Attributes exposing (..)
import Html.Events exposing (onCheck)


main =
  Html.simpleProgram { model = model, view = view, update = update }


-- MODEL

type alias Model =
  { red : Bool
  , underline : Bool
  , bold : Bool
  }

initialModel =
  Model False False True


-- UPDATE

type Msg
  = Red Bool
  | Underline Bool
  | Bold Bool

update : Msg -> Model -> Model
update msg model =
  case msg of
    Red bool ->
        { model | red = bool }

    Underline bool ->
        { model | underline = bool }

    Bold bool ->
        { model | bold = bool }


-- VIEW

view : Model -> Html Msg
view model =
  div []
    [ div [toStyle model] [text "Hello, how are you?!"]
    , checkbox Red "red" model.red
    , checkbox Underline "underline" model.underline
    , checkbox Bold "bold" model.bold
    ]

toStyle : Model -> Attribute msg
toStyle model =
  style
    [ ("color", if model.red then "red" else "black")
    , ("text-decoration", if model.underline then "underline" else "none")
    , ("font-weight", if model.bold then "bold" else "normal")
    ]

checkbox : (Bool -> Msg) -> String -> Bool -> Html Msg
checkbox tagger name isChecked =
  div []
    [ input [ type' "checkbox", checked isChecked, onCheck tagger ] []
    , text name
    ]
```