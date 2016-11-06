
# Modules

In the last few sections, we learned how to create reusable views. Whenever you start seeing a pattern in your `view` code, you can break it out into a helper function. But so far, we have just been growing our files longer and longer. At some point this gets out of control though, we do not want to have 2000 line files!

So Elm has *modules* to help you grow your codebase in a nice way. On the most basic level, modules let you break your code into multiple files. Like everything else in Elm, you should only reach for a fancier tool when you feel you *need* it. So if you have a 400 line file and notice that a bunch of code is all related to showing radio buttons in a certain way, it may be a good idea to move all the relevant functions and types into their own module.

Before we get into the nuances of using modules *appropriately*, let&rsquo;s learn how to use them at all!


## Defining Modules

Every module starts with a *module declaration*. So if I wanted to define my own version of the `Maybe` module, I might start with something like this:

```elm
module Optional exposing (..)

type Optional a = Some a | None

isNone : Optional a -> Bool
isNone optional =
  case optional of
    Some _ ->
      False

    None ->
      True
```

The new thing here is that first line. You can read it as &ldquo;This module is named `Optional` and it exposes *everything* to people who use the module.&rdquo;

Exposing everything is fine for prototyping and exploration, but a serious project will want to make the exposed values explicit, like this:

```elm
module Optional exposing ( Optional(..), isNone )
```

Read this as &ldquo;This module is named `Optional` and it exposes the `Optional` type, the `Some` and `None` constructors, and the `isNone` function to people who use the module.&rdquo; Now there is no reason to list *everything* that is defined, so later we will see how this can be used to hide implementation details.

> **Note:** If you forget to add a module declaration, Elm will use this one instead:
>
>```elm
module Main exposing (..)
```
>
> This makes things easier for beginners working in just one file. They should not be confronted with the module system on their first day!


## Using Modules

Okay, we have our `Optional` module, but how do we use it? We can create `import` declarations at the top of files that describe which modules are needed. So if we wanted to make the &ldquo;No shoes, no shirt, no service&rdquo; policy explicit in code, we could write this:

```elm
import Optional

noService : Optional.Optional a -> Optional.Optional a -> Bool
noService shoes shirt =
  Optional.isNone shoes && Optional.isNone shirt
```

The `import Optional` line means you can use anything exposed by the module as long as you put `Optional.` before it. So in the `noService` function, you see `Optional.Optional` and `Optional.isNone`. These are called *qualified* names. Which `isNone` is it? The one from the `Optional` module! It says it right there in the code.

Generally, it is best to always use qualified names. In a project with twenty imports, it is extremely helpful to be able to quickly see where a value comes from.

That said, there are a few ways to customize an import that can come in handy.


### As

You can use the `as` keyword to provide a shorter name. To stick with the `Optional` module, we could abbreviate it to just `Opt` like this:

```elm
import Optional as Opt

noService : Opt.Optional a -> Opt.Optional a -> Bool
noService shoes shirt =
  Opt.isNone shoes && Opt.isNone shirt
```

Now we can refer to `Opt.Optional` and `Opt.isNone`. It is kind of nice in this case, but this feature is best used on very long module names. Cases like this:

```elm
import Facebook.News.Story as Story
```

It would be annoying to type out the whole module name every time we need a function from it, so we shorten it to a name that is clear and helpful.


### Exposing

You can also use the `exposing` keyword to bring in the contents of the module *without* a qualifier. You will sometimes see things like this:

```elm
import Optional exposing (Optional)

noService : Optional a -> Optional a -> Bool
noService shoes shirt =
  Optional.isNone shoes && Optional.isNone shirt
```

This way you can refer to the `Optional` type directly, but still need to say `Optional.isNone` and `Optional.None` for everything else exposed by the module.

This `exposing` keyword works just like it does in module declarations. If you want to expose everything you use `exposing (..)`. If you want to expose everything explicitly, you would say `exposing ( Optional(..), isNone )`.


## Mixing Both

It is possible to use `as` and `exposing` together. You could write:

```elm
import Optional as Opt exposing (Optional)

noService : Optional a -> Optional a -> Bool
noService shoes shirt =
  Opt.isNone shoes && Opt.isNone shirt
```

No matter how you choose to `import` a module, you will only be able to refer to types and values that the module has made publicly available. You may get to see only one function from a module that has twenty. That is up to the author of the module!


## Building Projects with Multiple Modules

We know what the Elm code looks like now, but how do we get `elm-make` to recognize our modules?

Every Elm project has an `elm-package.json` file at its root. It will look something like this:

```json
{
    "version": "1.0.0",
    "summary": "helpful summary of your project, less than 80 characters",
    "repository": "https://github.com/user/project.git",
    "license": "BSD3",
    "source-directories": [
        "src",
        "benchmarks/src"
    ],
    "exposed-modules": [],
    "dependencies": {
        "elm-lang/core": "4.0.2 <= v < 5.0.0",
        "elm-lang/html": "1.1.0 <= v < 2.0.0"
    },
    "elm-version": "0.17.0 <= v < 0.18.0"
}
```

There are two important parts for us:

  - `"source-directories"` &mdash; This is a list of all the directories that `elm-make` will search through to find modules. Saying `import Optional` means `elm-make` will search for `src/Optional.elm` and `benchmarks/src/Optional.elm`. Notice that the name of the module needs to match the name of the file exactly.

  - `"dependencies"` &mdash; This lists all the [community packages](http://package.elm-lang.org/) you depend on. Saying `import Optional` means `elm-make` will also search the [`elm-lang/core`](http://package.elm-lang.org/packages/elm-lang/core/latest/) and [`elm-lang/html`](http://package.elm-lang.org/packages/elm-lang/html/latest/) packages for modules named `Optional`.

Typically, you will say `"source-directories": [ "src" ]` and have your project set up like this:

```
my-project/elm-package.json
my-project/src/Main.elm
my-project/src/Optional.elm
```

And when you want to compile your `Main.elm` file, you say:

```bash
cd my-project
elm-make src/Main.elm
```

With this setup, `elm-make` will know exactly where to find the `Optional` module.

> **Note:** If you want fancier directory structure for your Elm code, you can use module names like `Facebook.Feed.Story`. That module would need to live in a file at `Facebook/Feed/Story.elm` so that the file name matches the module name.
