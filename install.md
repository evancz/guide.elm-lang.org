> **Note:** If you do not want to install yet, you can follow along in this guide with the [online editor](http://elm-lang.org/try) and the [online REPL](http://elmrepl.cuberoot.in/).


# Install

  * Mac &mdash; [installer][mac]
  * Windows &mdash; [installer][win]
  * Anywhere &mdash; [npm installer][npm] or [build from source][build]

[mac]: http://install.elm-lang.org/Elm-Platform-0.18.pkg
[win]: http://install.elm-lang.org/Elm-Platform-0.18.exe
[npm]: https://www.npmjs.com/package/elm
[build]: https://github.com/elm-lang/elm-platform

After installing through any of those routes, you will have the following command line tools:

- [`elm-repl`](#elm-repl) &mdash; play with Elm expressions
- [`elm-reactor`](#elm-reactor) &mdash; get a project going quickly
- [`elm-make`](#elm-make) &mdash; compile Elm code directly
- [`elm-package`](#elm-package) &mdash; download packages

We will go over how they all work in more detail right after we get your editor set up!

> **Troubleshooting:** The fastest way to learn *anything* is to talk with other people in the Elm community. We are friendly and happy to help! So if you get stuck during installation or encounter something weird, visit [the Elm Slack](http://elmlang.herokuapp.com/) and ask about it. In fact, if you run into something confusing at any point while learning or using Elm, come ask us about it. You can save yourself hours. Just do it!


## Configure Your Editor

Using Elm is way nicer when you have a code editor to help you out. There are Elm plugins for at least the following editors:

  * [Atom](https://atom.io/packages/language-elm)
  * [Brackets](https://github.com/lepinay/elm-brackets)
  * [Emacs](https://github.com/jcollard/elm-mode)
  * [IntelliJ](https://github.com/durkiewicz/elm-plugin)
  * [Light Table](https://github.com/rundis/elm-light)
  * [Sublime Text](https://packagecontrol.io/packages/Elm%20Language%20Support)
  * [Vim](https://github.com/lambdatoast/elm.vim)
  * [VS Code](https://github.com/sbrink/vscode-elm)

If you do not have an editor at all, [Sublime Text](https://www.sublimetext.com/) is a great one to get started with!

You may also want to try out [elm-format][] which makes your code pretty!

[elm-format]: https://github.com/avh4/elm-format


## The Command Line Tools

So we installed Elm, and it gave us `elm-repl`, `elm-reactor`, `elm-make`, and `elm-package`. But what do they all do exactly?


### elm-repl

[`elm-repl`](https://github.com/elm-lang/elm-repl) lets you play with simple Elm expressions.

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

We will be using `elm-repl` in the upcoming &ldquo;Core Language&rdquo; section, and you can read more about how it works [here](https://github.com/elm-lang/elm-repl/blob/master/README.md).

> **Note:** `elm-repl` works by compiling code to JavaScript, so make sure you have [Node.js](http://nodejs.org/) installed. We use that to evaluate code.


### elm-reactor

[`elm-reactor`](https://github.com/elm-lang/elm-reactor) helps you build Elm projects without messing with the command-line too much. You just run it at the root of your project, like this:

```bash
git clone https://github.com/evancz/elm-architecture-tutorial.git
cd elm-architecture-tutorial
elm-reactor
```

This starts a server at [`http://localhost:8000`](http://localhost:8000). You can navigate to any Elm file and see what it looks like. Try to check out `examples/01-button.elm`.

**Notable flags:**

- `--port` lets you pick something besides port 8000. So you can say
  `elm-reactor --port=8123` to get things to run at `http://localhost:8123`.
- `--address` lets you replace `localhost` with some other address. For
  example, you may want to use `elm-reactor --address=0.0.0.0` if you want to
  try out an Elm program on a mobile device through your local network.


## elm-make

[`elm-make`](https://github.com/elm-lang/elm-make) builds Elm projects. It can compile Elm code to HTML or JavaScript. It is the most general way to compile Elm code, so if your project becomes too advanced for `elm-reactor`, you will want to start using `elm-make` directly.

Say you want to compile `Main.elm` to an HTML file named `main.html`. You would run this command:

```bash
elm-make Main.elm --output=main.html
```

**Notable flags:**

- `--warn` prints warnings to improve code quality


### elm-package

[`elm-package`](https://github.com/elm-lang/elm-package) downloads and publishes packages from our [package catalog](http://package.elm-lang.org/). As community members solve problems [in a nice way](http://package.elm-lang.org/help/design-guidelines), they share their code in the package catalog for anyone to use!

Say you want to use [`elm-lang/http`][http] and [`NoRedInk/elm-decode-pipeline`][pipe] to make HTTP requests to a server and turn the resulting JSON into Elm values. You would say:

[http]: http://package.elm-lang.org/packages/elm-lang/http/latest
[pipe]: http://package.elm-lang.org/packages/NoRedInk/elm-decode-pipeline/latest

```bash
elm-package install elm-lang/http
elm-package install NoRedInk/elm-decode-pipeline
```

This will add the dependencies to your `elm-package.json` file that describes your project. (Or create it if you do not have one yet!) More information about all this [here](https://github.com/elm-lang/elm-package)!


**Notable commands:**

- `install`: install the dependencies in `elm-package.json`
- `publish`: publish your library to the Elm Package Catalog
- `bump`: bump version numbers based on API changes
- `diff`: get the difference between two APIs
