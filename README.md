# An Introduction to Elm

**Elm is a functional language that compiles to JavaScript.** It competes with projects like React as a tool for creating websites and web apps.


## Why a *functional* language?

On some level, functional programming is not that important for Elm. Elm is *really* about making delightful apps quickly. It is about maintaining great codebases as projects evolve and grow. Ultimately, it is about making excellent products and making them well.

So forget about functional programming. Elm is about:

  - No runtime errors in practice.
  - Friendly error messages that help you add features more quickly.
  - Well-architected code that *stays* well-architected as your app grows.
  - Automatically enforced semantic versioning for all Elm packages.
  - Reliable time-travel debugging.
  - ...

No combination of JS libraries can ever give you this, yet it is free and easy in Elm. Now these nice things are *only* possible because Elm builds upon 40+ years of work on typed functional languages. So Elm is a functional language because it lets us build a better ecosystem than ever before.


## Goals


Many resources online address questions like: how do I do X in Elm? How does text input work? How do I make HTTP requests? How does the `foreign` keyword work? The kind of questions you see on StackOverflow for every conceivable scenario in JavaScript.


This guide will cover that kind of stuff of course, but there is a much more important goal! **I want to explain the patterns and principles at the core of Elm.** 