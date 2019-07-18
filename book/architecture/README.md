# The Elm Architecture

The Elm Architecture is a simple pattern for architecting webapps. It is great for modularity, code reuse, and testing. Ultimately, it makes it easy to create complex web apps that stay healthy as you refactor and add features.

This architecture seems to emerge naturally in Elm. Rather than someone “inventing” it, early Elm programmers kept discovering the same basic patterns in their code. Teams have found this particularly nice for onboarding new developers. Code just turns out well-architected. It is kind of spooky.

So The Elm Architecture is *easy* in Elm, but it is useful in any front-end project. In fact, projects like Redux have been inspired by The Elm Architecture, so you may have already seen derivatives of this pattern. Point is, even if you ultimately cannot use Elm at work yet, you will get a lot out of using Elm and internalizing this pattern.

[Elm]: https://elm-lang.org/
[TodoMVC]: https://github.com/evancz/elm-todomvc
[dreamwriter]: https://github.com/rtfeldman/dreamwriter#dreamwriter
[NoRedInk]: https://www.noredink.com/
[CircuitHub]: https://www.circuithub.com/
[Pivotal]: https://www.pivotaltracker.com/blog/Elm-pivotal-tracker/


## The Basic Pattern

The logic of every Elm program will break up into three cleanly separated parts:

  * **Model** &mdash; the state of your application
  * **Update** &mdash; a way to update your state
  * **View** &mdash; a way to view your state as HTML

This pattern is so reliable that I always start with the following skeleton and fill in details for my particular case.

```elm
import Html exposing (..)


-- MODEL

type alias Model = { ... }


-- UPDATE

type Msg = Reset | ...

update : Msg -> Model -> Model
update msg model =
  case msg of
    Reset -> ...
    ...


-- VIEW

view : Model -> Html Msg
view model =
  ...
```

That is really the essence of The Elm Architecture! We will proceed by filling in this skeleton with increasingly interesting logic.


# The Elm Architecture + User Input

Your web app is going to need to deal with user input. This section will get you familiar with The Elm Architecture in the context of things like:

  - Buttons
  - Text Fields
  - Check Boxes
  - Radio Buttons
  - etc.

We will go through a few examples that build knowledge gradually, so go in order!


## Follow Along

In the last section we used `elm repl` to get comfortable with Elm expressions. In this section, we are switching to creating Elm files of our own. You can do that in [the online editor](https://elm-lang.org/try), or if you have Elm [installed](/install.html), you can follow [these simple instructions](https://github.com/evancz/elm-architecture-tutorial#run-the-examples) to get everything working on your computer!
