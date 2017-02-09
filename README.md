# Elm에 대하여

**Elm은 JavaScript로 컴파일 되는 함수형 언어입니다.** React와 같은 웹 사이트나 웹 어플리케이션을 만드는 데 사용하는 툴과 경쟁하고 있죠. Elm은 간결함과 쉬운 사용성, 코드 품질등에 초점을 맞추고 있어요.

이 가이드에서 알려드릴 것들:

* Elm 프로그래밍 기초를 배울 수 있어요.
* Elm 아키텍쳐를 통해 인터랙티브 어플리케이션을 어떻게 만들 수 있는지 보여드릴게요.
* 다른 프로그래밍 언어에도 적용되는 원칙과 패턴을 강조할 거에요.

가이드를 마치고 나서, Elm으로 훌륭한 웹 어플리케이션을 만들기를 바라요. 또한 Elm을 멋있게 사용할 수 있는 핵심적인 관념도 가지셨으면 좋겠어요.

아직도 망설이고 계신다면, 제가 도움이 될 것이라는 걸 보증할게요. Elm으로 실제 프로젝트를 만들어보신다면, 프로젝트가 끝났을 때 더 나은 JavaScript와 React 코드를 작성할 수 있을 거에요. 사고 전환이 쉬워질 거에요!

## 간단한 예제

Elm은 물론 좋아요! 한번 직접 봐보세요.

이건 [간단한 카운트 앱](http://elm-lang.org/examples/buttons)이에요. 코드를 보시면 알겠지만, 그냥 카운트를 증가시키고 감소시킬 수 있는 거죠.

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

`update`와 `view` 가 완벽하게 분리된 걸 보세요. 여러분은 서술적인 HTML 만들고 Elm이 지저분한 DOM을 처리해주죠.

## 왜 함수형 언어를 사용해야하죠?

Forget what you have heard about functional programming. Fancy words, weird ideas, bad tooling. Barf. Elm is about:

* No runtime errors in practice. No `null`. No `undefined` is not a function.
* Friendly error messages that help you add features more quickly.
* Well-architected code that _stays_ well-architected as your app grows.
* Automatically enforced semantic versioning for all Elm packages.

No combination of JS libraries can ever give you this, yet it is all free and easy in Elm. Now these nice things are _only_ possible because Elm builds upon 40+ years of work on typed functional languages. So Elm is a functional language because the practical benefits are worth the couple hours you'll spend reading this guide.

I have put a huge emphasis on making Elm easy to learn and use, so all I ask is that you give Elm a shot and see what you think. I hope you will be pleasantly surprised!

