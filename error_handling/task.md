# Tasks

**Work in Progress** - Full docs coming in the next few weeks! Until then, the [docs](http://package.elm-lang.org/packages/elm-lang/core/4.0.0/Task) will give a partial overview.

Think of a task as a todo list. Like if you need to make a doctor's appointment there are a series of steps you follow: **Call the doctor's office, schedule a time, show up at that time, wait around for a while, see the doctor.** Okay, are you sitting in front of a doctor right now? No! Tasks in Elm are like tasks in real life. Just because you *describe* a task does not mean you *did* the task. Elm is not a magician.

To be a bit more concrete, tasks in Elm are useful for things like HTTP requests, getting the current time, and printing things out to the console. Generally stuff that interacts with services outside your program, takes a long time, or may fail. Let&rsquo;s see some examples of tasks.


## Building Blocks

One of the simpler tasks is [`getString`](http://package.elm-lang.org/packages/evancz/elm-http/latest/Http#getString) which tries to get a string from a given URL. The type is like this:

```elm
getString : String -> Task Error String
```

So we see the URL as the argument, and it is giving back a *task*. Again, this does not mean we are actually making the GET request. We are just describing what we want to do, like how writing down &ldquo;buy milk&rdquo; does not mean it magically appears in your fridge.

The interesting thing here is the return type `Task Error String`. This is saying: I have a task that may fail with an [`Http.Error`](http://package.elm-lang.org/packages/evancz/elm-http/latest/Http#Error) or succeed with a `String`. This makes it impossible to forget about the bad possibilities. The server may be down. The internet connection may be down. The server may respond with bad data. Etc. By making these possibilities explicit, an Elm programmer has to consider these cases. In the end, it means they build more reliable applications.

> **Note:** This is very similar to the [`Result`](http://package.elm-lang.org/packages/elm-lang/core/latest/Result) type we saw in [the previous section](result.md). You explicitly model failure and success. You then put things together with `map` and `andThen`. The key difference is that a `Result` is already done and a `Task` is not. You can pattern match on a `Result` and see if it is `Ok` or `Err` because it is complete. But a task still needs to be performed, so you do not have that ability anymore.

Another one of the simpler tasks is [`Time.now`](http://package.elm-lang.org/packages/elm-lang/core/latest/Time#now) which just gets the current time:

```elm
Time.now : Task x Time
```

There are a few things to notice here. First, notice that `Time.now` has no arguments. There is nothing to configure here, you just have &ldquo;get the current time&rdquo; described as a task. Second, notice that the error type is the type variable `x`. When we saw `Http.getString` it had a concrete error type `Http.Error`. The `Time.now` task is different in that it will not fail in a special way. You will always get the time back. This type variable `x` is basically saying &ldquo;I am not going to force you to handle a particular type of errors&rdquo; because it does not produce any.


## Chaining Tasks

It is great to do one task, but to do anything interesting, you probably need to do a bunch of tasks in a row. This is where the `andThen` function comes in:

```elm
andThen : Task x a -> (a -> Task x b) -> Task x b
```

The short summary is: we try one task **and then** we try another task.

But to break it down a bit more, `andThen` takes two arguments:

  1. A task that may succeed with a value of type `a`
  2. A callback that takes a value of type `a` and produces a new task.

First you try to do `Task x a`. If it fails, the whole thing fails. If it succeeds, we take the resulting `a` value and create a second task. We then try to do that task too. This gives us the ability to chain together as many tasks as we want.

For example, maybe we want to GET stock quotes from a particular time. We could do something like this:

```elm
getStockQuotes =
  Time.now andThen \time ->
    Http.getString ("//www.example.com/stocks?time=" ++ toString time)
```

So we get the current time **and then** we make a GET request.
