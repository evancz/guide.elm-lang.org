# Elm에 대하여

**Elm은 JavaScript로 컴파일 되는 함수형 언어입니다.** React와 같은 웹 사이트나 웹 어플리케이션을 만드는 데 사용하는 툴과 경쟁하고 있죠. Elm은 쉬운 간결함과 쉬운 사용성, 코드 품질등에 초점을 맞추고 있어요. 

이 가이드에서 알려드릴 것들:

* Teach you the fundamentals of programming in Elm.
* Show you how to make interactive apps with _The Elm Architecture_.
* Emphasize the principles and patterns that generalize to programming in any language.

By the end I hope you will not only be able to create great web apps in Elm, but also understand the core ideas and patterns that make Elm nice to use.

If you are on the fence, I can safely guarantee that if you give Elm a shot and actually make a project in it, you will end up writing better JavaScript and React code. The ideas transfer pretty easily!

## A Quick Sample

Of course _I_ think Elm is good, so look for yourself.

Here is [a simple counter](http://elm-lang.org/examples/buttons). If you look at the code, it just lets you increment and decrement the counter:

```elm
import Html exposing (Html, button, div, text)
import Html.Events exposing (onClick)

main =
  Html.beginnerProgram { model = 0, view = view, update = update }

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

Notice that the `update` and `view` are entirely decoupled. You describe your HTML in a declarative way and Elm takes care of messing with the DOM.

## Why a _functional_ language?

Forget what you have heard about functional programming. Fancy words, weird ideas, bad tooling. Barf. Elm is about:

* No runtime errors in practice. No `null`. No `undefined` is not a function.
* Friendly error messages that help you add features more quickly.
* Well-architected code that _stays_ well-architected as your app grows.
* Automatically enforced semantic versioning for all Elm packages.

No combination of JS libraries can ever give you this, yet it is all free and easy in Elm. Now these nice things are _only_ possible because Elm builds upon 40+ years of work on typed functional languages. So Elm is a functional language because the practical benefits are worth the couple hours you'll spend reading this guide.

I have put a huge emphasis on making Elm easy to learn and use, so all I ask is that you give Elm a shot and see what you think. I hope you will be pleasantly surprised!

