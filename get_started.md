# Get Started


## Try Online

Not everyone wants to get installed all at once, so you can follow along in this guide with the [**online editor**](http://elm-lang.org/try). You will not have the REPL for the &ldquo;Core Language&rdquo; section, but everything else will work just fine!

You can see the online editor in action with [these examples](http://elm-lang.org/examples) of small Elm programs.


## Install

You can also just install the &ldquo;Elm Platform&rdquo; which includes all the command line tools you will need to work with Elm.

  * Mac &mdash; [installer][mac]
  * Windows &mdash; [installer][win]
  * Anywhere &mdash; [npm installer][npm] or [build from source][build]

We will go through each tool that comes with Elm Platform lower on this page!

[mac]: http://install.elm-lang.org/Elm-Platform-0.17.1.pkg
[win]: http://install.elm-lang.org/Elm-Platform-0.17.1.exe
[npm]: https://www.npmjs.com/package/elm
[build]: https://github.com/elm-lang/elm-platform
[slack]: http://elmlang.herokuapp.com/


## Configure Your Editor

We know of Elm syntax highlighting modes for at least the following text editors:

  * [Atom](https://atom.io/packages/language-elm)
  * [Brackets](https://github.com/lepinay/elm-brackets)
  * [Emacs](https://github.com/jcollard/elm-mode)
  * [IntelliJ](https://github.com/durkiewicz/elm-plugin)
  * [Light Table](https://github.com/rundis/elm-light)
  * [Sublime Text](https://packagecontrol.io/packages/Elm%20Language%20Support)
  * [Vim](https://github.com/lambdatoast/elm.vim)
  * [VS Code](https://github.com/sbrink/vscode-elm)

If you do not have an editor at all, [Sublime Text](https://www.sublimetext.com/) is a great one to get started with!


## Troubleshooting

The fastest way to learn *anything* is to talk with other people in the Elm community. We are friendly and happy to help! So if you get stuck during installation or encounter something weird, visit [the Elm Slack](http://elmlang.herokuapp.com/) and ask about it. In fact, if you run into something confusing at any point while learning or using Elm, come ask us about it. You can save yourself hours. Just do it!


## What is the Elm Platform?

After installing Elm successfully, you will have the following command line tools available on your computer:

- [`elm-repl`](#elm-repl)
- [`elm-reactor`](#elm-reactor)
- [`elm-make`](#elm-make)
- [`elm-package`](#elm-package)

Each one has a `--help` flag that will show more information. Let's go over them here though!


### elm-repl

[`elm-repl`](https://github.com/elm-lang/elm-repl) lets you play with simple Elm expressions.

```bash
$ elm-repl
---- elm-repl 0.17.1 -----------------------------------------------------------
 :help for help, :exit to exit, more at <https://github.com/elm-lang/elm-repl>
--------------------------------------------------------------------------------
> 1 / 2
0.5 : Float
> List.length [1,2,3,4]
4 : Int
> List.reverse ["Alice","Bob"]
["Bob","Alice"] : List String
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

Say you want to use [`evancz/elm-http`][http] and [`NoRedInk/elm-decode-pipeline`][pipe] to make HTTP requests to a server and turn the resulting JSON into Elm values. You would say:

[http]: http://package.elm-lang.org/packages/evancz/elm-http/latest
[pipe]: http://package.elm-lang.org/packages/NoRedInk/elm-decode-pipeline/latest

```bash
elm-package install evancz/elm-http
elm-package install NoRedInk/elm-decode-pipeline
```

This will add the dependencies to your `elm-package.json` file that describes your project. (Or create it if you do not have one yet!) More information about all this [here](https://github.com/elm-lang/elm-package)!


**Notable commands:**

- `install`: install the dependencies in `elm-package.json`
- `publish`: publish your library to the Elm Package Catalog
- `bump`: bump version numbers based on API changes
- `diff`: get the difference between two APIs
