> This section uses `elm-repl`. If you did not [install it](install.md) already, you can use the [online REPL](http://elmrepl.cuberoot.in/).

# JSON

You will be sending lots of JSON in your programs. You use [the `Json.Decode` library](http://package.elm-lang.org/packages/elm-lang/core/latest/Json-Decode) to convert wild and crazy JSON into nicely structured Elm values.

The core concept for working with JSON is called a **decoder**. It decodes JSON values into Elm values. We will start out by looking at some very basic decoders and then look at how to put them together to handle more complex scenarios.


## Primitive Decoders

Here are the type signatures for a couple primitive decoders:

```elm
string : Decoder String
int : Decoder Int
float : Decoder Float
bool : Decoder Bool
```

These become useful when paired with the `decodeString` function:

```elm
decodeString : Decoder a -> String -> Result String a
```

This means we can do stuff like this:

```elm
> import Json.Decode exposing (..)

> decodeString int "42"
Ok 42 : Result String Int

> decodeString float "3.14159"
Ok 3.14159 : Result String Float

> decodeString bool "true"
Ok True : Result String Bool

> decodeString int "true"
Err "Expecting an Int but instead got: true" : Result String Int
```

So our little decoders let us turn strings of JSON values into a `Result` telling us how the conversion went.

Now that we can handle the simplest JSON values, how can we deal with more complex things like arrays and objects?


## Combining Decoders

The cool thing about decoders is that they snap together like building blocks. So if we want to handle a list of values, we would reach for the [`list`](http://package.elm-lang.org/packages/elm-lang/core/latest/Json-Decode#list) function:

```elm
list : Decoder a -> Decoder (List a)
```

We can combine this with all the primitive decoders now:

```elm
> import Json.Decode exposing (..)

> int
<decoder> : Decoder Int

> list int
<decoder> : Decoder (List Int)

> decodeString (list int) "[1,2,3]"
Ok [1,2,3] : Result String (List Int)

> decodeString (list string) """["hi", "yo"]"""
Ok ["hi", "yo"] : Result String (List String)
```

So now we can handle JSON arrays. If we want to get extra crazy, we can even nest lists.

```elm
> decodeString (list (list int)) "[ [0], [1,2,3], [4,5] ]"
Ok [[0],[1,2,3],[4,5]] : Result String (List (List Int))
```

So that is `list`, but `Json.Decode` can handle many other data structures too. For example, [`dict`](http://package.elm-lang.org/packages/elm-lang/core/latest/Json-Decode#dict) helps you turn a JSON object into an Elm `Dict` and [`keyValuePairs`](http://package.elm-lang.org/packages/elm-lang/core/latest/Json-Decode#keyValuePairs) helps you turn a JSON object into an Elm list of keys and values.


## Decoding Objects

We decode JSON objects with the [`field`](http://package.elm-lang.org/packages/elm-lang/core/latest/Json-Decode#field) function. It snaps together decoders just like `list`:

```elm
field : String -> Decoder a -> Decoder a
```

So when you say `field "x" int` you are saying (1) I want a JSON object, (2) it should have a field `x`, and (3) the value at `x` should be an integer. So using it looks like this:

```elm
> import Json.Decode exposing (..)

> field "x" int
<decoder> : Decoder Int

> decodeString (field "x" int) """{ "x": 3, "y": 4 }"""
Ok 3 : Result String Int

> decodeString (field "y" int) """{ "x": 3, "y": 4 }"""
Ok 4 : Result String Int
```

Notice that the `field "x" int` decoder only cares about field `x`. The object can have other fields with other content. That is all separate. But what happens when you want to get information from *many* fields? Well, we just need to put together many decoders. This is possible with functions like [`map2`](http://package.elm-lang.org/packages/elm-lang/core/latest/Json-Decode#map2):

```elm
map2 : (a -> b -> value) -> Decoder a -> Decoder b -> Decoder value
```

This function takes in two different decoders. If they are both successful, it uses the given function to combine their results. So now we can put together two different decoders:

```elm
> import Json.Decode exposing (..)

> type alias Point = { x : Int, y : Int }

> Point
<function> : Int -> Int -> Point

> pointDecoder = map2 Point (field "x" int) (field "y" int)
<decoder> : Decoder Point

> decodeString pointDecoder """{ "x": 3, "y": 4 }"""
Ok { x = 3, y = 4 } : Result String Point
```

Okay, that covers two fields, but what about three? Or four? The core library provides [`map3`](http://package.elm-lang.org/packages/elm-lang/core/latest/Json-Decode#map3), [`map4`](http://package.elm-lang.org/packages/elm-lang/core/latest/Json-Decode#map4), and others for handling larger objects.

As you start working with larger JSON objects, it is worth checking out [`NoRedInk/elm-decode-pipeline`](http://package.elm-lang.org/packages/NoRedInk/elm-decode-pipeline/latest). It builds on top of the core `Json.Decode` module described here and lets you write stuff like this:

```elm
import Json.Decode exposing (Decoder, int)
import Json.Decode.Pipeline exposing (decode, required)

type alias Point = { x : Int, y : Int }

pointDecoder : Decoder Point
pointDecoder =
  decode Point
    |> required "x" int
    |> required "y" int
```

You can have `optional` and `hardcoded` fields as well. It is quite a nice library, so take a look!


> ## Broader Context
>
> By now you have seen a pretty big chunk of the actual `Json.Decode` API, so I want to give some additional context about how this fits into the broader world of Elm and web apps.
>
> ### Validating Server Data
>
> The conversion from JSON to Elm doubles as a validation phase. You are not just converting from JSON, you are also making sure that JSON conforms to a particular structure.
>
> In fact, decoders have revealed weird data coming from NoRedInk’s *backend* code! If your server is producing unexpected values for JavaScript, the client just gradually crashes as you run into missing fields. In contrast, Elm recognizes JSON values with unexpected structure, so NoRedInk gives a nice explanation to the user and logs the unexpected value. This has actually led to some patches in their Ruby server!
>
> ### A General Pattern
>
> JSON decoders are an example of a more general pattern in Elm. You see it whenever you want to wrap up complicated logic into small building blocks that snap together easily. Other examples include:
>
>   - `Random` &mdash; The `Random` library has the concept of a `Generator`. So a `Generator Int` creates random integers. You start with primitive building blocks that generate random `Int` or `Bool`. From there, you use functions like `list` and `map` to build up generators for fancier types.
>
>   - `Easing` &mdash; The Easing library has the concept of an `Interpolation`. An `Interpolation Float` describes how to slide between two floating point numbers. You start with interpolations for primitives like `Float` or `Color`. The cool thing is that these interpolations compose, so you can build them up for much fancier types.
>
> As of this writing, there is some early work on Protocol Buffers (binary data format) that uses the same pattern. In the end you get a nice composable API for converting between Elm values and binary!
