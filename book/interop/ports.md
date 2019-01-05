# Ports

The previous two pages, we saw the JavaScript needed to start Elm programs and a way to pass in flags on initialization:

```elm
// initialize
var app = Elm.Main.init({
  node: document.getElementById('elm')
});

// initialize with flags
var app = Elm.Main.init({
  node: document.getElementById('elm'),
  flags: Date.now()
});
```

We can give information to the Elm program, but only when it starts. What if you want to talk to JavaScript while the program is running?


## Message Passing

Elm allows you to pass messages between Elm and JavaScript through **ports**. Unlike the request/response pairs you see with HTTP, the messages sent through ports just go in one direction. It is like sending a letter. For example, banks in the United States send me hundreds of unsolicited letters, cajoling me to indebt myself to them so I will finally be happy. Those messages are all one-way. All letters are like that really. I may send a letter to my friend and she may reply, but there is nothing inherent about messages that demands request/response pairs. Point is, **Elm and JavaScript can communicate by sending these one-way messages through ports.**


## Outgoing Messages

Say we want to use [`localStorage`](https://developer.mozilla.org/en-US/docs/Web/API/Storage) to cache some information. The solution is to set up a port that sends information out to JavaScript.

On the Elm side, this means defining the `port` like this:

```elm
port module Main exposing (..)

import Json.Encode as E

port cache : E.Value -> Cmd msg
```

The most important line is the `port` declaration. That creates a `cache` function, so we can create commands like `cache (E.int 42)` that will send a [`Json.Encode.Value`](https://package.elm-lang.org/packages/elm/json/latest/Json-Encode#Value) out to JavaScript.

On the JavaScript side, we initialize the program like normal, but we then subscribe to all the outgoing `cache` messages:

```javascript
var app = Elm.Main.init({
  node: document.getElementById('elm')
});
app.ports.cache.subscribe(function(data) {
  localStorage.setItem('cache', JSON.stringify(data));
});
```

Commands like `cache (E.int 42)` send values to anyone subscribing to the `cache` port in JavaScript. So the JS code would get `42` as `data` and cache it in `localStorage`.

In most programs that want to cache information like this, you communicate with JavaScript in two ways:

1. You pass in cached data through flags on initialization
2. You send data out periodically to update the cache

So there are only _outgoing_ messages for this interaction with JS. And I would not get too intense trying to minimize the data crossing the border. Keep it simple, and be more tricky only if you find it necessary in practice!


> **Note 1:** This is not a binding to the `setItem` function! This is a common misinterpretation. **The point is not to cover the LocalStorage API one function at a time.** It is to ask for some caching. The JS code can decide to use LocalStorage, IndexedDB, WebSQL, or whatever else. So instead of thinking “should each JS function be a port?” think about “what needs to be accomplished in JS?” We have been thinking about caching, but it is the same in a fancy restaurant. You decide what you want, but you do not micromanage exactly how it is prepared. Your high-level message (your food order) goes back to the kitchen and you get a bunch of very specific messages back (drinks, appetizers, main course, desert, etc.) as a result. My point is that **well-designed ports create a clean separation of concerns.** Elm can do the view however it wants and JavaScript can do the caching however it wants.
>
> **Note 2:** There is not a LocalStorage package for Elm right now, so the current recommendation is to use ports like we just saw. Some people wonder about the timeline to get support directly in Elm. Some people wonder quite aggressively! I tried to write about that [here](https://github.com/elm/projects/blob/master/roadmap.md#where-is-the-localstorage-package).
>
> **Note 3:** Once you `subscribe` to outgoing port messages, you can `unsubscribe` as well. It works like `addEventListener` and `removeEventListener`, also requiring reference-equality of functions to work.


## Incoming Messages

Say we are creating a chat room in JavaScript, and we are curious to try out Elm a bit. Pretty much every company that uses Elm today, started by converting just one element to try it out. Does it work nice? Does the team like it? If so, great, try more elements! If not, no big deal, revert and use the technologies that work best for you!

So when we look at our chat room app, we decide to convert an element that shows all active users. That means Elm needs to know about any changes to the active users list. Well, that sort of thing happens through ports!

On the Elm side, this means defining the `port` like this:

```elm
port module Main exposing (..)

import Json.Encode as E

type Msg
  = Searched String
  | Changed E.Value

port activeUsers : (E.Value -> msg) -> Sub msg
```

Again, the important line is the `port` declaration. It creates a `activeUsers` function, and if we subscribe to `activeUsers Changed`, we will get a `Msg` whenever folks send values in from JavaScript.

On the JavaScript side, we initialize the program like normal, but now we are able to send messages to any `activeUsers` subscriptions:

```javascript
var activeUsers = // however this is defined

var app = Elm.Main.init({
  node: document.getElementById('elm'),
  flags: activeUsers
});

// after someone enters or exits
app.ports.activeUsers.send(activeUsers);
```

I start the Elm program with any known active users, and every time the active user list changes, I send the entire list through the `activeUsers` port.

Now you may be wondering, why send the _entire_ list though? Why not just say who enters or exits? This approach sounds nice, but it creates the risk of synchronization errors. JavaScript thinks there are 20 active users, but somehow Elm thinks there are 25. Is there a bug in Elm code? Or in JavaScript? Forgot to send an exit message through ports? These bugs are extremely tricky to sort out, and you can end up wasting hours or days trying to figure them out.

Instead, I chose a design that makes synchronization errors impossible. JavaScript owns the state. All the Elm code does is get the complete list and display it. If the Elm code needs to change the list for some reason, it cannot! JavaScript owns the state. Instead, I would send a message out to JavaScript asking for specific changes. Point is, **state should be owned by Elm or by JavaScript, never both.** This dramatically reduces the risk of synchronization errors. Many folks who struggle with ports fall into this trap of never really deciding who owns the state. Be wary!


## Notes

I want to add a couple notes about the examples we saw here:

- **All `port` declarations must appear in a `port module`.** It is probably best to organize all your ports into one `port module` so it is easier to see the interface all in one place.

- **Sending `Json.Decode.Value` through ports is recommended, but not the only way.** Like with flags, certain core types can pass through ports as well. This is from the time before JSON decoders, and you can read about it more [here](/interop/flags.html#verifying-flags).

- **Ports are for applications.** A `port module` is available in applications, but not in packages. This ensures that application authors have the flexibility they need, but the package ecosystem is entirely written in Elm. I argued [here](https://groups.google.com/d/msg/elm-dev/1JW6wknkDIo/H9ZnS71BCAAJ) that this will help us build a much stronger ecosystem and community in the long run.

- **Ports are about creating strong boundaries!** Definitely do not try to make a port for every JS function you need. You may really like Elm and want to do everything in Elm no matter the cost, but ports are not designed for that. Instead, focus on questions like “who owns the state?” and use one or two ports to send messages back and forth. If you are in a complex scenario, you can even simulate `Msg` values by sending JS like `{ tag: "active-users-changed", list: ... }` where you have a tag for all the variants of information you might send across.

I hope this information will help you find ways to embed Elm in your existing JavaScript! It is not as glamorous as doing a full-rewrite in Elm, but history has shown that it is a much more effective strategy.


> ## Aside: Design Considerations
>
> Ports are somewhat of an outlier in the history of languages. There are two common interop strategies, and Elm did neither of them:
>
> 1. **Full backwards compatibility.** For example, C++ is a superset of C, and TypeScript is a superset of JavaScript. This is the most permissive approach, and it has proven extremely effective. By definition, everyone is using your language already.
> 2. **Foreign function interface (FFI)** This allows direct bindings to functions in the host language. For example, Scala can call Java functions directly. Same with Clojure/Java, Python/C, Haskell/C, and many others. Again, this has proven quite effective.
>
> These paths are attractive, but they are not ideal for Elm for two main reasons:
>
> 1. **Losing Guarantees.** One of the best things about Elm is that there are entire categories of problems you just do not have to worry about, but if we can use JS directly in any package, all that goes away. Does this package produce runtime exceptions? When? Will it mutate the values I give to it? Do I need to detect that? Does the package have side-effects? Will it send messages to some 3rd party servers? A decent chunk of Elm users are drawn to the language specifically because they do not have to think like that anymore.
> 2. **Package Flooding.** There is quite high demand to directly copy JavaScript APIs into Elm. In the two years before `elm/html` existed, I am sure someone would have contributed jQuery bindings if it was possible. This has already happened in the typed functional languages that use more traditional interop designs. As far as I know, package flooding is unique to compile-to-JS languages. The pressure is not nearly as high in Python for example, so I think that downside is a product of the unique culture and history of the JavaScript ecosystem.
>
> Given these pitfalls, ports are attractive because they let you get things done in JavaScript while preserving the best parts of Elm. Great! On the flipside, it means Elm cannot piggyback on the JS ecosystem to gain more libraries more quickly. If you take a longer-view, I think this is actually a key strength. As a result:
>
> 1. **Packages are designed for Elm.** As members of the Elm community get more experience and confidence, we are starting to see fresh approaches to layout and data visualization that work seamlessly with The Elm Architecture and the overall ecosystem. I expect this to keep happening with other sorts of problems!
> 2. **Packages are portable.** If the compiler someday produces x86 or WebAssembly, the whole ecosystem just keeps working, but faster! Ports guarantee that all packages are written entirely in Elm, and Elm itself was designed such that other non-JS compiler targets are viable.
>
> So this is definitely a longer and harder path, but languages live for 30+ years. They have to support teams and companies for decades, and when I think about what Elm will look like in 20 or 30 years, I think the tradeoffs that come with ports look really promising! My talk [What is Success?](https://youtu.be/uGlzRt-FYto) starts a little slow, but it gets into this a bit more!
