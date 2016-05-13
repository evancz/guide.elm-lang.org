# Nesting

**Work in progress** - Full example coming in the next weeks!

It works just like it did in previous versions though. You define a module like normal, but with a restricted public API:

```elm
module Counter exposing ( Model, Msg, update, view, init, subscriptions )
```

It is only exposing the definitions necessary for The Elm Architecture.

From there you create the "parent" module and import the "child".

```elm
module CounterPair exposing (..)

import Counter

type alias Model =
  { top : Counter.Model
  , bottom : Counter.Model
  }
  
...
```

Whenever you have to deal with a `Counter.Model` you use the relevant publicly exposed functions.

You can check out some full examples of this in the `nesting/` directory of [this repo](https://github.com/evancz/elm-architecture-tutorial).