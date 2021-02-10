# Flags

Flags are a way to pass values into Elm on initialization.

Common uses are passing in API keys, environment variables, and user data. This can be handy if you generate the HTML dynamically. They can also help us load cached information in [this `localStorage` example](https://github.com/elm-community/js-integration-examples/tree/master/localStorage).


## Flags in HTML

The HTML is basically the same as before, but with an additional `flags` argument to the `Elm.Main.init()` function

```html
<html>
<head>
  <meta charset="UTF-8">
  <title>Main</title>
  <script src="main.js"></script>
</head>

<body>
  <div id="myapp"></div>
  <script>
  var app = Elm.Main.init({
    node: document.getElementById('myapp'),
    flags: Date.now()
  });
  </script>
</body>
</html>
```

In this example we are passing in the current time in milliseconds, but any JS value that can be JSON decoded can be given as a flag.

> **Note:** This additional data is called “flags” because it is kind of like command line flags. You can call `elm make src/Main.elm`, but you can add some flags like `--optimize` and `--output=main.js` to customize its behavior. Same sort of thing.


## Flags in Elm

To handle flags on the Elm side, you need to modify your `init` function a bit:

```elm
module Main exposing (..)

import Browser
import Html exposing (Html, text)


-- MAIN

main : Program Int Model Msg
main =
  Browser.element
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }


-- MODEL

type alias Model = { currentTime : Int }

init : Int -> ( Model, Cmd Msg )
init currentTime =
  ( { currentTime = currentTime }
  , Cmd.none
  )


-- UPDATE

type Msg = NoOp

update : Msg -> Model -> ( Model, Cmd Msg )
update _ model =
  ( model, Cmd.none )


-- VIEW

view : Model -> Html Msg
view model =
  text (String.fromInt model.currentTime)


-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions _ =
  Sub.none
```

The only important here is the `init` function says it takes an `Int` argument. This is how Elm code gets immediate access to the flags you pass in from JavaScript. From there, you can put things in your model or run some commands. Whatever you need to do.

I recommend checking out [this `localStorage` example](https://github.com/elm-community/js-integration-examples/tree/master/localStorage) for a more interesting use of flags!


## Verifying Flags

But what happens if `init` says it takes an `Int` flag, but someone tries to initialize with `Elm.Main.init({ flags: "haha, what now?" })`?

Elm checks for that sort of thing, making sure the flags are exactly what you expect. Without this check, you could pass in anything, leading to runtime errors in Elm!

There are a bunch of types that can be given as flags:

- `Bool`
- `Int`
- `Float`
- `String`
- `Maybe`
- `List`
- `Array`
- tuples
- records
- [`Json.Decode.Value`](https://package.elm-lang.org/packages/elm/json/latest/Json-Decode#Value)

Many folks always use a `Json.Decode.Value` because it gives them really precise control. They can write a decoder to handle any weird scenarios in Elm code, recovering from unexpected data in a nice way.

The other supported types actually come from before we had figured out a way to do JSON decoders. If you choose to use them, there are some subtleties to be aware of. The following examples show the desired flag type, and then the sub-points show what would happen with a couple different JS values:

- `init : Int -> ...`
  - `0` => `0`
  - `7` => `7`
  - `3.14` => error
  - `6.12` => error

- `init : Maybe Int -> ...`
  - `null` => `Nothing`
  - `42` => `Just 42`
  - `"hi"` => error

- `init : { x : Float, y : Float } -> ...`
  - `{ x: 3, y: 4, z: 50 }` => `{ x = 3, y = 4 }`
  - `{ x: 3, name: "Tom" }` => error
  - `{ x: 360, y: "why?" }` => error

- `init : (String, Int) -> ...`
  - `["Tom", 42]` => `("Tom", 42)`
  - `["Sue", 33]` => `("Sue", 33)`
  - `["Bob", "4"]` => error
  - `["Joe", 9, 9]` => error

Note that when one of the conversions goes wrong, **you get an error on the JS side!** We are taking the “fail fast” policy. Rather than the error making its way through Elm code, it is reported as soon as possible. This is another reason why people like to use `Json.Decode.Value` for flags. Instead of getting an error in JS, the weird value goes through a decoder, guaranteeing that you implement some sort of fallback behavior.
