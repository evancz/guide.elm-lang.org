# Ports

Ports allow communication between Elm and JavaScript.

Ports are probably most commonly used for [`WebSockets`](https://github.com/elm-community/js-integration-examples/tree/master/websockets) and [`localStorage`](https://github.com/elm-community/js-integration-examples/tree/master/localStorage). Let's focus on the `WebSockets` example.


## Ports in JavaScript

Here we have pretty much the same HTML we have been using on the previous pages, but with a bit of extra JavaScript code in there. We create a connection to `wss://echo.websocket.org` that just repeats back whatever you send it. You can see in the [live example](https://ellie-app.com/8yYgw7y7sM2a1) that this lets us make the skeleton of a chat room:

```html
<!DOCTYPE HTML>
<html>

<head>
  <meta charset="UTF-8">
  <title>Elm + Websockets</title>
  <script type="text/javascript" src="elm.js"></script>
</head>

<body>
	<div id="myapp"></div>
</body>

<script type="text/javascript">

// Start the Elm application.
var app = Elm.Main.init({
	node: document.getElementById('myapp')
});

// Create your WebSocket.
var socket = new WebSocket('wss://echo.websocket.org');

// When a command goes to the `sendMessage` port, we pass the message
// along to the WebSocket.
app.ports.sendMessage.subscribe(function(message) {
    socket.send(message);
});

// When a message comes into our WebSocket, we pass the message along
// to the `messageReceiver` port.
socket.addEventListener("message", function(event) {
	app.ports.messageReceiver.send(event.data);
});

// If you want to use a JavaScript library to manage your WebSocket
// connection, replace the code in JS with the alternate implementation.
</script>

</html>
```

We call `Elm.Main.init()` like in all of our interop examples, but this time we are actually using the resulting `app` object. We are subscribing to the `sendMessage` port and we are sending to the `messageReceiver` port.

Those correspond to code written on the Elm side.


## Ports in Elm

Check out the lines that use the `port` keyword in the corresponding Elm file. This is how we define the ports that we just saw on the JavaScript side.

```elm
port module Main exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Decode as D



-- MAIN


main : Program () Model Msg
main =
  Browser.element
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }




-- PORTS


port sendMessage : String -> Cmd msg
port messageReceiver : (String -> msg) -> Sub msg



-- MODEL


type alias Model =
  { draft : String
  , messages : List String
  }


init : () -> ( Model, Cmd Msg )
init flags =
  ( { draft = "", messages = [] }
  , Cmd.none
  )



-- UPDATE


type Msg
  = DraftChanged String
  | Send
  | Recv String


-- Use the `sendMessage` port when someone presses ENTER or clicks
-- the "Send" button. Check out index.html to see the corresponding
-- JS where this is piped into a WebSocket.
--
update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    DraftChanged draft ->
      ( { model | draft = draft }
      , Cmd.none
      )

    Send ->
      ( { model | draft = "" }
      , sendMessage model.draft
      )

    Recv message ->
      ( { model | messages = model.messages ++ [message] }
      , Cmd.none
      )



-- SUBSCRIPTIONS


-- Subscribe to the `messageReceiver` port to hear about messages coming in
-- from JS. Check out the index.html file to see how this is hooked up to a
-- WebSocket.
--
subscriptions : Model -> Sub Msg
subscriptions _ =
  messageReceiver Recv



-- VIEW


view : Model -> Html Msg
view model =
  div []
    [ h1 [] [ text "Echo Chat" ]
    , ul []
        (List.map (\msg -> li [] [ text msg ]) model.messages)
    , input
        [ type_ "text"
        , placeholder "Draft"
        , onInput DraftChanged
        , on "keydown" (ifIsEnter Send)
        , value model.draft
        ]
        []
    , button [ onClick Send ] [ text "Send" ]
    ]



-- DETECT ENTER


ifIsEnter : msg -> D.Decoder msg
ifIsEnter msg =
  D.field "key" D.string
    |> D.andThen (\key -> if key == "Enter" then D.succeed msg else D.fail "some other key")
```

Notice that the first line says `port module` rather than just `module`. This makes it possible to define ports in a given module. The compiler gives a hint about this if it is needed, so hopefully no one gets too stuck on that!

Okay, but what is going on with the `port` declarations for `sendMessage` and `messageReceiver`?


## Outgoing Messages (`Cmd`)

The `sendMessage` declaration lets us send messages out of Elm.

```elm
port sendMessage : String -> Cmd msg
```

Here we are declaring that we want to send out `String` values, but we could send out any of the types that work with flags. We talked about those types on the previous page, and you can check out [this `localStorage` example](https://ellie-app.com/8yYddD6HRYJa1) to see a [`Json.Encode.Value`](https://package.elm-lang.org/packages/elm/json/latest/Json-Encode#Value) getting sent out to JavaScript.

From there we can use `sendMessage` like any other function. If your `update` function produces a `sendMessage "hello"` command, you will hear about it on the JavaScript side:

```javascript
app.ports.sendMessage.subscribe(function(message) {
    socket.send(message);
});
```

This JavaScript code is subscribed to all of the outgoing messages. You can `subscribe` multiple functions and `unsubscribe` functions by reference, but we generally recommend keeping things static.

We also recommend sending out richer messages, rather than making lots of individual ports. Maybe that means having a custom type in Elm that represents everything you might need to tell JS, and then using [`Json.Encode`](https://package.elm-lang.org/packages/elm/json/latest/Json-Encode) to send it out to a single JS subscription. Many people find that this creates a cleaner separation of concerns. The Elm code clearly owns some state, and the JS clearly owns other state.


## Incoming Messages (`Sub`)

The `messageReceiver` declaration lets us listen for messages coming in to Elm.

```elm
port messageReceiver : (String -> msg) -> Sub msg
```

We are saying we are going to receive `String` values, but again, we can listen for any type that can come in through flags or outgoing ports. Just swap out the `String` type with one of the types that can cross the border.

Again we can use `messageReceiver` like any other function. In our case we call `messageReceiver Recv` when defining our `subscriptions` because we want to hear about any incoming messages from JavaScript. This will let us get messages like `Recv "how are you?"` in our `update` function.

On the JavaScript side, we are able to send things to this port whenever we want:

```javascript
socket.addEventListener("message", function(event) {
	app.ports.messageReceiver.send(event.data);
});
```

We happen to be sending whenever the websocket gets a message, but you could send at other times as well. Maybe we are getting messages from another data source as well. That is fine, and Elm does not need to know anything about it! Just send the strings through the relevant port.


## Notes

**Ports are about creating strong boundaries!** Definitely do not try to make a port for every JS function you need. You may really like Elm and want to do everything in Elm no matter the cost, but ports are not designed for that. Instead, focus on questions like “who owns the state?” and use one or two ports to send messages back and forth. If you are in a complex scenario, you can even simulate `Msg` values by sending JS like `{ tag: "active-users-changed", list: ... }` where you have a tag for all the variants of information you might send across.

Here are some simple guidelines and common pitfalls:

- **Sending `Json.Encode.Value` through ports is recommended.** Like with flags, certain core types can pass through ports as well. This is from the time before JSON decoders, and you can read about it more [here](/interop/flags.html#verifying-flags).

- **All `port` declarations must appear in a `port module`.** It is probably best to organize all your ports into one `port module` so it is easier to see the interface all in one place.

- **Ports are for applications.** A `port module` is available in applications, but not in packages. This ensures that application authors have the flexibility they need, but the package ecosystem is entirely written in Elm. We think this will create a stronger ecosystem and community in the long run, and we get into the tradeoffs in depth in the upcoming section on the [limits](/interop/limits.html) of Elm/JS interop.

- **Ports can be dead code eliminated.** Elm has quite aggressive [dead code elimination](https://en.wikipedia.org/wiki/Dead_code_elimination), and it will remove ports that are not used within Elm code. The compiler does not know what goes on in JavaScript, so try to hook things up in Elm before JavaScript.

I hope this information will help you find ways to embed Elm in your existing JavaScript! It is not as glamorous as doing a full-rewrite in Elm, but history has shown that it is a much more effective strategy.
