# Elm에 대하여

**Elm은 JavaScript로 컴파일 되는 함수형 언어입니다.** React와 같은 웹 사이트나 웹 어플리케이션을 만드는 데 사용하는 툴과 경쟁하고 있죠. Elm은 간결함과 쉬운 사용성, 코드 품질등에 초점을 맞추고 있어요.

이 가이드에서 알려드릴 것들:

* Elm 프로그래밍 기초를 배울 수 있어요.
* Elm 아키텍쳐를 통해 인터랙티브 어플리케이션을 어떻게 만들 수 있는지 보여드릴게요.
* 다른 프로그래밍 언어에도 적용되는 원칙과 패턴을 강조할 거에요.

가이드를 마치고 나서, Elm으로 훌륭한 웹 어플리케이션을 만들기를 바라요. 또한 Elm을 멋있게 사용할 수 있는 핵심적인 관념도 가지셨으면 좋겠어요.

아직도 망설이고 계신다면, 제가 도움이 될 것이라는 걸 보증할게요. Elm으로 실제 프로젝트를 만들어보신다면, 프로젝트가 끝났을 때 더 나은 JavaScript와 React 코드를 작성할 수 있을 것이, 생각의 전환이 쉬워질 거에요!

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

`update`와 `view` 가 완벽하게 분리된 걸 보세요. 여러분은 서술적인 HTML 만들고, Elm이 지저분한 DOM을 처리해주죠.

## 왜 함수형 언어인가요?

그동안 함수형 프로그래밍에 대해 들어왔던 것들은 잊으세요. 멋진 단어들로 형용된, 이상한 생각들이 합쳐진 안좋은 도구... 으익! Elm은 그냥 다음과 같은 거에요.

* 실행중 런타임 예외가 발생하지 않아요. Null이 없고 undefined도 없죠. 이것들은 함수가 아니기 때문이죠.
* 친절한 에러 메시지가 기능을 빨리 추가할 때 도움이 되요.
* 잘 구조화 된 코드가 앱의 규모가 커져도 지속적으로 구조화가 잘됩니다.
* 모든 Elm 패키지에 대해 자동적으로 유의전 버전을 강제해요.

JS 라이브러리를 조합해서 사용할 순 없지만 Elm에선 모든 것이 쉽고 자유롭답니다. 현재 이런 게 가능한 이유는 Elm이 40년 이상의 역사를 갖는 타입 함수형 언어 기반이기 때문이죠. 그렇기 때문에 함수형 언어인 Elm을 배우고, 이 가이드를 읽기 위해 몇 시간을 투자하는 하는 것은 실제로 가치가 있는 일이에요.

전 Elm을 쉽게 배우고 사용하는데에 초점을 맞췄어요. 여러분들께서 엘름을 접해보고 판단하시길 부탁드려요. 개인적으론 여러분들이 너무 좋아서 깜짝 놀라길 바랍니다!

