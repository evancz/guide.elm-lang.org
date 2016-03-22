# Interop

The popular notion of language interop is roughly that "C code should be available for use *anywhere* in C++ code". This is the notion you see when you compare Java and Scala, or when you compare JavaScript and TypeScript. This is great for migration, but it forces you to make quite extreme sacrifices in the new language.

Elm's interop story is built on the observation that **by enforcing some architectural rules, you can make full use of the old language without making sacrifices in the new one.** This means we can keep making guarantees like "you will not see runtime errors in Elm" even as you start introducing whatever crazy JavaScript code you need.

> **Note:** In the year that NoRedInk has been using Elm, they have not gotten a single runtime error from Elm code. JavaScript code still crashes of course, but that makes up a diminishing fraction of their code.
