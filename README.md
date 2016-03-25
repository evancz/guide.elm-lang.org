# An Introduction to Elm

**Elm is a functional language that compiles to JavaScript.** It competes with projects like React as a tool for creating websites and web apps. Elm has a very strong emphasis on simplicity, ease-of-use, and quality tooling.

This guide will:

  - Teach you the fundamentals of programming in Elm.
  - Show you how to make interactive apps with *The Elm Architecture*.
  - Emphasize the principles and patterns that generalize to programming in any language.

By the end I hope you will not only be able to create great web apps in Elm, but also understand the core ideas and patterns that make Elm nice to use.

If you are on the fence, I can safely guarantee that if you give Elm a shot, you will end up writing better JavaScript and React code. The ideas transfer pretty easily!


## Why a *functional* language?

Forget about functional programming. Fancy words, weird ideas, bad tooling. Barf. Elm is about:

  - No runtime errors in practice.
  - Friendly error messages that help you add features more quickly.
  - Well-architected code that *stays* well-architected as your app grows.
  - Automatically enforced semantic versioning for all Elm packages.
  - Reliable time-travel debugging.

No combination of JS libraries can ever give you this, yet it is all free and easy in Elm. Now these nice things are *only* possible because Elm builds upon 40+ years of work on typed functional languages. So Elm is a functional language because the practical benefits are worth the couple hours you'll spend reading this guide.


## A Quick Sample

Of course *I* think Elm is good, so look for yourself.

Here is a simple counter. You can increment and decrement the counter:

```elm
import Html exposing (Html, button, div, text)
import Html.App as Html
import Html.Events exposing (onClick)


main =
  Html.simpleProgram { model = 0, view = view, update = update }


type Msg = Increment | Decrement

update msg model =
  case msg of
    Increment ->
      model + 1

    Decrement ->
      model - 1


view model =
  div []
    [ button [ onClick Decrement ] [ text "-" ]
    , div [] [ text (toString model) ]
    , button [ onClick Increment ] [ text "+" ]
    ]
```
