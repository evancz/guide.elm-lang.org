# JavaScript

The popular notion of language interop is roughly "C code should be available for use *anywhere* in C++ code". This is the notion you see when you look at Java and Scala, or JavaScript and TypeScript. This is great for migration, but it forces you to make quite extreme sacrifices in the new language.

Elm's interop story is built on the observation that **by enforcing some architectural rules, you can make full use of the old language without making sacrifices in the new one.** This means we can keep making guarantees like "you will not see runtime errors in Elm" even as you start introducing whatever crazy JavaScript code you need.

It just so happens that these architectural rules align perfectly with The Elm Architecture



Elm uses 

```elm
foreign module Foreign exposing (..)

foreign focus : String -> Cmd msg
```

