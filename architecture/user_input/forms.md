# Forms

```elm
import Html exposing (..)
import Html.App as Html
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)
import String


main =
  Html.simpleProgram { model = model, view = view, update = update }


-- MODEL

type alias Model =
  { name : String
  , password : String
  , passwordAgain : String
  }


model : Model
model =
  Model "" "" ""


-- UPDATE

type Msg
    = Name String
    | Password String
    | PasswordAgain String


update : Msg -> Model -> Model
update action model =
  case action of
    Name name ->
      { model | name = name }

    Password password ->
      { model | password = password }

    PasswordAgain password ->
      { model | passwordAgain = password }


-- VIEW

view : Model -> Html Msg
view model =
  div []
    [ field Name "text" "User Name" model.name
    , field Password "password" "Password" model.password
    , field PasswordAgain "password" "Re-enter Password" model.passwordAgain
    , div [] [viewValidation model]
    ]

field : (String -> Msg) -> String -> String -> String -> Html Msg
field toMsg fieldType name content =
  div []
    [ div [] [text name]
    , input [ type' fieldType, value content, onInput toMsg ] []
    ]

viewValidation : Model -> Html msg
viewValidation model =
  let
    (color, message) =
      if model.password == model.passwordAgain then
        ("green", "OK")
      else
        ("red", "Passwords do not match!")
  in
    span
      [ style [("color", color)] ]
      [ text message ]
```