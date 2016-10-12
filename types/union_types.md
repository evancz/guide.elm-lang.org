
# Union Types

Many languages have trouble expressing data with weird shapes. They give you a small set of built-in types, and you have to represent everything with them. So you often find yourself using `null` or booleans or strings to encode details in a way that is quite error prone.

Elm's *union types* let you represent complex data much more naturally. We will go through a couple concrete examples to build some intuition about how and when to use union types.

> **Note:** Union types are sometimes called [tagged unions](https://en.wikipedia.org/wiki/Tagged_union). Some communities call them [ADTs](https://en.wikipedia.org/wiki/Algebraic_data_type).


## Filtering a Todo List

> **Problem:** We are creating a [todo list](http://evancz.github.io/elm-todomvc/) full of tasks. We want to have three views: show *all* tasks, show only *active* tasks, and show only *completed* tasks. How do we represent which of these three states we are in?

Whenever you have weird shaped data in Elm, you want to reach for a union type. In this case, we would create a type `Visibility` that has three possible values:

```elm
> type Visibility = All | Active | Completed

> All
All : Visibility

> Active
Active : Visibility

> Completed
Completed : Visibility
```

Now that we have these three cases defined, we want to create a function `keep` that will properly filter our tasks. It should work like this:

```elm
type alias Task = { task : String, complete : Bool }

buy : Task
buy =
  { task = "Buy milk", complete = True }

drink : Task
drink =
  { task = "Drink milk", complete = False }

tasks : List Task
tasks =
  [ buy, drink ]


-- keep : Visibility -> List Task -> List Task

-- keep All tasks == [buy,drink]
-- keep Active tasks == [drink]
-- keep Complete tasks == [buy]
```

So the `keep` function needs to look at its first argument, and depending on what it is, filter the list in various ways. We use a `case` expression to do this. It is like an `if` on steroids:

```elm
keep : Visibility -> List Task -> List Task
keep visibility tasks =
  case visibility of
    All ->
      tasks

    Active ->
      List.filter (\task -> not task.complete) tasks

    Completed ->
      List.filter (\task -> task.complete) tasks
```

The `case` is saying, look at the structure of `visibility`. If it is `All`, just give back all the tasks. If it is `Active`, keep only the tasks that are not complete. If it is `Completed`, keep only the tasks that are complete.

The cool thing about `case` expressions is that all the branches are checked by the compiler. This has some nice benefits:

 1. If you mistype `Compleet` by accident, you get a hint about the typo.
 2. If you forget to handle a case, the compiler will figure it out and tell you.

So say you want to add `Recent` as a fourth possible `Visibility` value. The compiler will find all the `case` expressions in your code that work with `Visibility` values and remind you to handle the new possibility! This means you can change and extend `Visibility` without the risk of silently creating bugs in existing code.

> **Exercise:** Imagine how you would solve this same problem in JavaScript. Three strings? A boolean that can be `null`? What would the definition of `keep` look like? What sort of tests would you want to write to make sure adding new code later was safe.


## Anonymous Users

> **Problem:** We have a chat room where people can post whatever they want. Some users are logged in and some are anonymous. How should we represent a user?

Again, whenever there is weird shaped data, you want to reach for a union type. For this case, we want one where users are either anonymous or named:

```elm
> type User = Anonymous | Named String

> Anonymous
Anonymous : User

> Named
<function> : String -> User

> Named "AzureDiamond"
Named "AzureDiamond" : User

> Named "abraham-lincoln"
Named "abraham-lincoln" : User
```

So creating the type `User` also created constructors named `Anonymous` and `Named`. If you want to create a `User` you *must* use one of these two constructors. This guarantees that all the possible `User` values are things like:

```elm
  Anonymous
  Named "AzureDiamond"
  Named "abraham-lincoln"
  Named "catface420"
  Named "Tom"
  ...
```

Now that we have a representation of a user, lets say we want to get a photo of them to show next to their posts. Again, we need to use a `case` expression to work with our `User` type:

```elm
userPhoto : User -> String
userPhoto user =
  case user of
    Anonymous ->
      "anon.png"

    Named name ->
      "users/" ++ name ++ ".png"
```

There are two possible cases when we have a `User`. If they are `Anonymous` we show a dummy picture. If they are `Named` we construct the URL of their photo. This `case` is slightly fancier than the one we saw before. Notice that the second branch has a lower case variable `name`. This means that when we see a value like `Named "AzureDiamond"`, the `name` variable will be bound to `"AzureDiamond"` so we can do other things with it. This is called *pattern matching*.

Now imagine we have a bunch of users in a chat room and we want to show their pictures.

```elm
activeUsers : List User
activeUsers =
  [ Anonymous, Named "catface420", Named "AzureDiamond", Anonymous ]

photos : List String
photos =
  List.map userPhoto activeUsers

-- [ "anon.png", "users/catface420.png", "users/AzureDiamond.png", "anon.png" ]
```

The nice thing about creating a type like `User` is that no one in your whole codebase can ever "forget" that some users may be anonymous. Anyone who can get a hold of a `User` needs to use a `case` to get any information out of it, and the compiler guarantees every `case` and handles all possible scenarios!

> **Exercise:** Think about how you would solve this problem in some other language. A string where empty string means they are anonymous? A string that can be null? How much testing would you want to do to make sure that everyone handles these special cases correctly?


## Widget Dashboard

> **Problem:** You are creating a dashboard with three different kinds of widgets. One shows recent log data, one shows time plots, and one shows scatter plots. How do you represent a widget?

Alright, we are getting a bit fancier now. In Elm, you want to start by solving each case individually. (As you get more experience, you will see that Elm *wants* you to build programs out of small, reusable parts. It is weird.) So I would create representations for each of our three scenarios, along with `view` functions to actually turn them into HTML or SVG or whatever:

```elm
type alias LogsInfo =
  { logs : List String
  }

type alias TimeInfo =
  { events : List (Time, Float)
  , yAxis : String
  }

type alias ScatterInfo =
  { points : List (Float, Float)
  , xAxis : String
  , yAxis : String
  }

-- viewLogs : LogsInfo -> Html msg
-- viewTime : TimeInfo -> Html msg
-- viewScatter : ScatterInfo -> Html msg
```

At this point, you have created all the helper functions needed to work with these three cases totally independent from each other. Someone can come along later and say, "I need a nice way to show scatter plots" and use just that part of the code.

So the question is really: how do I put these three standalone things together for my particular scenario?

Again, union types are there to put together a bunch of different types!

```elm
> type Widget = Logs LogsInfo | TimePlot TimeInfo | ScatterPlot ScatterInfo

> Logs
<function> : LogsInfo -> Widget

> TimePlot
<function> : TimeInfo -> Widget

> ScatterPlot
<function> : ScatterInfo -> Widget
```

So we created a `Widget` type that can only be created with these constructor functions. You can think of these constructors as *tagging* the data so we can tell it apart at runtime. Now we can write something to render a widget like this:

```elm
view : Widget -> Html msg
view widget =
  case widget of
    Logs info ->
      viewLogs info

    TimePlot info ->
      viewTime info

    ScatterPlot info ->
      viewScatter info
```

One nice thing about this approach is that there is no mystery about what kind of widgets are supported. There are exactly three. If someone wants to add a fourth, they modify the `Widget` type. This means you can never be surprised by the data you get, even if someone on a different team is messing with your code.

> **Takeaways:**
>
>   - Solve each subproblem first.
>   - Use union types to put together all the solutions.
>   - Creating a union type generates a bunch of *constructors*.
>   - These constuctors *tag* data so that we can differentiate it at runtime.
>   - A `case` expression lets us tear data apart based on these tags.
> 
> The same strategies can be used if you are making a game and have a bunch of different bad guys. Goombas should update one way, but Koopa Troopas do something totally different. Solve each problem independently, and then use a union type to put them all together.


## Linked Lists

> **Problem:** You are stuck on a bus speeding down the highway. If the bus slows down, it will blow up. The only way to save yourself and everyone on the bus is to reimplement linked lists in Elm. HURRY, WE ARE RUNNING OUT OF GAS!

Yeah, yeah, the problem is contrived this time, but it is important to see some of the more advanced things you can do with union types!

A [linked list](https://en.wikipedia.org/wiki/Linked_list) is a sequence of values. If you are looking at a linked list, it is either empty or it is a value and more list. That list is either empty or is a value and more list. etc. This intuitive definition works pretty directly in Elm. Let's see it for lists of integers:

```elm
> type IntList = Empty | Node Int IntList

> Empty
Empty : IntList

> Node
<function> : Int -> IntList -> IntList

> Node 42 Empty
Node 42 Empty : IntList

> Node 64 (Node 128 Empty)
Node 64 (Node 128 Empty) : IntList
```

Now we did two new things here:

  1. The `Node` constructor takes *two* arguments instead of one. This is fine. In fact, you can have them take as many arguments as you want.
  2. Our union type is *recursive*. An `IntList` may hold another `IntList`. Again, this is fine if you are using union types.

The nice thing about our `IntList` type is that now we can only build valid linked lists. Every linked list needs to start with `Empty` and the only way to add a new value is with `Node`.

It is equally nice to work with. Let's say we want to compute the sum of all of the numbers in a list. Just like with any other union type, we need to use a `case` and handle all possible scenarios:

```elm
sum : IntList -> Int
sum numbers =
  case numbers of
    Empty ->
      0

    Node n remainingNumbers ->
      n + sum remainingNumbers
```

If we get an `Empty` value, the sum is 0. If we have a `Node` we add the first element to the sum of all the remaining ones. So an expression like `(sum (Node 1 (Node 2 (Node 3 Empty))))` is evaluated like this:

```elm
  sum (Node 1 (Node 2 (Node 3 Empty)))
  1 + sum (Node 2 (Node 3 Empty))
  1 + (2 + sum (Node 3 Empty))
  1 + (2 + (3 + sum Empty))
  1 + (2 + (3 + 0))
  1 + (2 + 3)
  1 + 5
  6
```

On each line, we see one evaluation step. When we call `sum` it transforms the list based on whether it is looking at a `Node` or an `Empty` value.

> **Note:** This is the first recursive function we have written together! Notice that `sum` calls itself to get the sum. It can be tricky to get into the mindset of writing recursive functions, so I wanted to share one weird trick. **Pretend you are already done.**
> 
> I always start with a `case` and all of the branches listed but not filled in. From there, I solve each branch one at a time, pretending that nothing else exists. So with `sum` I'd look at `Empty ->` and say, an empty list has to sum to zero. Then I'd look at the `Node n remainingNumbers ->` branch and think, well, I know I have a number, a list, and a `sum` function that definitely already exists and totally works. I can just use that and add a number to it!

## Generic Data Structures

> **Problem:** The last section showed linked lists that only worked for integers. That is pretty lame. How can we make linked lists that hold any kind of value?

Everything is going to be pretty much the same, except we are going to introduce a *type variable* in our definition of lists:

```elm
> type List a = Empty | Node a (List a)

> Empty
Empty : List a

> Node
<function> : a -> List a -> List a

> Node "hi" Empty
Node "hi" Empty : List String

> Node 1.618 (Node 6.283 Empty)
Node 1.618 (Node 6.283 Empty) : List Float
```

The fancy part comes in the `Node` constructor. Instead of pinning the data to `Int` and `IntList`, we say that it can hold `a` and `List a`. Basically, you can add a value as long as it is the same type of value as everything else in the list.

Everything else is the same. You pattern match on lists with `case` and you write recursive functions. The only difference is that our lists can hold anything now!

> **Exercise:** This is exactly how the `List` type in Elm works, so take a look at [the `List` library](http://package.elm-lang.org/packages/elm-lang/core/latest/List) and see if you can implement some of those functions yourself.


## Additional Examples

We have seen a couple scenarios, but the best way to get more comfortable is to use union types more! So here are two examples that are kind of fun.


### Binary Trees

[Binary trees](https://en.wikipedia.org/wiki/Binary_tree) are almost exactly the same as linked lists:

```elm
> type Tree a = Empty | Node a (Tree a) (Tree a)

> Node
<function> : a -> Tree a -> Tree a -> Tree a

> Node "hi" Empty Empty
Node "hi" Empty Empty : Tree String
```

A tree is either empty or it is a node with a value and two children. Check out [this example](http://elm-lang.org/examples/binary-tree) for more info on this. If you can do all of the exercises at the end of that link, consider yourself a capable user of union types!


### Languages

We can even model a programming language as data if we want to go really crazy! In this case, it is one that only deals with [Boolean algebra](https://en.wikipedia.org/wiki/Boolean_algebra#Operations):

```elm
type Boolean
    = T
    | F
    | Not Boolean
    | And Boolean Boolean
    | Or Boolean Boolean

true = Or T F
false = And T (Not T)
```

Once we have modeled the possible values we can define functions like `eval` which evaluates any `Boolean` to `True` or `False`. See [this example](http://elm-lang.org/examples/boolean-expressions) for more about representing boolean expressions.
