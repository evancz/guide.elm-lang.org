# The Elm Architecture + Reusable Components

So we are doing pretty well so far. We can handle user input. We can make HTTP requests. We can communicate on web sockets. That is a solid start, but **what happens when our code starts getting big?** It would be crazy to just grow your `Model` and `update` functions endlessly.

This is where Elm's module system comes in.


> **Note:** When coming to Elm from languages like Java, it is important to remember that **modules are for modularity** in Elm. That's how we do it. A lot of people think "encapsulation needs X and Y, where is that in Elm?" or "objects = modularity" or "encapsulation = modularity" and lots of other things. It just works different here. So if you read this section *without* trying to connect it back to Java, you will get a lot more out of it!