# Install

  * Mac &mdash; [installer][mac]
  * Windows &mdash; [installer][win]
  * Anywhere &mdash; [direct download][gh] or [npm][]

[mac]: https://github.com/elm/compiler/releases/download/0.19.0/installer-for-mac.pkg
[win]: https://github.com/elm/compiler/releases/download/0.19.0/installer-for-windows.exe
[npm]: https://www.npmjs.com/package/elm
[gh]: https://github.com/elm/compiler/releases/tag/0.19.0

After installing through any of those routes, you will have the `elm` binary available in your terminal!

> **Troubleshooting:**
>
> 1. If you are having trouble, just skip this for now! You can try out a bunch of sections of this book with the [the online editor](https://elm-lang.org/try), and you can always come back to this later!
> 2. The fastest way to learn *anything* is to talk with other people in the Elm community. We are friendly and happy to help! Try visiting [the Elm Slack](https://elmlang.herokuapp.com/) and asking about your problem. In fact, if you run into something confusing at any point, come ask about it as well!


## Terminal Tools

So we have this `elm` binary now, but what can it do exactly?


### `elm repl`

`elm repl` lets us interact with Elm expressions in the terminal.

```elm
$ elm repl
---- Elm 0.19.0 ----------------------------------------------------------------
Read <https://elm-lang.org/0.19.0/repl> to learn more: exit, help, imports, etc.
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

We will be using `elm repl` in the upcoming &ldquo;Core Language&rdquo; section, and you can read more about how it works [here](https://elm-lang.org/0.19.0/repl).

> **Note:** `elm repl` works by compiling code to JavaScript, so make sure you have [Node.js](http://nodejs.org/) installed. We use that to evaluate code.


### `elm reactor`

`elm reactor` helps you build Elm projects without messing with the terminal too much. You just run it at the root of your project, like this:

```bash
git clone https://github.com/evancz/elm-architecture-tutorial.git
cd elm-architecture-tutorial
elm reactor
```

This starts a server at [`http://localhost:8000`](http://localhost:8000). You can navigate to any Elm file and see what it looks like. Try to check out `examples/01-button.elm`.


### `elm make`

`elm make` builds Elm projects. It can compile Elm code to HTML or JavaScript. It is the most general way to compile Elm code, so if your project becomes too advanced for `elm reactor`, you will want to start using `elm make` directly.

Say you want to compile `Main.elm` to an HTML file named `main.html`. You would run this command:

```bash
elm make Main.elm --output=main.html
```

### `elm install`

Elm packages all live at [`package.elm-lang.org`](https://package.elm-lang.org/).

Say you look around and decide you need [`elm/http`][http] and [`elm/json`][json] to make some HTTP requests. You can get them set up in your project with the following commands:

```bash
elm install elm/http
elm install elm/json
```

This will add the dependencies into your `elm.json` file, described in more detail [here](https://github.com/elm/compiler/blob/master/docs/elm.json/application.md).

[http]: https://package.elm-lang.org/packages/elm/http/latest
[json]: https://package.elm-lang.org/packages/elm/json/latest


## Summary

The `elm` binary can do a bunch of stuff. Do not worry about remembering it all. You can always just run `elm --help` or `elm repl --help` to get a bunch of information about any of these commands.

Next we are going to learn the basics of Elm!


> #### Configure Your Editor?
>
> It can be tricky to set up some of these editors, so feel free to skip over this for now! You can go far with just [the online editor](https://elm-lang.org/try).
>
> Here are some of the community maintained plugins for Elm:
>
>  * [Atom](https://atom.io/packages/language-elm)
>  * [Brackets](https://github.com/lepinay/elm-brackets)
>  * [Emacs](https://github.com/jcollard/elm-mode)
>  * [IntelliJ](https://github.com/klazuka/intellij-elm)
>  * [Light Table](https://github.com/rundis/elm-light)
>  * [Sublime Text](https://packagecontrol.io/packages/Elm%20Language%20Support)
>  * [Vim](https://github.com/ElmCast/elm-vim)
>  * [VS Code](https://github.com/sbrink/vscode-elm)
>
> If you do not have an editor at all, [Sublime Text](https://www.sublimetext.com/) is a great one to get started with!
>
> You may also want to try out [`elm-format`][elm-format] which makes your code pretty!

[elm-format]: https://github.com/avh4/elm-format
