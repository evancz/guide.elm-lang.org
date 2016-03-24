# JSON

You will sending lots of JSON in your programs. You use the `Json.Decode` library to convert wild and crazy JSON into nicely structured Elm values.

> **Note:** This conversion doubles as a validation phase. In fact, it has revealed bugs in NoRedInk's *backend* code! If your server is producing unexpected values for JavaScript, the client just gradually crashes as you run into missing fields. In contrast, Elm recognizes JSON values with unexpected structure, so NoRedInk gives a nice explanation to the user and logs the unexpected value. This has actually led to some patches in Ruby code!

The core concept for working with JSON is called a **decoder**. It is a value that knows how to turn certain JSON values into Elm values. We will start out by looking at some very basic decoders (how do I get a string?) and then look at how to put them together to handle more complex scenarios.

## Primitive Decoders


## Decoding Objects


## Handling Uncertainty


> **Fun Fact:** JSON decoders are actually an instance of a more general pattern in Elm. You see it whenever 
> 
>   - `Random` &mdash; The `Random` library has the concept of a `Generator`. So a `Generator Int` creates random integers. You start with primitive building blocks that generate random `Int` or `Bool`. From there, you use functions like `map` and `andMap` to build up generators for fancier types.
>   - `Easing` &mdash; The `Easing library has the concept of an `Interpolation`. An `Interpolation Float` describes how to slide between two floating point numbers. You start with interpolations for primitives like `Float` or `Color`. The cool thing is that these interpolations compose, so you can build them up for much fancier types.
> 
> As of this writing, there is some early work on Protocol Buffers (binary data format) that uses the same pattern. In the end you get a nice composable API for converting between Elm values and binary!
