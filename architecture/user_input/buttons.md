# Buttons

**<hr/><div style="text-align: center;"><a href="http://evancz.github.io/elm-architecture-tutorial/examples/1">Demo</a> / <a href="">Code</a></div><hr/>**

Our first example is a simple counter that can be incremented or decremented. I find that it can be helpful to see the entire program in one place, so here it is! We will break it down afterwards.

```elm
import Html exposing (Html, button, div, text)
import Html.App as Html
import Html.Events exposing (onClick)


main =
  Html.simpleProgram { model = model, view = view, update = update }


-- MODEL

type alias Model = Int

model = 0


-- UPDATE

type Msg = Increment | Decrement

update : Msg -> Model -> Model
update msg model =
  case msg of
    Increment ->
      model + 1

    Decrement ->
      model - 1


-- VIEW

view : Model -> Html Msg
view model =
  div []
    [ button [ onClick Decrement ] [ text "-" ]
    , div [] [ text (toString model) ]
    , button [ onClick Increment ] [ text "+" ]
    ]
```

That's everything!

When writing this program from scratch, you start by figuring out what the model should be. We need to keep track of a number that is going up and down, so it is just an integer:

```elm
type alias Model = Int
```

Now that we know what our model is, we need to define how it changes over time. I always start my `UPDATE` section by defining a set of messages that we will get from the UI:

```elm
type Msg = Increment | Decrement
```

I definitely know the user will be able to increment and decrement the counter. The `Msg` type describes these capabilities as *data*. From there, the `update` function just describes what to do when you receive one of these messages. If you get an `Increment` you increment the model.

```elm
update : Msg -> Model -> Model
update msg model =
  case msg of
    Increment ->
      model + 1

    Decrement ->
      model - 1
```

Notice that our `Action` [union type][] does not *do* anything. It simply describes the actions that are possible. If someone decides our counter should be doubled when a certain button is pressed, that will be a new case in `Action`. This means our code ends up very clear about how our model can be transformed. Anyone reading this code will immediately know what is allowed and what is not. Furthermore, they will know exactly how to add new features in a consistent way.

[union type]: http://elm-lang.org/learn/Union-Types.elm

Finally, we create a way to `view` our `Model`. We are using [elm-html][] to create some HTML to show in a browser. We will create a div that contains: a decrement button, a div showing the current count, and an increment button.

[elm-html]: http://elm-lang.org/blog/Blazing-Fast-Html.elm

```elm
view : Signal.Address Action -> Model -> Html
view address model =
  div []
    [ button [ onClick address Decrement ] [ text "-" ]
    , div [ countStyle ] [ text (toString model) ]
    , button [ onClick address Increment ] [ text "+" ]
    ]

countStyle : Attribute
countStyle =
  ...
```

The tricky thing about our `view` function is the `Address`. We will dive into that in the next section! For now, I just want you to notice that **this code is entirely declarative**. We take in a `Model` and produce some `Html`. That is it. At no point do we mutate the DOM manually, which gives the library [much more freedom to make clever optimizations][elm-html] and actually makes rendering *faster* overall. It is crazy. Furthermore, `view` is a plain old function so we can get the full power of Elm&rsquo;s module system, test frameworks, and libraries when creating views.

This pattern is the essence of architecting Elm programs. Every example we see from now on will be a slight variation on this basic pattern: `Model`, `update`, `view`.
