# Error Handling and Tasks

One of the guarantees of Elm is that you will not see runtime errors in practice. NoRedInk has been using Elm in production for about a year now, and they still have not had one! Like all guarantees in Elm, this comes down to fundamental language design choices. In this case, we are helped by the fact that **Elm treats errors as data.** (Have you noticed we make things data a lot here?)

This section is going to walk through three data structures that help you handle errors in a couple different ways.

  - `Maybe`
  - `Result`
  - `Task`

Now some of you probably want to jump right to tasks, but trust me that going in order will help here! You can think of these three data structures as a progression that slowly address crazier and crazier situations. So if you jump in at the end, it will be a lot to figure out all at once.
