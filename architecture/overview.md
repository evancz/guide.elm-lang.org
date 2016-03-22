# The Elm Architecture

**The Elm Architecture** is a simple pattern for infinitely nestable components. It is great for modularity, code reuse, and testing. Ultimately, this pattern makes it easy to create complex web apps that stay healthy and modular as you refactor and add features.

> One very interesting aspect of this architecture is that it emerges naturally in Elm. We first observed it in the games the Elm community was making. Then in web apps like [TodoMVC][] and [dreamwriter][] to. Now we see it running in production at companies like [NoRedInk][] and [CircuitHub][]. It seems that this architecture is a consequence of the design of Elm itself, but the pattern is useful in any front-end code. In fact, projects like Redux translate The Elm Architecture directly into JavaScript libraries, so you may have already seen derivatives of this pattern.

[Elm]: http://elm-lang.org/
[TodoMVC]: https://github.com/evancz/elm-todomvc
[dreamwriter]: https://github.com/rtfeldman/dreamwriter#dreamwriter
[NoRedInk]: https://www.noredink.com/
[CircuitHub]: https://www.circuithub.com/


## The Basic Pattern

The logic of every Elm program will break up into three cleanly separated parts:

  * model
  * update
  * view

It is so reliable that I always start with the following skeleton and fill in details for my particular case.

```elm
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
view =
  ...
```

This tutorial is all about this pattern and small variations and extensions.