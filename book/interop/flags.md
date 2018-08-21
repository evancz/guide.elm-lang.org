# Flags

The previous page showed the JavaScript needed to start an Elm program:

```elm
var app = Elm.Main.init({
  node: document.getElementById('elm')
});
```

It is possible to pass in some additional data though. For example, if we wanted to pass in the current time we could say:

```javascript
var app = Elm.Main.init({
  node: document.getElementById('elm'),
  flags: Date.now()
});
```

We call this additional data `flags`. This allows you to customize the Elm program with all sorts of data!

> **Note:** This additional data is called “flags” because it is kind of like command line flags. You can call `elm make src/Main.elm`, but you can add some flags like `--optimize` and `--output=main.js` to customize its behavior. Same sort of thing.


## Handling Flags

Just passing in JavaScript values is not enough. We need to handle them on the Elm side! The [`Browser.element`][element] function provides a way to handle flags with `init`:

```elm
element :
  { init : flags -> ( model, Cmd msg )
  , update : msg -> model -> ( model, Cmd msg )
  , subscriptions : model -> Subs msg
  , view : model -> Html msg
  }
  -> Program flags model msg
```

[element]: https://package.elm-lang.org/packages/elm/browser/latest/Browser#element

Notice that `init` has an argument called `flags`. So assuming we want to pass in the current time, we could write an `init` function like this:

```elm
init : Int -> ( Model, Cmd Msg )
init currentTime =
  ...
```

This means that Elm code gets immediate access to the flags you pass in from JavaScript. From there, you can put things in your model or run some commands. Whatever you need to do.


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
  - `{ x: 3, name: "tom" }` => error
  - `{ x: 360, y: "why?" }` => error

- `init : (String, Int) -> ...`
  - `['tom',42]` => `("Tom", 42)`
  - `["sue",33]` => `("Sue", 33)`
  - `["bob","4"]` => error
  - `['joe',9,9]` => error

Note that when one of the conversions goes wrong, **you get an error on the JS side!** We are taking the “fail fast” policy. Rather than the error making its way through Elm code, it is reported as soon as possible. This is another reason why people like to use `Json.Decode.Value` for flags. Instead of getting an error in JS, the weird value goes through a decoder, guaranteeing that you implement some sort of fallback behavior.
