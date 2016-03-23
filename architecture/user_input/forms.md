# Forms

Here we will make a rudimentary form. It has a field for your name, a field for your password, and a field to verify that password. We will also do some very simple validation (do the two passwords match?) just because it is simple to add.

The code is a bit longer in this case, but I still think it is valuable to look through it before you get into the description of what is going on.

```elm
import Html exposing (..)
import Html.App as Html
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)


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
    [ input [ type' "text", placeholder "Name", onInput Name ] []
    , input [ type' "password", placeholder "Password", onInput Password ] []
    , input [ type' "password", placeholder "Re-enter Password", onInput PasswordAgain ] []
    , viewValidation model
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
    div
      [ style [("color", color)] ]
      [ text message ]
```

This is pretty much exactly our [text field example](TODO) looked, just with more fields. Let's walk through how it came to be!

As always, you start out by guessing at the `Model`. We know there are going to be three text fields, so let's just go with that:

```elm
type alias Model =
  { name : String
  , password : String
  , passwordAgain : String
  }
```

Great, seems reasonable. We expect that each of these fields can be changed separately, so our messages should account for each of those scenarios.

```elm
type Msg
    = Name String
    | Password String
    | PasswordAgain String
```

This means our `update` is pretty mechanical. Just update the relevant field:

```elm
update : Msg -> Model -> Model
update action model =
  case action of
    Name name ->
      { model | name = name }

    Password password ->
      { model | password = password }

    PasswordAgain password ->
      { model | passwordAgain = password }
```

We get a little bit fancier than normal in our `view` though. It all starts out normal. We create a `<div>` and put a couple `<input>` nodes in it. Each one has an `onInput` attribute that will tag any changes appropriately for our `update` function. (This is all building off of the text field example in the previous section.)

But for the last child we do not directly use an HTML function. Instead we call the `viewValidation` function, passing in the current model. This function compares the two passwords and produces a `<div>` filled with a colorful message explaining the situation.

One cool thing about breaking `viewValidation` out is that it is pretty easy to augment. If you are messing with the code as you read through this (as you should be!) some fun exercises might are:

  * Check that the password is longer than 8 characters.
  * Make sure the password contains upper case, lower case, and numeric characters.
  * Add an additional field for `age` and check that it is a number.

Be sure to use the helpers in the `String` library if you try any of these!