# Tasks

**Work in Progress** - Full docs coming in the next few weeks! Until then, the [docs](http://package.elm-lang.org/packages/elm-lang/core/4.0.0/Task) will give a partial overview.

Think of a task as a todo list. Like if you need to make a doctor's appointment there are a series of steps you follow: **Call the doctor's office, schedule a time, show up at that time, wait around for a while, see the doctor.** Okay, are you sitting in front of a doctor right now? No! Tasks in Elm are like tasks in real life. Just because you *describe* a task does not mean you *did* the task. Elm is not a magician.


## Building Blocks

One of the simplest tasks is `getString` which tries to get a string from a given URL. The type is like this:

```elm
getString : String -> Task Error String
```

So we see the URL as the argument, and it is giving back a *task*. Again, this does not mean we are actually making the GET request. We are just describing what we want to do, like how writing down &ldquo;buy milk&rdquo; does not mean it magically appears in your fridge.

The interesting thing here is the return type `Task Error String`. This is saying: I have a task that may fail with an [`Http.Error`](http://package.elm-lang.org/packages/evancz/elm-http/3.0.1/Http#Error) or succeed with a `String`. This makes it impossible to forget about the bad possibilities. The server may be down. The internet connection may be down. The server may respond with bad data. Etc. By making these possibilities explicit, an Elm programmer has to consider these cases. In the end, it means they build more reliable applications.

> **Note:** This is very similar to the [`Result`](http://package.elm-lang.org/packages/elm-lang/core/latest/Result) type we saw in [the previous section](result.md). You explicitly model failure and success. You then put things together with `map` and `andThen`. The key difference is that a `Result` is already done and a `Task` is not. You can pattern match on a `Result` and see if it is `Ok` or `Err` because it is complete. But a task still needs to be performed, so you do not have that ability anymore.