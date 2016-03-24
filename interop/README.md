# Interop

Interop extraordinarily important if you want your language to succeed!

This is just a historical fact. A huge part of why C++ was so successful was that it was easy to migrate a massive C codebase. If you look at the JVM, you see Scala and Clojure carving out pretty big niches for themselves thanks to their nice interop story with Java. For industrial users, there is no point in having an amazing language with great guarantees if there is no way to slowly introduce it into an existing codebase! It is exactly the same in browsers too.

This section focus on the major kinds of interop that you need when working in browsers.

  1. How to communicate with external services using JSON.
  2. How to embed Elm programs in existing HTML or React apps.
  3. How to communicate with existing JavaScript code.

Each of these types of interop are guided by the self-imposed constraints that (1) there must be a clear way to introduce Elm gradually into diverse environments and (2) Elm should not have to sacrifice its core design principles. In other words, **I want Elm to be amazing and I want you to be able to use it at work.** An elusive combination.

Ultimately, this is about risk management. People should be able to try it Elm out in a tiny experiment. If the experiment goes bad, they can just not use Elm! If it goes great, they can expand it to cover more and more of their codebase. History seems to suggest that there is no realistic way to translate an existing project into a new language all at once. You have to evolve gradually!