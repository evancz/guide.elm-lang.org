# Nesting


* * *

**Stuff from Elsewhere**

You have no idea how it works internally. You do not want to know! Someone on the other side of the world can be adding features to `Story`. Adding things to the model, talking to different backends, totally changing `view` to add new features, etc. It does not matter. You just work with this well-defined public API.

So when you want to create a news feed, you `import Story` and work exclusively with its public API. In the end you will have a module with a public API like this:

```elm
module NewsFeed exposing (Model, init, Msg, update, view, subscriptions)
```

Look familiar? It has the same public API as `Story`! So now when you use `NewsFeed` you do not need to care at all about any internal details.

You just keep nesting like this until you are done.

> **Note:** When coming to Elm from languages like Java, it is important to remember that **modules are for modularity** in Elm. That's how we do it. A lot of people think "encapsulation needs X and Y, where is that in Elm?" or "objects = modularity" or "encapsulation = modularity" and lots of other things. It just works different here. So if you read this section *without* trying to connect it back to Java, you will get a lot more out of it!