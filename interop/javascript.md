# JavaScript Interop

At some point your Elm program is probably going to need to talk to JavaScript. We do by sending messages back and forth between Elm and JavaScript:

![](interop.png)

This way we can have access to full power of JavaScript, the good and the bad, without giving up on all the things that are nice about Elm.

## Ports

Any communication with JavaScript goes through a *port*. Think of it like a hole in the side of your Elm program where you can plug stuff in.

Imagine we want to send strings to JavaScript to use some nice spell checking library. When that library produces suggestions, we want to send them back into Elm through another port.

```elm
port module Spelling exposing (..)

port check : String -> Cmd msg

port suggestions : (List String -> msg) -> Sub msg
```

```javascript
var app = Elm.Spelling.fullscreen();

app.ports.check.subscribe(function(word) {
    var suggestions = spellCheck(word);
    app.ports.suggestions.send(suggestions);
});
```

## Historical Context

Now I know that this is not the typical interpretation of *language interop*. Usually languages just go for full backwards compatibility. So C code can be used *anywhere* in C++ code. You can replace C/C++ with Java/Scala or JavaScript/TypeScript. This is the easiest solution, but it forces you to make quite extreme sacrifices in the new language. All the problems of the old language now exist in the new one too. Hopefully less though.

Elm's interop is built on the observation that **by enforcing some architectural rules, you can make full use of the old language *without* making sacrifices in the new one.** This means we can keep making guarantees like "you will not see runtime errors in Elm" even as you start introducing whatever crazy JavaScript code you need.

So what are these architectural rules? Turns out it is just The Elm Architecture. Instead of embedding arbitrary JS code right in the middle of Elm, we use commands and subscriptions to send messages to external JavaScript code. So just like how the `WebSocket` library insulates you from all the crazy failures that might happen with web sockets, port modules insulate you from all the crazy failures that might happen in JavaScript. **It is like JavaScript-as-a-Service.**
