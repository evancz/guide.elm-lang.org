# Buttons

Our first example is a counter that can be incremented or decremented.

I included the full program below. Click the blue "Edit" button to mess with it in the online editor. Try changing text on one of the buttons. **Click the blue button now!**

<div class="edit-link"><a href="https://elm-lang.org/examples/buttons">Edit</a></div>

```elm
import Browser
import Html exposing (Html, button, div, text)
import Html.Events exposing (onClick)



-- MAIN


main =
  Browser.sandbox { init = init, update = update, view = view }



-- MODEL

type alias Model = Int

init : Model
init =
  0


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
    , div [] [ text (String.fromInt model) ]
    , button [ onClick Increment ] [ text "+" ]
    ]
```

Now that you have poked around the code a little bit, you may have some questions. What is the `main` value doing? How do the different parts fit together? Let's go through the code and talk about it.

> **Note:** The code here uses [type annotations](/types/reading_types.html), [type aliases](/types/type_aliases.html), and [custom types](/types/custom_types.html). The point of this section is to get a feeling for The Elm Architecture though, so we will not cover them until a bit later. I encourage you to peek ahead if you are getting stuck on these aspects!


## Main

The `main` value is special in Elm. It describes what gets shown on screen. In this case, we are going to initialize our application with the `init` value, the `view` function is going to show everything on screen, and user input is going to be fed into the `update` function. Think of this as the high-level description of our program.


## Model

Data modeling is extremely important in Elm. The point of the **model** is to capture all the details about your application as data.

To make a counter, we need to keep track of a number that is going up and down. That means our model is really small this time:

```elm
type alias Model = Int
```

We just need an `Int` value to track the current count. We can see that in our initial value:

```elm
init : Model
init =
  0
```

The initial value is zero, and it will go up and down as people press different buttons.


## View

We have a model, but how do we show it on screen? That is the role of the `view` function:

```elm
view : Model -> Html Msg
view model =
  div []
    [ button [ onClick Decrement ] [ text "-" ]
    , div [] [ text (String.fromInt model) ]
    , button [ onClick Increment ] [ text "+" ]
    ]
```

This function takes in the `Model` as an argument. It outputs HTML. So we are saying that we want to show a decrement button, the current count, and an increment button.

Notice that we have an `onClick` handler for each button. These are saying: **when someone clicks, generate a message**. So the plus button is generating an `Increment` message. What is that and where does it go? To the `update` function!


## Update

The `update` function describes how our `Model` will change over time.

We define two messages that it might receive:

```elm
type Msg = Increment | Decrement
```

From there, the `update` function just describes what to do when you receive one of these messages.

```elm
update : Msg -> Model -> Model
update msg model =
  case msg of
    Increment ->
      model + 1

    Decrement ->
      model - 1
```

If you get an `Increment` message, you increment the model. If you get a `Decrement` message, you decrement the model.

So whenever we get a message, we run it through `update` to get a new model. We then call `view` to figure out how to show the new model on screen. Then repeat! User input generates a message, `update` the model, `view` it on screen. Etc.


## Overview

Now that you have seen all the parts of an Elm program, it may be a bit easier to see how they fit into the diagram we saw earlier:

![Diagram of The Elm Architecture](buttons.svg)

Elm starts by rendering the initial value on screen. From there you enter into this loop:

1. Wait for user input.
2. Send a message to `update`
3. Produce a new `Model`
4. Call `view` to get new HTML
5. Show the new HTML on screen
6. Repeat!

This is the essence of The Elm Architecture. Every example we see from now on will be a slight variation on this basic pattern.


> **Exercise:** Add a button to reset the counter to zero:
>
> 1. Add a `Reset` variant to the `Msg` type
> 2. Add a `Reset` branch in the `update` function
> 3. Add a button in the `view` function.
>
> You can edit the example in the online editor [here](https://elm-lang.org/examples/buttons).
>
> If that goes well, try adding another button to increment by steps of 10.
