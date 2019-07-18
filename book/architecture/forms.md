# Forms

---
#### [Clone the code](https://github.com/evancz/elm-architecture-tutorial/) or follow along in the [online editor](https://elm-lang.org/examples/forms).
---

Here we will make a rudimentary form. It has a field for your name, a field for your password, and a field to verify that password. We will also do some very simple validation (do the two passwords match?) just because it is simple to add.

The code is a bit longer in this case, but I still think it is valuable to look through it before you get into the description of what is going on.

```elm
import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)



-- MAIN


main =
  Browser.sandbox { init = init, update = update, view = view }



-- MODEL


type alias Model =
  { name : String
  , password : String
  , passwordAgain : String
  }


init : Model
init =
  Model "" "" ""



-- UPDATE


type Msg
  = Name String
  | Password String
  | PasswordAgain String


update : Msg -> Model -> Model
update msg model =
  case msg of
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
    [ viewInput "text" "Name" model.name Name
    , viewInput "password" "Password" model.password Password
    , viewInput "password" "Re-enter Password" model.passwordAgain PasswordAgain
    , viewValidation model
    ]


viewInput : String -> String -> String -> (String -> msg) -> Html msg
viewInput t p v toMsg =
  input [ type_ t, placeholder p, value v, onInput toMsg ] []


viewValidation : Model -> Html msg
viewValidation model =
  if model.password == model.passwordAgain then
    div [ style "color" "green" ] [ text "OK" ]
  else
    div [ style "color" "red" ] [ text "Passwords do not match!" ]
```

This is pretty similar to our [text field example](text_fields.md), just with more fields. Let's walk through how it came to be!

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
update msg model =
  case msg of
    Name name ->
      { model | name = name }

    Password password ->
      { model | password = password }

    PasswordAgain password ->
      { model | passwordAgain = password }
```

We get a little bit fancier than normal in our `view` though.

```elm
view : Model -> Html Msg
view model =
  div []
    [ viewInput "text" "Name" model.name Name
    , viewInput "password" "Password" model.password Password
    , viewInput "password" "Re-enter Password" model.passwordAgain PasswordAgain
    , viewValidation model
    ]
```

We start by creating a `<div>` with four child nodes. But instead of using functions from `elm/html` directly, we call Elm functions to make our code more concise! We start with three calls to `viewInput`:

```elm
viewInput : String -> String -> String -> (String -> msg) -> Html msg
viewInput t p v toMsg =
  input [ type_ t, placeholder p, value v, onInput toMsg ] []
```

So `viewInput "text" "Name" model.name Name` can create a node like `<input type="text" placeholder="Name" value="Bill">`. That node will also send messages like `Name "Billy"` to `update` on user input.

The fourth entry is more interesting. It is a call to `viewValidation`:

```elm
viewValidation : Model -> Html msg
viewValidation model =
  if model.password == model.passwordAgain then
    div [ style "color" "green" ] [ text "OK" ]
  else
    div [ style "color" "red" ] [ text "Passwords do not match!" ]
```

This function first compares the two passwords. If they match, you get green text and a positive message. If they do not match, you get red text and a helpful message.

These helper functions begin to show the benefits of having our HTML library be normal Elm code. We _could_ put all that code into our `view`, but making helper functions is totally normal in Elm, even in view code. Is this getting hard to understand? Maybe I can break out a helper function!

> **Exercises:** One cool thing about breaking `viewValidation` out is that it is pretty easy to augment. If you are messing with the code as you read through this (as you should be!) you should try to:
>
>  - Check that the password is longer than 8 characters.
>  - Make sure the password contains upper case, lower case, and numeric characters.
>  - Add an additional field for `age` and check that it is a number.
>  - Add a `Submit` button. Only show errors *after* it has been pressed.
>
> Be sure to use the helpers in the [`String`](https://package.elm-lang.org/packages/elm/core/latest/String) module if you try any of these! Also, we need to learn more before we start talking to servers, so make sure you read all the way to the HTTP part before trying that. It will be significantly easier with proper guidance!

> **Note:** It seems like efforts to make generic validation libraries have not been too successful. I think the problem is that the checks are usually best captured by normal Elm functions. Take some args, give back a `Bool` or `Maybe`. E.g. Why use a library to check if two strings are equal? So as far as we know, the simplest code comes from writing the logic for your particular scenario without any special extras. So definitely give that a shot before deciding you need something more complex!
