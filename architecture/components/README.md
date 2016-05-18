# The Elm Architecture + Modularity

So we are doing pretty well so far. We can handle user input. We can make HTTP requests. We can communicate on web sockets. That is a solid start, but **what happens when our code starts getting big?** It would be crazy to just grow your `Model` and `update` functions endlessly. This is where Elm's module system comes in.

The basic idea is: **nest The Elm Architecture pattern again and again.** We will explore a few examples of nesting to make this idea clear.