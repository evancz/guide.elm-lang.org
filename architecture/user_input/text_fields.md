# Text Fields

**[Demo](http://evancz.github.io/elm-architecture-tutorial/examples/2) / [See Code]()**

We are about to create a simple app that reverses the contents of a text field.

Again this is a pretty short program, so I have included the whole thing here. Skim through to get an idea of how everything fits together. Right after that we will go into much more detail!


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

This code is a slight variant of the counter from the previous section. Same exact model/update/view pattern. The HTML library works the same. The big difference is just in how we filled this skeleton in. Let's walk through that.

As always, you start by figuring out what your `Model` should be. 