# JavaScript-as-a-Service

The popular notion of language interop is roughly "C code should be available for use *anywhere* in C++ code". This is the notion you see when you look at Java and Scala, or JavaScript and TypeScript. This is great for migration, but it forces you to make quite extreme sacrifices in the new language.

Elm's interop story is built on the observation that **by enforcing some architectural rules, you can make full use of the old language without making sacrifices in the new one.** This means we can keep making guarantees like "you will not see runtime errors in Elm" even as you start introducing whatever crazy JavaScript code you need.

> **Note:** NoRedInk use the JavaScript interop quite a bit, but in the year they have been using Elm in production, they have not gotten a single runtime error from their Elm code! This is not how things go with Scala or TypeScript partly because of how they interpreted "interop".

So what are these architectural rules? Turns out it is just The Elm Architecture. Instead of embedding JS right in the middle of Elm, we use commands and subscriptions to ask JavaScript to do our dirty work. In the same way that the `WebSocket` library insulates you from all the crazy failures that might happen with web sockets, we use `foreign modules` to insulate users from all the crazy failures that might happen in JavaScript code.

## Foreign Modules

Elm uses 

```elm
foreign module Foreign exposing (..)

foreign focus : String -> Cmd msg
```

