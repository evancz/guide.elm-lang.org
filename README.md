# An Introduction to Elm

**Elm is a functional language that compiles to JavaScript.** It competes with projects like React as a tool for creating websites and web apps. Elm has a very strong emphasis on ease-of-use and quality tooling.

This guide will:

  - Teach you the fundamentals of programming in Elm.
  - Show you how to make interactive apps with *The Elm Architecture*.
  - Emphasize the principles and patterns that generalize to programming in any language.

By the end I hope you will not only be able to create great web apps in Elm, but also understand the core ideas and patterns that make this process so nice.

If you are on the fence, I can safely guarantee that if you give Elm a shot, you will end up writing better JavaScript and React code. The ideas transfer pretty easily!


## Why a *functional* language?

On some level, functional programming is not that important for Elm. Elm is *really* about making apps quickly. It is about maintaining great codebases as projects evolve and grow. Ultimately, it is about making delightful products and making them well.

So forget about functional programming. Elm is about:

  - No runtime errors in practice.
  - Friendly error messages that help you add features more quickly.
  - Well-architected code that *stays* well-architected as your app grows.
  - Automatically enforced semantic versioning for all Elm packages.
  - Reliable time-travel debugging.

No combination of JS libraries can ever give you this, yet it is all free and easy in Elm. Now these nice things are *only* possible because Elm builds upon 40+ years of work on typed functional languages. So Elm is a functional language because the practical benefits are worth investing a week in learning.


## Goals


Many resources online address questions like: how do I do X in Elm? How does text input work? How do I make HTTP requests? How does the `foreign` keyword work? The kind of questions you see on StackOverflow for every conceivable scenario in JavaScript.


This guide will cover that kind of stuff of course, but there is a much more important goal! **I want to explain the patterns and principles at the core of Elm.** 