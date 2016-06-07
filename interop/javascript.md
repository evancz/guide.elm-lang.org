# JavaScript Interop

At some point your Elm program is probably going to need to talk to JavaScript. We do this by sending messages back and forth between Elm and JavaScript:

![](interop.png)

This way we can have access to full power of JavaScript, the good and the bad, without giving up on all the things that are nice about Elm.

## Ports

Any communication with JavaScript goes through a *port*. Think of it like a hole in the side of your Elm program where you can plug stuff in. We will explore how ports work with the following scenario: we want to send words to some spell-checking library in JavaScript. When that library produces suggestions, we want to send them back into Elm.

Assuming you know [how to embed Elm in HTML](html.md), let's start with the JavaScript code we would add to react to messages coming through ports:

```javascript
var app = Elm.Spelling.fullscreen();

app.ports.check.subscribe(function(word) {
    var suggestions = spellCheck(word);
    app.ports.suggestions.send(suggestions);
});
```

We start by initializing our Elm program that has two ports: `check` and `suggestions`. Strings will be coming out of the `check` port, so we `subscribe` to those messages. Whenever we get a word, our callback is going to run it through our spell-checking library and then feed the result back to Elm through the `suggestions` port.

On the Elm side, we have a program like this:

```elm
port module Spelling exposing (..)

import Html exposing (..)
import Html.App as Html
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import String


main =
  Html.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }


-- MODEL

type alias Model =
  { word : String
  , suggestions : List String
  }

init : (Model, Cmd Msg)
init =
  (Model "" [], Cmd.none)


-- UPDATE

type Msg
  = Change String
  | Check
  | Suggest (List String)


port check : String -> Cmd msg

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Change newWord ->
      ( Model newWord [], Cmd.none )

    Check ->
      ( model, check model.word )

    Suggest newSuggestions ->
      ( Model model.word newSuggestions, Cmd.none )


-- SUBSCRIPTIONS

port suggestions : (List String -> msg) -> Sub msg

subscriptions : Model -> Sub Msg
subscriptions model =
  suggestions Suggest


-- VIEW

view : Model -> Html Msg
view model =
  div []
    [ input [ onInput Change ] []
    , button [ onClick Check ] [ text "Check" ]
    , div [] [ text (String.join ", " model.suggestions) ]
    ]
```

The two new and important lines are:

```elm
port check : String -> Cmd msg

port suggestions : (List String -> msg) -> Sub msg
```

The first one is creating a port named `check`. You can `subscribe` to it on the JavaScript side. In Elm, we have access to it with the function `check : String -> Cmd msg` which takes strings and turns them into the command "give this string to JavaScript".

The second one is creating a port named `suggestions`. This one is a subscription in Elm though. So you give a function that says "whenever I get a list of strings from JavaScript, convert it into some message my app will understand". On the JavaScript side you can `send` to this port to get values into Elm.

So talking to JavaScript uses the same command and subscription pattern we saw used for HTTP and Web Sockets in the Elm Architecture. Pretty cool!


## Customs and Border Protection

Ports must be careful about what values are allowed through. Elm is statically typed, so each port is fitted with some border protection code that ensures that type errors are kept out. Ports also do some conversions so that you get nice colloquial data structures in both Elm and JS.

The particular types that can be sent in and out of ports is quite flexible, covering [all valid JSON values](http://www.json.org/). Specifically, incoming ports can handle all the following Elm types:

  * **Booleans and Strings** &ndash; both exist in Elm and JS!
  * **Numbers** &ndash; Elm ints and floats correspond to JS numbers
  * **Lists**   &ndash; correspond to JS arrays
  * **Arrays**  &ndash; correspond to JS arrays
  * **Tuples**  &ndash; correspond to fixed-length, mixed-type JS arrays
  * **Records** &ndash; correspond to JavaScript objects
  * **Maybes**  &ndash; `Nothing` and `Just 42` correspond to `null` and `42` in JS
  * **Json**    &ndash; [`Json.Encode.Value`](http://package.elm-lang.org/packages/elm-lang/core/latest/Json-Encode#Value) corresponds to arbitrary JSON

All conversions are symmetric and type safe. If someone tries to give a badly typed value to Elm it will throw an error in JS immediately. By having a border check like this, Elm code can continue to guarantee that you will never have type errors at runtime.


## Usage Advice

I showed an example where the ports were declared in the root module. This is not a strict requirement. You can actually create a `port module` that gets imported by various parts of your app.

It seems like it is probably best to just have one `port module` for your project so it is easier to figure out the API on the JavaScript side. I plan to improve tooling such that you can just ask though.

> **Note:** Port modules are not permitted in the package repository. Imagine you download an Elm package and it just doesn't work. You read the docs and discover you *also* need to get some JS code and hook it up properly. Lame. Bad experience. Now imagine if you had this risk with *every* package out there. It just would feel crappy. So we do not allow that.



## Historical Context

Now I know that this is not the typical interpretation of *language interop*. Usually languages just go for full backwards compatibility. So C code can be used *anywhere* in C++ code. You can replace C/C++ with Java/Scala or JavaScript/TypeScript. This is the easiest solution, but it forces you to make quite extreme sacrifices in the new language. All the problems of the old language now exist in the new one too. Hopefully less though.

Elm's interop is built on the observation that **by enforcing some architectural rules, you can make full use of the old language *without* making sacrifices in the new one.** This means we can keep making guarantees like "you will not see runtime errors in Elm" even as you start introducing whatever crazy JavaScript code you need.

So what are these architectural rules? Turns out it is just The Elm Architecture. Instead of embedding arbitrary JS code right in the middle of Elm, we use commands and subscriptions to send messages to external JavaScript code. So just like how the `WebSocket` library insulates you from all the crazy failures that might happen with web sockets, port modules insulate you from all the crazy failures that might happen in JavaScript. **It is like JavaScript-as-a-Service.**
