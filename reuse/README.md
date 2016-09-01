# Scaling The Elm Architecture

If you are coming from JavaScript, you are probably wondering &ldquo;where are my reusable components?&rdquo; and &ldquo;how do I do parent-child communication between them?&rdquo; A great deal of time and effort is spent on these questions in JavaScript, but it just works different in Elm. **We do not think in terms of reusable components.** Instead, we focus on reusable *functions*. It is a functional language after all!

So this chapter will go through a few examples that show how we create **reusable views** by breaking out helper functions to display our data. We will also learn about Elm&rsquo;s *module system* which helps you break your code into multiple files and hide implementation details. These are the core tools and techniques of building large app with Elm.

In the end, I think we end up with something far more flexible and reliable than &ldquo;reusable components&rdquo; and there is no real trick. We will just be using the fundamental tools of functional programming!
