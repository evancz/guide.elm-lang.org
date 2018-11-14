# `Html.Keyed`

On the previous page, we learned how Virtual DOM works and how we can use `Html.Lazy` to avoid a bunch of work. Now we are going to introduce  [`Html.Keyed`](https://package.elm-lang.org/packages/elm/html/latest/Html-Keyed/) to skip even more work.

This optimization is particularly helpful for lists of data in your interface that must support **insertion**, **removal**, and **reordering**.


## The Problem

Say we have a list of all the Presidents of the United States. And maybe it lets us sort by name, [by education](https://en.wikipedia.org/wiki/List_of_Presidents_of_the_United_States_by_education), [by net worth](https://en.wikipedia.org/wiki/List_of_Presidents_of_the_United_States_by_net_worth), and [by birthplace](https://en.wikipedia.org/wiki/List_of_Presidents_of_the_United_States_by_home_state).

When the diffing algorithm (described on the previous page) gets to a long list of items, it just goes through pairwise:

- Diff the current 1st element with the next 1st element.
- Diff the current 2nd element with the next 2nd element.
- ...

But when you change the sort order, all of these are going to be different! So you end up doing a lot of work on the DOM when you could have just shuffled some nodes around.

This issue exists with insertion and removal as well. Say you remove the 1st of 100 items. Everything is going to be off-by-one and look different. So you get 99 diffs and one removal at the end. No good!


## The Solution

The fix for all of this is [`Html.Keyed.node`](https://package.elm-lang.org/packages/elm/html/latest/Html-Keyed#node), which makes it possible to pair each entry with a “key” that easily distinguishes it from all the others.

So in our presidents example, we could write our code like this:

```elm
import Html exposing (..)
import Html.Keyed as Keyed
import Html.Lazy exposing (lazy)

viewPresidents : List President -> Html msg
viewPresidents presidents =
  Keyed.node "ul" [] (List.map viewKeyedPresident presidents)

viewKeyedPresident : President -> (String, Html msg)
viewKeyedPresident president =
  ( president.name, lazy viewPresident president )

viewPresident : President -> Html msg
viewPresident president =
  li [] [ ... ]
```

Each child node is associated with a key. So instead of doing a pairwise diff, we can diff based on matching keys!

Now the Virtual DOM implementation can recognize when the list is resorted. It first matches all the presidents up by key. Then it diffs those. We used `lazy` for each entry, so we can skip all that work. Nice! It then figures out how to shuffle the DOM nodes to show things in the order you want. So the keyed version does a lot less work in the end.

Resorting helps show how it works, but it is not the most common case that really needs this optimization. **Keyed nodes are extremely important for insertion and removal.** When you remove the 1st of 100 elements, using keyed nodes allows the Virtual DOM implementation to recognize that immediately. So you get a single removal instead of 99 diffs.


## Summary

Touching the DOM is extraordinarily slow compared to the sort of computations that happen in a normal application. **Always reach for `Html.Lazy` and `Html.Keyed` first.** I recommend verifying this with profiling as much as possible. Some browsers provide a timeline view of your program, [like this](https://developers.google.com/web/tools/chrome-devtools/evaluate-performance/reference). It gives you a summary of how much time is spent in loading, scripting, rendering, painting, etc. If you see that 10% of the time is spent scripting, you could make your Elm code twice as fast and not make any noticable difference. Whereas simple additions of lazy and keyed nodes could start taking big chunks out of that other 90% by touching the DOM less!
