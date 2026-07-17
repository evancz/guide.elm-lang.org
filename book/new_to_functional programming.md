
# New to Functional Programming

## Elm isn't like imperative languages like C, C#, C++, Java, JavaScript, PHP, Python ...

If Elm is your first pure functional language it may require several large departures from how you think about designing programs. It doesn't take very long to work through Elm's features and get to the point where you miss pure functional programming when using in other languages!

Let's start with a big departure: **there are no variables, only constants**

In many languages, syntax is required to differentiate constants from variables. As Elm only has constants it doesn't have to denote them from variables. Thus, constants are simply called **values**.

Without variables, Elm also forgoes primitive loop control flows such as **for** and **while**. Instead, Elm has data structures such as **lists** and functions to manipulate the data stored.

Without variables the number of states an Elm program can have is greatly reduced, making testing far easier than imperative languages.

The second departure, is arguably even bigger: **an Elm function returns the exact same output given the same input**

Sounds straightforward when you first read it, doesn't it? But then it dawns on you - a function can't retrieve the current time, generate a random number or get data from a web service, as all can lead to different outputs for the same input. Instead, any such data is passed to the function as an input.

You'll see later how timestamps, random numbers and web data are retrieved and passed into functions but, for now, enjoy the thought ***Elm functions are so much easier to write tests for***.

Functions then, are really just calculated values. Elm functions can conceptually be replaced by look-up tables because a set of inputs can be directly paired to a set of outputs with each input paired to exactly one output.

The third departure to cover here is **functions can't cause side effects** 

Now, Elm code compiles to JavaScript, to run within a web browser. So, for example, the Elm architecture provides for updating web documents using the Document Object Model (DOM) - your Elm code doesn't manipulate the DOM directly and you'll find that liberating - Elm is very fast at updating web documents. You simply write **update** functions to provide the data you want the DOM updated with.
