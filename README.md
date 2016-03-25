# An Introduction to Elm

Elm is a function language for web programming.


## Functional Programming

On some level, I do not care about functional programming. I care that Elm users can make delightful apps quickly and easily. I care that they can maintain their codebases as requirements change and their project evolves. Ultimately, I care about engineering. Making something excellent and making it well.

In Elm this means:

  - No runtime errors in practice.
  - Friendly error messages that help you add features more quickly.
  - Well-architected code that *stays* well-architected as your app grows.
  - Automatically enforced semantic versioning for all Elm packages.
  - Reliable time-travel debugging.
  - ...

So yeah, functional programming is interesting and cool, but the premise of Elm is **the core concepts of functional programming are extremely *useful*.** So my goal with this language is to strip away all the silly words and mystery surrounding functional programming and finally make a language in the ML-family that is easy to learn and *use*.


## Goals


Many resources online address questions like: how do I do X in Elm? How does text input work? How do I make HTTP requests? How does the `foreign` keyword work? The kind of questions you see on StackOverflow for every conceivable scenario in JavaScript.


This guide will cover that kind of stuff of course, but there is a much more important goal! **I want to explain the patterns and principles at the core of Elm.** 