# The Elm Architecture + Effects

The last section showed how to handle all sorts of user input, but what can we *do* with it?

This section builds on the basic pattern we have seen so far, giving you the ability to make HTTP requests or subscribe to messages from web sockets. All of these effects are built on two important concepts:

  - **Commands** &mdash; A command is a way of demanding some effect. Maybe this is asking for a random number or making an HTTP request. Anything where you are asking for some value and the answer may be different depending on what is going on in the world.

  - **Subscriptions** &mdash; A subscription lets you register that you are interested in something. Maybe you want to hear about geolocation changes? Maybe you want to hear all the messages coming in on a web socket? Subscriptions let you sit passively and only get updates when they exist.

Together, commands and subscriptions make it possible for your Elm components to talk the outside world.

This section covers a lot of important APIs as it gradually digs into these new concepts. I have ordered the examples to build on each other, so while you may want to skip to HTTP *right now*, I think you will end up reaching your goal faster if you read them in order.

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