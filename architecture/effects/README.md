# The Elm Architecture + Effects

The last section showed how to handle all sorts of user input, but what can we *do* with it?

This section builds on the basic pattern we have seen so far, giving you the ability to make HTTP requests or subscribe to messages from web sockets. All of these effects are built on two important concepts:

  - **Commands** &mdash; A command is a way of demanding some effect. Maybe this is asking for a random number or making an HTTP request. Anything where you are asking for some value and the answer may be different depending on what is going on in the world.

  - **Subscriptions** &mdash; A subscription lets you register that you are interested in something. Maybe you want to hear about geolocation changes? Maybe you want to hear all the messages coming in on a web socket? Subscriptions let you sit passively and only get updates when they exist.

Together, commands and subscriptions make it possible for your Elm components to talk the outside world. But how do these new concepts fit into what we already know?


## Extending the Architecture Skeleton

So far [our architecture skeleton](/architecture/README.md) has focused on creating `Model` types and `update` and `view` functions. To handle commands and subscriptions, we need to extend the basic architecture skeleton a little bit:

```elm
-- MODEL

type alias Model =
  { ...
  }


-- UPDATE

type Msg = Submit | ...

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  ...
  
  
-- VIEW

view : Model -> Html Msg
view model =
  ...


-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
  ...
  

-- INIT

init : (Model, Cmd Msg)
init =
  ...
```

The first three sections are almost exactly the same, but there are a few new things overall:

  1. The `update` function now returns more than just a new model. It returns a new model and some commands you want to run. These commands are all going to produce `Msg` values that will get fed right back into our `update` function.

  2. There is a `subscriptions` function. This function lets you declare any event sources you need to subscribe to given the current model. Just like with `Html Msg` and `Cmd Msg`, these subscriptions will produce `Msg` values that get fed right back into our `update` function.

  3. So far `init` has just been the initial model. Now it produces both a model and some commands, just like the new `update`. This lets us provide a starting value *and* kick off any HTTP requests or whatever that are needed for initialization.

Now it is totally okay if this does not really make sense yet! That only really happens when you start seeing it in action, so lets hop right into the examples!


> **Aside:** One crucial detail here is that commands and subscriptions are *data*. When you create a command, you do not actually *do* it. Same with commands in real life. Let's try it. Eat an entire watermelon in one bite! Did you do it? No! You kept reading before you even *thought* about buying a tiny watermelon.
> 
> Point is, commands and subscriptions are data. You hand them to Elm to actually run them, giving Elm a chance to log all of this information. In the end, effects-as-data means Elm can:
> 
>   - Have a general purpose time-travel debugger.
>   - Keep the "same input, same output" guarantee for all Elm functions.
>   - Avoid setup/teardown phases when testing `update` logic.
>   - Cache and batch effects, minimizing HTTP connections or other resources.
> 
> So without going too crazy on details, pretty much all the nice guarantees and tools you have in Elm come from the choice to treat effects as data! I think this will make more sense as you get deeper into Elm.