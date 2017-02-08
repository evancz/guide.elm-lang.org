> **참고 :**아직 설치하고 싶지 않다면, [온라인 편집기](http://elm-lang.org/try) 및 [온라인 REPL](http://elmrepl.cuberoot.in/)을 사용하세요.

# 설치

 * 맥 &mdash; [인스톨러](http://install.elm-lang.org/Elm-Platform-0.18.pkg)
 * 윈도우 &mdash; [인스톨러][win]
 * 다른 OS &mdash; [npm 인스톨러][npm] 또는 [소스를 빌드하기][build]

[mac]: http://install.elm-lang.org/Elm-Platform-0.18.pkg
[win]: http://install.elm-lang.org/Elm-Platform-0.18.exe
[npm]: https://www.npmjs.com/package/elm
[build]: https://github.com/elm-lang/elm-platform

설치가 끝나면, 다음의 커맨드라인 도구들을 사용해보세요.

* [`elm-repl`](#elm-repl) — Elm 표현식을 사용해보세요
* [`elm-reactor`](#elm-reactor) — 프로젝트를 빠르게 체험해보세요.
* [`elm-make`](#elm-make) — 직접적으로 Elm 코드를 컴파일해보세요.
* [`elm-package`](#elm-package) — Elm 패키지를 다운받을 수 있습니다.

여러분이 사용하고 있는 에디터에서 어떻게 Elm설정을 할 수 있는지 짚고 넘어가 봅시다!

> **문제 해결 :** _어떤 것이든 가장 빨리 배울 수 있는 방법_은 Elm 커뮤니티의 다른 사람들과 이야기 해보는 거에요.

저희가 기쁜 마음으로 도와드리겠습니다! 그러니, 설치에 이상이 생기거나 한다면, [Elm 슬랙](http://elmlang.herokuapp.com/)에 방문하셔서 질문해주세요. 사실, Elm을 배우는 동안 언제든지 혼란이 올 수 있을 겁니다. 그럴 때마다 물어봐 주세요. 여러분의 시간을 아끼실 수 있을 겁니다. 그냥 물어보세요!

## 에디터 설정하기

Elm을 좀 더 잘 사용하기 위해 여러분의 코드 에디터가 도와줄 거에요. 다음은 Elm 플러그인이 있는 코드 에디터입니다.

* [Atom](https://atom.io/packages/language-elm)
* [Brackets](https://github.com/lepinay/elm-brackets)
* [Emacs](https://github.com/jcollard/elm-mode)
* [IntelliJ](https://github.com/durkiewicz/elm-plugin)
* [Light Table](https://github.com/rundis/elm-light)
* [Sublime Text](https://packagecontrol.io/packages/Elm%20Language%20Support)
* [Vim](https://github.com/lambdatoast/elm.vim)
* [VS Code](https://github.com/sbrink/vscode-elm)

위 목록에 사용하고 있는 에디터가 없는 경우, [Sublime Text](https://www.sublimetext.com/)가 시작하기에 좋은 에디터가 될 거에요!

또한 [elm-format](https://github.com/avh4/elm-format)을 통해 여러분의 코드를 예쁘게 만들 수 있어요!

## 커맨드 라인 도구

자 이제 우리는 Elm을 설치하고 `elm-repl`, `elm-reactor`, `elm-make`, and `elm-package`와 같은 도구들을 얻었어요. 이것들은 대체 어디다가 사용할 것들일까요?

### elm-repl

[`elm-repl`](https://github.com/elm-lang/elm-repl)은 간단한 Elm 표현식을 사용해 볼 수 있도록 도와줘요.

```bash
$ elm-repl
---- elm-repl 0.18.0 -----------------------------------------------------------
:help for help, :exit to exit, more at <https://github.com/elm-lang/elm-repl>
--------------------------------------------------------------------------------
> 1 / 2
0.5 : Float
> List.length [1,2,3,4]
4 : Int
> String.reverse "stressed"
"desserts" : String
> :exit
$
```

`elm-repl`은 “Elm 살펴보기” 단원에서 사용할 거에요, 어떻게 동작하는 지 더 자세히 알고 싶다면 [여기](https://github.com/elm-lang/elm-repl/blob/master/README.md)를 참고하세요.

> **참고 :** `elm-repl` JavaScript로 컴파일되어 동작합니다. , 그렇기 때문에 [Node.js](http://nodejs.org/)가 설치되어 있어야죠. 이걸로 코드를 평가\(evaluate\)할 거에요.

### elm-reactor

[`elm-reactor`](https://github.com/elm-lang/elm-reactor)는 많은 수의 복잡한 명령어 없이 Elm 프로젝트를 빌드할 수 있게 도와줘요. 그냥 프로젝트 최상단 폴더에서 아래와 같이 입력하면 됩니다.

```bash
git clone https://github.com/evancz/elm-architecture-tutorial.git
cd elm-architecture-tutorial
elm-reactor
```

이 서버는 [`http://localhost:8000`](http://localhost:8000)에서 동작됩니다. 여러분의 Elm file들이 어떻게 생겼는지와 구조를 살펴볼 수 있어요. `examples/01-button.elm`를 확인해보세요.

**알고 넘어가기!**

-`--port`는 8000번 포트 외에 다른 포트를 선택할 수 있어요.  
  `elm-reactor --port=8123` 와 같이 실행한다면 `http://localhost:8123`에서 동작하죠.  
-`--address`는 `localhost`외에 다른 주소로 동작되도록 할 수 있어요.  
  예를들어, `elm-reactor --address=0.0.0.0`와 같이 쓴다면,  
  다른 모바일 기기로 여러분의 로컬 네트워크를 통해 Elm 프로그램에 접속할 수 있죠.

## elm-make

[`elm-make`](https://github.com/elm-lang/elm-make)는 Elm 프로젝트를 빌드할 때 사용해요. Elm코드를 HTML 또는 Javascript로 컴파일 해주죠. Elm 코드를 컴파일하는 가장 일반적인 방법이죠!

`Main.elm`을 `main.html`으로 변환 시키고 싶다면, 다음 명령을 하시면 되요.

```bash
elm-make Main.elm --output=main.html
```

**알고 넘어가기!**

* `--warn` 옵션은 코드 품질을 향상시키는 경고를 보여줘요.

### elm-package

[`elm-package`](https://github.com/elm-lang/elm-package)는 [패키지 카탈로그](http://package.elm-lang.org/)로 부터 패키지를 다운받거나 올릴 수 있게 해줘요. 커뮤니티 멤버들은 [멋진 방법들로](http://package.elm-lang.org/help/design-guidelines) 문제를 해결하거나, 모두가 사용할 수 있도록 패키지 카탈로그에 공유하죠!

[`elm-lang/http`](http://package.elm-lang.org/packages/elm-lang/http/latest)와 [`NoRedInk/elm-decode-pipeline`](http://package.elm-lang.org/packages/NoRedInk/elm-decode-pipeline/latest)를 사용하여 서버로 HTTP 요청을 보낸 뒤, 결과를 JSON으로 변환하여 Elm 값으로 집어넣고 싶다면, 다음과 같이 입력하세요.

```bash
elm-package install elm-lang/http
elm-package install NoRedInk/elm-decode-pipeline
```

명령어를 사용했다면, 프로젝트 정보를 담고 있는 `elm-package.json` 의존성이 들어가 있을 거에요. \(파일이 없는경우 elm-package.json이 생성 되었을 거에요.\) 더욱 자세한 정보는 [here](https://github.com/elm-lang/elm-package)를 참고하세요!

**알고 넘어가기!**

* `install`: `elm-package.json`에 의존성들을 설치해요.
* `publish`: 여러분의 라이브러리를 Elm Package Catalog에 공개 할 수 있어요.
* `bump`: API 변경점을 기반으로 버전을 뭉쳐줍니다.
* `diff`: 두 API 버전의 차이점을 알려줘요.



