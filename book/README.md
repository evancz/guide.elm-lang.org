# An Introduction to Elm

**Elm is a functional language that compiles to JavaScript.** It helps you make websites and web apps. It has a very strong emphasis on simplicity, ease-of-use, and quality tooling.

This guide will:

  - Teach you the fundamentals of programming in Elm.
  - Show you how to make interactive apps with **The Elm Architecture**.
  - Emphasize principles and patterns that generalize to programming in any language.

By the end I hope you will not only be able to create great web apps in Elm, but also understand the core ideas and patterns that make Elm nice to use.

If you are on the fence, I can safely guarantee that if you give Elm a shot and actually make a project in it, you will end up writing better JavaScript code. The ideas transfer pretty easily!


## A Quick Sample

Here is a little program that lets you increment and decrement a number:

```elm
import Browser
import Html exposing (Html, button, div, text)
import Html.Events exposing (onClick)

main =
  Browser.sandbox { init = 0, update = update, view = view }

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
    , div [] [ text (String.fromInt model) ]
    , button [ onClick Increment ] [ text "+" ]
    ]
```

Try it out in the online editor [here](https://elm-lang.org/examples/buttons).

The code can definitely look unfamiliar at first, so we will get into how this example works soon!


## Why a *functional* language?

I learned to program in languages like Java and Python. It was nice! But once I learned some functional languages in school (particularly Standard ML and OCaml) I noticed that I was able to add features and make changes much faster and more reliably than before. I felt **confident** in my programs in a way that I never had before. I decided to learn Haskell on my own, but that confidence evaporated in the cloud of fancy concepts there. After working through them for a couple years, I found that all the time I spent learning was not really paying off in programs that were easier to read or write.

I made Elm in an effort to extract the minimal features necessary for that feeling of **confident programming**. In practice this means:

  - No runtime errors in practice. No `null`. No `undefined` is not a function.
  - Friendly error messages that help you add features more quickly.
  - Reliable refactoring so architecture can evolve with your project.
  - Automatically enforced semantic versioning for all Elm packages.

No combination of JS libraries can give you this because these characteristics come from the design of the language itself! So Elm is a functional language because the practical benefits are worth the couple hours you'll spend reading this guide.

I have put a huge emphasis on making Elm easy to learn and use, so all I ask is that you give Elm a shot and see what you think. I hope you will be pleasantly surprised!
