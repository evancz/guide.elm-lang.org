
# Module Basics


## Modules

Every module starts with a *module declaration*. Check it out in this simple `User` module:

```elm
module User exposing (User, isNamed)

type User = Anonymous | Named String

isNamed : User -> Bool
isNamed user =
  case user of
    Anonymous ->
      False

    Named _ ->
      True

isAnonymous : User -> Bool
isAnonymous user =
  not (isNamed user)
```

The new thing here is that first line. You can read it as &ldquo;This module is named `User` and people on the outside will only be able to see the `User` type and the `isNamed` function.&rdquo;

When you look at the body of the module, you see that we have decided not to expose some things. Specifically, the `isAnonymous` function and the `Anonymous` and `Named` type constructors are all hidden from the outside world. This is the basic mechanism of hiding details.

Now, say we wanted to expose everything for some reason, we could say:

```elm
module User exposing ( User(..), isNamed, isAnonymous )
```

The most important thing here is the `User(..)` part. This is saying, expose the `User` type as well as all its type constructors. This way outsiders can use `Anonymous` and `Named` in pattern matches or whatever else. This is maybe the most important thing to know about modules. **If you want to hide details, export a union type *without* any type constructors.** That way, no one will be able to create or destructure that type on their own. The will have to go through functions like `isNamed` and `isAnonymous` if they want to find out anything about a `User`.

Hiding type constructors is the basic trick behind creating clear contracts. For example, the `Dict` library is currently implemented as a balanced binary tree. Adding and removing elements requires us to very carefully shift branches around. It is hard to do in the library itself, and there would be no chance it would stay balanced if folks could reach in and modify the tree themselves! By hiding the type constructors for `Dict`, we made it impossible for people to reach in and break the invariants, yet they are able to make full use of the data structure through functions like `get` and `size`.

We will use this trick in the next section!


> **Note 1:** If you wanted to get super lazy about exposing everything, you could say it this way too:
>
>```elm
module User exposing (..)
```
>
> This is convenient when you are hacking or exploring on your own, but it is not a great idea in a serious codebase. The whole point of modules is to hide details and create contracts, and `exposing (..)` does neither of those things! Serious projects will list the exposed values explicitly.

> **Note 2:** If you forget to add a module declaration, Elm will use this one instead:
>
>```elm
module Main exposing (..)
```
>
> This makes things easier for beginners working in just one file. They should not be confronted with the module system on their first day!


## Imports

Okay, we have a module, but how do we use it? Say we are now working on a `ChatRoom` module that will be managing a bunch of `User` data. We will need to `import` the `User` module like this:

```elm
import User
```

By default, all imported values are *qualified*. This means you need to say `User.User` and `User.isNamed`. The module name is a *qualifier* indicating where that value comes from. Generally speaking, it is best to always use qualified names. In a project with twenty imports, it is extremely helpful to be able to quickly see where a value comes from.

That said, there are a few ways to customize an import that can come in handy.


### Shortened Names

You can use the `as` keyword to provide a shorter name. To stick with the `User` module, we could abbreviate it to just `U` like this:

```elm
import User as U
```

Now we can refer to `U.User` and `U.isNamed`. This feature is best used on very long module names, so in practice you would probably use it in cases like this:

```elm
import Facebook.News.Story as Story
```

It would be annoying to type out the whole module name every time we need a function from it, so we shorten it to a name that is clear and helpful.


### Unqualified Names

You can also use the `exposing` keyword to bring in the contents of the module *without* a qualifier. Often you will see things like this:

```elm
import User exposing (User)
```

This way you can refer to the `User` type directly, but still say `User.isNamed` for everything else.

This `exposing` keyword works just like it does in module declaraitons. If you want to expose everything you use `exposing (..)` and if you want to expose type constructors you use `exposing ( User(..) )` to bring them in.


## Mixing Both

It is possible to use `as` and `exposing` together. You could write:

```elm
import User as U exposing (User)
```

This will let you refer to `User` and `U.isNamed`.

No matter how you choose to `import` a module, you will only be able to refer to types and values that the module has made publicly available. You may get to see only one function from a module that has twenty. That is up to the author of the module!