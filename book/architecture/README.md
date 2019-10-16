# The Elm Architecture

The Elm Architecture is a pattern for architecting interactive programs, like webapps and games.

This architecture seems to emerge naturally in Elm. Rather than someone inventing it, early Elm programmers kept discovering the same basic patterns in their code. It was kind of spooky to see people ending up with well-architected code without planning ahead!

So The Elm Architecture is easy in Elm, but it is useful in any front-end project. In fact, projects like Redux have been inspired by The Elm Architecture, so you may have already seen derivatives of this pattern. Point is, even if you ultimately cannot use Elm at work yet, you will get a lot out of using Elm and internalizing this pattern.


## The Basic Pattern

Elm programs always look something like this:

![Diagram of The Elm Architecture](buttons.svg)

The Elm program produces HTML to show on screen, and then the computer sends back messages of what is going on. "They clicked a button!"

What happens within the Elm program though? It always breaks into three parts:

  * **Model** &mdash; the state of your application
  * **View** &mdash; a way to turn your state into HTML
  * **Update** &mdash; a way to update your state based on messages

These three concepts are the core of **The Elm Architecture**.

The next few examples are going to show how to use this pattern for user input, like buttons and text fields. It will make this much more concrete!


## Follow Along

The examples are all available in the online editor:

[![online editor](try.png)](https://elm-lang.org/try)

This editor shows hints in the top left corner:

<video id="hints-video" width="360" height="180" autoplay loop style="margin: 0.55em 0 1em 2em;" onclick="var v = document.getElementById('hints-video'); v.paused ? (v.play(), v.style.opacity = 1) : (v.pause(), v.style.opacity = 0.5)">
  <source src="hints.mp4" type="video/mp4">
</video>

Be sure to try out the hints if you run into something confusing!
