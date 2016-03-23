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
  { fieldContent : String
  }

model =
  Model ""


-- UPDATE

type Msg
  = Change String

update : Msg -> Model -> Model
update msg model =
  case msg of
    Change newContent ->
      { model | fieldContent = newContent }


-- VIEW

view : Model -> Html Msg
view model =
  div []
    [ input [ placeholder "Text to reverse", onInput Change ] []
    , div [] [ text (String.reverse model.fieldContent) ]
    ]
```

This code is a slight variant of the counter from the previous section. You set up a model. You define some messages. You say how to `update`. You make your `view`. The difference is just in how we filled this skeleton in. Let's walk through that!

As always, you start by guessing at your `Model` should be. In our case, we know we are going to have to keep track of whatever the user has typed into the text field. We need that information so we know how to render the reversed text.

```elm
type alias Model =
  { fieldContent : String
  }
```

This time I chose to represent the model as a record. (You can read more about records [here](TODO).) For now it just has one named field for our user input, so why not use the `String` by itself like we did in the counter example? Starting with a record makes it easy to add more fields as our app gets more complicated. When the time comes where we want *two* text inputs, we will have to do much less fiddling around.

Okay, so we have our model. Now in this app there is only one kind of message really. The user can change the contents of the text field.

```elm
type Msg
  = Change String
```

This means our update function just has to handle this one case:

```elm
update : Msg -> Model -> Model
update msg model =
  case msg of
    Change newContent ->
      { model | fieldContent = newContent }
```

When we receive new content, we use the record update syntax to update the contents of `fieldContent`. We do not *really* need to use this syntax here, but it will make things easier if we end up adding a bunch of fields to our model later.

Finally we need to say how to view our application:

```elm
view : Model -> Html Msg
view model =
  div []
    [ input [ placeholder "Text to reverse", onInput Change ] []
    , div [] [ text (String.reverse model.fieldContent) ]
    ]
```

We create a `<div>` with two children.

The interesting child is the `<input>` node. In addition to the `placeholder` attribute, it uses `onInput` to declare what messages should be sent when the user types into this input. The `onInput` function has this type:

```elm
onInput : (String -> msg) -> Attribute msg
```

This function takes one argument (a function that takes the current content of the text field and turns it into a message for our update function) and produces an HTML attribute we can use like any other. Now our `view` function says `onInput Change`, so if someone types `yolo` into the text field, we will get messages like `Change "yolo"` in our update function. We will make much more use of these tags in our next example!