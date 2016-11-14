# Web Sockets

---
#### [Clone the code](https://github.com/evancz/elm-architecture-tutorial/) or follow along in the [online editor](http://elm-lang.org/examples/websockets).
---

We are going to make a simple chat app. There will be a text field so you can type things in and a region that shows all the messages we have received so far. Web sockets are great for this scenario because they let us set up a persistent connection with the server. This means:

  1. You can send messages cheaply whenever you want.
  2. The server can send *you* messages whenever it feels like it.

In other words, `WebSocket` is one of the rare libraries that makes use of both commands and subscriptions.

This program happens to be pretty short, so here is the full thing:


```elm
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import WebSocket


main =
  Html.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }


-- MODEL

type alias Model =
  { input : String
  , messages : List String
  }


init : (Model, Cmd Msg)
init =
  (Model "" [], Cmd.none)


-- UPDATE

type Msg
  = Input String
  | Send
  | NewMessage String


update : Msg -> Model -> (Model, Cmd Msg)
update msg {input, messages} =
  case msg of
    Input newInput ->
      (Model newInput messages, Cmd.none)

    Send ->
      (Model "" messages, WebSocket.send "ws://echo.websocket.org" input)

    NewMessage str ->
      (Model input (str :: messages), Cmd.none)


-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
  WebSocket.listen "ws://echo.websocket.org" NewMessage


-- VIEW

view : Model -> Html Msg
view model =
  div []
    [ div [] (List.map viewMessage model.messages)
    , input [onInput Input] []
    , button [onClick Send] [text "Send"]
    ]


viewMessage : String -> Html msg
viewMessage msg =
  div [] [ text msg ]
```

The interesting parts are probably the uses of `WebSocket.send` and `WebSocket.listen`.

For simplicity we will target a simple server that just echos back whatever you type. So you will not be able to have the most exciting conversations in the basic version, but that is why we have exercises on these examples!

