# Effect Managers

Commands and subscriptions are a big part of how Elm works. So far we have just accepted that they exist and that they are very useful.

Well, behind the scenes there are these **effect managers** that handle all the resource management and optimization that makes commands and subscriptions so nice to use!

## General Overview

To be a bit more general, effect managers:

  1. Let library authors to do all the dirty work of managing exotic effects.
  2. Let application authors use all that work with a nice simple API of commands and subscriptions.

**The best example is probably web sockets.** As a user, you just subscribe to messages on a particular URL. Very simple. This is hiding the fact that web sockets are a pain to manage! Behind the scenes an effect manager is in charge of opening connections (which may fail), sending messages (which may fail), detecting when connections go down, queuing messages until the connection is back, and trying to reconnect with an exponential backoff strategy. All sorts of annoying stuff. As the author of the effect manager for web sockets, I can safely say that no one wants to think about this stuff! Effect managers mean that this pain only has to be felt by a handful of people in the community.

This pattern exists for a lot of backend services. Other good examples include:

  - **GraphQL** &mdash; The neat thing about GraphQL is not just the query language, but the fact that you can do query optimization. Say the app makes 4 queries within a few milliseconds. Instead of blindly doing 4 separate HTTP requests, an effect manager could batch them all into one. Furthermore, it could keep a cache of results around and try to reuse results to avoid sending requests all together!
  - **Phoenix Channels** &mdash; This is a variation of web sockets specific to the Elixir programming language. If that is your backend, you will definitely want it to be super simple to subscribe to particular topics in Elm. An effect manager would let you separate out all the code that manages the underlying web socket connection and does topic filtering.
  - **Firebase** &mdash; You want to make it super easy for application code to change things or subscribe to changes. Behind the scenes a bunch of intense stuff needs to happen.

Hopefully the pattern is becoming more clear. A library author sorts out how to interact with a particular backend service once, and then every other developer ever can just use commands and subscriptions without caring about what is behind the curtain.

## Simple Example

Implement an effect manager for producing unique IDs.