# JSON

You will sending lots of JSON in your programs. You use [the `Json.Decode` library](http://package.elm-lang.org/packages/elm-lang/core/latest/Json-Decode) to convert wild and crazy JSON into nicely structured Elm values.

The core concept for working with JSON is called a **decoder**. It is a value that knows how to turn certain JSON values into Elm values. We will start out by looking at some very basic decoders (how do I get a string?) and then look at how to put them together to handle more complex scenarios.


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

The cool thing about decoders is that they snap together building blocks. So if we want to handle a list of values, we would reach for the following function:

```elm
list : Decoder a -> Decoder (List a)
```

We can combine this with all the primitive decoders now:

```elm
> import Json.Decode exposing (..)

> int
<decoder> : Decode Int

> list int
<decoder> : Decode (List Int)

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


## Decoding Objects

Decoding JSON objects is slightly fancier than using the `list` function, but it is the same idea. The important functions for decoding objects is an infix operator:

```elm
(:=) : String -> Decode a -> Decode a
```

This says "look into a given field, and try to decode it in a certain way". So using it looks like this:

```elm
> import Json.Decode exposing (..)

> "x" := int
<decoder> : Decode Int

> decodeString ("x" := int) """{ "x": 3, "y": 4 }"""
Ok 3 : Result String Int

> decodeString ("y" := int) """{ "x": 3, "y": 4 }"""
Ok 4 : Result String Int
```

That is great, but it only works on one field. We want to be able to handle objects larger than that, so we need help from functions like this:

```elm
object2 : (a -> b -> value) -> Decoder a -> Decoder b -> Decoder value
```

This function takes in two different decoders. If they are both successful, it uses the given function to combine their results. So now we can put together two different decoders:

```elm
> import Json.Decode exposing (..)

> (,)
<function> : a -> b -> (a, b)

> point = object2 (,) ("x" := int) ("y" := int)
<decoder> : Decode (Int, Int)

> decodeString point """{ "x": 3, "y": 4 }"""
Ok (3,4) : Result String (Int, Int)
```

There are a bunch of functions like `object2` (like `object3` and `object4`) for handling different sized objects. Later we will see tricks so you do not need a different function depending on the size of the object you are dealing with. It is just easier to ramp up this way.


## Handling Uncertainty


## Additional Information

By now you have seen a pretty big chunk of the actual `Json.Decode` API, so I want to give some additional context about how this fits into the broader world of Elm and web apps.

### Validating Server Data

The conversion from JSON to Elm doubles as a validation phase. You are not just converting from JSON, you are also making sure that JSON conforms to a particular structure.

In fact, decoders have revealed weird data coming from NoRedInk's *backend* code! If your server is producing unexpected values for JavaScript, the client just gradually crashes as you run into missing fields. In contrast, Elm recognizes JSON values with unexpected structure, so NoRedInk gives a nice explanation to the user and logs the unexpected value. This has actually led to some patches in Ruby code!

### A General Pattern

JSON decoders are actually an instance of a more general pattern in Elm. You see it whenever you want to wrap up complicated logic into small building blocks that snap together easily. Other examples include:
 
  - `Random` &mdash; The `Random` library has the concept of a `Generator`. So a `Generator Int` creates random integers. You start with primitive building blocks that generate random `Int` or `Bool`. From there, you use functions like `map` and `andMap` to build up generators for fancier types.

  - `Easing` &mdash; The Easing library has the concept of an `Interpolation`. An `Interpolation Float` describes how to slide between two floating point numbers. You start with interpolations for primitives like `Float` or `Color`. The cool thing is that these interpolations compose, so you can build them up for much fancier types.
 
As of this writing, there is some early work on Protocol Buffers (binary data format) that uses the same pattern. In the end you get a nice composable API for converting between Elm values and binary!
