> **Note:** If you do not want to install yet, you can follow along anyway. Most sections can be done in an online editor!


# Install

  * Mac &mdash; [installer][mac]
  * Windows &mdash; [installer][win]
  * Linux &mdash; [instructions][linux]

[mac]: https://44a95588fe4cc47efd96-ec3c2a753a12d2be9f23ba16873acc23.ssl.cf2.rackcdn.com/Elm-0.19.pkg
[win]: https://44a95588fe4cc47efd96-ec3c2a753a12d2be9f23ba16873acc23.ssl.cf2.rackcdn.com/Elm-0.19.exe
[linux]: https://gist.github.com/evancz/442b56717b528f913d1717f2342a295d
[npm]: https://www.npmjs.com/package/elm

After installing through any of those routes, you will have the `elm` binary available in your terminal!

> **Troubleshooting:** The fastest way to learn *anything* is to talk with other people in the Elm community. We are friendly and happy to help! So if you get stuck during installation or encounter something weird, visit [the Elm Slack](http://elmlang.herokuapp.com/) and ask about it. In fact, if you run into something confusing at any point while learning or using Elm, come ask us about it. You can save yourself hours. Just do it!


## Configure Your Editor

Using Elm is way nicer when you have a code editor to help you out. There are Elm plugins for at least the following editors:

  * [Atom](https://atom.io/packages/language-elm)
  * [Brackets](https://github.com/lepinay/elm-brackets)
  * [Emacs](https://github.com/jcollard/elm-mode)
  * [IntelliJ](https://github.com/durkiewicz/elm-plugin)
  * [Light Table](https://github.com/rundis/elm-light)
  * [Sublime Text](https://packagecontrol.io/packages/Elm%20Language%20Support)
  * [Vim](https://github.com/ElmCast/elm-vim)
  * [VS Code](https://github.com/sbrink/vscode-elm)

If you do not have an editor at all, [Sublime Text](https://www.sublimetext.com/) is a great one to get started with!

You may also want to try out [elm-format][] which makes your code pretty!

[elm-format]: https://github.com/avh4/elm-format


## Terminal Tools

So we have this `elm` binary now, but what can it do exactly?


### `elm repl`

`elm repl` lets interact with Elm expressions in the terminal.

```elm
$ elm repl
---- Elm 0.19.0 ----------------------------------------------------------------
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

We will be using `elm repl` in the upcoming &ldquo;Core Language&rdquo; section, and you can read more about how it works [here](https://github.com/elm-lang/elm-compiler/blob/master/docs/repl.md).

> **Note:** `elm repl` works by compiling code to JavaScript, so make sure you have [Node.js](http://nodejs.org/) installed. We use that to evaluate code.


### `elm reactor`

`elm reactor` helps you build Elm projects without messing with the terminal too much. You just run it at the root of your project, like this:

```bash
git clone https://github.com/evancz/elm-architecture-tutorial.git
cd elm-architecture-tutorial
elm reactor
```

This starts a server at [`http://localhost:8000`](http://localhost:8000). You can navigate to any Elm file and see what it looks like. Try to check out `examples/01-button.elm`.


## `elm make`

`elm make` builds Elm projects. It can compile Elm code to HTML or JavaScript. It is the most general way to compile Elm code, so if your project becomes too advanced for `elm reactor`, you will want to start using `elm make` directly.

Say you want to compile `Main.elm` to an HTML file named `main.html`. You would run this command:

```bash
elm make Main.elm --output=main.html
```

### `elm install`

The Elm community shares packages at: [`https://package.elm-lang.org/`](https://package.elm-lang.org/)

Elm projects all have an `elm.json` file (like [this](https://github.com/elm-lang/elm-compiler/blob/master/docs/elm.json/application.md)) which lists any packages it depends upon. Do you need [`elm-lang/http`][http]? Do you need [`elm-lang/time`][time]?

`elm install` just helps you add dependencies to `elm.json`.

Say you want to use [`elm-lang/http`][http] and [`NoRedInk/json-decode-pipeline`][pipe] to make HTTP requests to a server and turn the resulting JSON into Elm values. You would say:

[http]: https://package.elm-lang.org/packages/elm/http/latest
[json]: https://package.elm-lang.org/packages/elm/json/latest
[pipe]: https://package.elm-lang.org/packages/NoRedInk/json-decode-pipeline/latest

```bash
elm install elm-lang/http
elm install NoRedInk/elm-decode-pipeline
```

This will add the dependencies to `elm.json` (or create it if needed!)


## Summary

The `elm` binary can do a bunch of stuff. Do not worry about remembering it all. You can always just run `elm --help` or `elm repl --help` to get a bunch of information about any of these commands.

Next we are going to learn the basics of Elm!