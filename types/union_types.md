
# Union Types

Many languages have trouble expressing data with weird shapes. They give you a small set of built-in types, and you have to represent everything with them. So you often find yourself using `null` or booleans or strings to encode details in a way that is quite error prone.

Elm's *union types* let you represent complex data much more naturally. We will go through a couple concrete examples to build some intuition about how and when to use union types.

> **Note:** Union types are sometimes called [tagged unions](https://en.wikipedia.org/wiki/Tagged_union). Some communities call them [ADTs](https://en.wikipedia.org/wiki/Algebraic_data_type).


## Filtering a Todo List

> **Problem:** We are creating a [todo list](http://evancz.github.io/elm-todomvc/) full of tasks. We want to have three views: show *all* tasks, show only *active* tasks, and show only *completed* tasks. How do we represent which of these three states we are in?

Whenever you have weird shaped data in Elm, you want to reach for a union type. In this case, we would create a type `Visiblity` that has three possible values:

```elm
> type Visiblity = All | Active | Completed

> All
All : Visiblity

> Active
Active : Visiblity

> Completed
Completed : Visiblity
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
 2. If you forget to handle a value, the compiler will figure it out and tell you.

So say you want to add `Recent` as a fourth possible `Visibility` value. The compiler will find all the `case` expressions in your code that work with `Visibility` values and remind you to handle the new possibility! This means you can change and extend `Visibility` without the risk of silently creating bugs in existing code.

> **Exercise:** Imagine how you would solve this same problem in JavaScript. Three strings? A boolean that can be `null`? What would the definition of `keep` look like? What sort of tests would you want to write to make sure adding new code later was safe.


## Anonymous Users

> **Problem:** We have a chat room where people can post whatever they want. Some users are logged in and some are anonymous. How should we represent a user?

Here is a union type that describes users that are either anonymous or named:

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

Again, we need to use a `case` expression to work with our `User` type. Say we want to get a users photo:

```elm
userPhoto : User -> String
userPhoto user =
  case user of
    Anonymous ->
      "anon.png"

    LoggedIn name ->
      "users/" ++ name ++ "/photo.png"
```

There are two possible cases when we have a `User`. If they are `Anonymous` we show a dummy picture. If they are `LoggedIn` we construct the URL of their photo.

Now imagine we have a bunch of users in a chat room and we want to show their pictures.

```elm
activeUsers : List User
activeUsers =
  [ Anonymous, LoggedIn "catface420", LoggedIn "AzureDiamond", Anonymous ]
```

If we combine the `userPhoto` function with our `activeUsers` list, we can get all the images we need:

```elm
photos =
  List.map userPhoto activeUsers

-- [ "anon.png", "users/catface420.jpg", "users/AzureDiamond.jpg", "anon.png" ]
```

The nice thing about creating a type like `User` is that no one in your whole codebase can ever "forget" that some users may be anonymous. To deal with a `User`, the compiler will guarantee that the programmer uses a `case` and handles both possible scenarios.


## Tagged Data

> **Problem:** You are creating a dashboard with three different kinds of widgets. One shows scatter plots, one shows recent log data, and one shows time plots.

Type unions make it really easy to put together the data we need:

```elm
type Widget
    = ScatterPlot (List (Int, Int))
    | LogData (List String)
    | TimePlot (List (Time, Int))
```

You can think of this as putting together three different types. Each type is &ldquo;tagged&rdquo; with a name like `ScatterPlot` or `LogData`. This lets us tell them apart when your program is running. Now we can write something to render a widget like this:

```elm
view : Widget -> Element
view widget =
    case widget of
      ScatterPlot points ->
          viewScatterPlot points

      LogData logs ->
          flow down (map viewLog logs)

      TimePlot occurrences ->
          viewTimePlot occurrences
```

Depending on what kind of widget we are looking at, we will render it differently. Perhaps we want to get a bit trickier and have some time plots that are showed on a logarithmic scale. We can augment our `Widget` type a bit.

```elm
type Scale = Normal | Logarithmic

type Widget
    = ScatterPlot (List (Int, Int))
    | LogData (List String)
    | TimePlot Scale (List (Time, Int))
```

Notice that the `TimePlot` tag now has two pieces of data. Each tag can actually hold a bunch of different types.

All of these strategies can be used if you are making a game and have a bunch of different bad guys. Goombas should update one way, but Koopa Troopas do something totally different. Use a tagged union to put them all together!


## Banishing NULL

Tons of languages have a concept of `null`. Any time you think you have a `String` you just might have a `null` instead. Should you check? Did the person giving you the value check? Maybe it will be fine? Maybe it will crash your servers? I guess we will find out later!

The inventor, Tony Hoare, has this to say about it:

> I call it my billion-dollar mistake. It was the invention of the null reference in 1965. At that time, I was designing the first comprehensive type system for references in an object oriented language (ALGOL W). My goal was to ensure that all use of references should be absolutely safe, with checking performed automatically by the compiler. But I couldn't resist the temptation to put in a null reference, simply because it was so easy to implement. This has led to innumerable errors, vulnerabilities, and system crashes, which have probably caused a billion dollars of pain and damage in the last forty years.

Elm sidesteps this problem entirely with a type called `Maybe`. You can think of it as making `null` explicit, so we *know* if we have to handle it.

```elm
type Maybe a = Just a | Nothing
```

Notice that this type takes an argument `a` that we can fill in with any type we want. We can have types like `(Maybe Int)` which is either `Just` an integer or it is `Nothing`. For example, say we want to parse months from strings.

```elm
String.toInt : String -> Result String Int


toMonth : String -> Maybe Int
toMonth rawString =
    case String.toInt rawString of
      Err message ->
          Nothing

      Ok n ->
          if n > 0 && n <= 12 then Just n else Nothing
```

The contract for `toMonth` explicitly tells everyone that it will give back an integer *or* it won't! You never have to wonder if there is a `null` value sneaking around.

This may seem like a subtle improvement, but imagine all the code you have where you defensively added a `null` check just in case someone else behaves badly. Having contracts means you have a guarantee that a caller won't send you bad data! This is a world where you never again have to spend 4 hours debugging a null pointer exception!


## Recursive Data Structures

If you have ever implemented a [linked list](https://en.wikipedia.org/wiki/Linked_list) in C or Java you will appreciate how easy this is in Elm. The following type represents a list. The front of a list can only be one of two things: empty or something followed by a list. We can turn this informal definition into a type:

```elm
type List a = Empty | Node a (List a)
```

So this creates a type called `List`. A list can either be empty or it can have one element (called the *head* of the list) and &ldquo;the rest of the list&rdquo; (called the *tail* of the list).

List also takes a type as an argument, so we can create `(List Int)` or `(List String)` or whatever. The values that have the type `(List Int)` would look like this:

  * `Empty`
  * `Node 1 Empty`
  * `Node 3 (Node 2 (Node 1 Empty))`

All of these have the same type, so they can be used in all the same places. So when we pattern match we can define what we want to do in each case. Say we want to compute the sum of all of the numbers in a list. The following function defines the logic for each possible scenario.

```elm
sum : List Int -> Int
sum xs =
    case xs of
      Empty ->
          0

      Node first rest ->
          first + sum rest
```

If we get an `Empty` value, the sum is 0. If we have a `Node` we add the first element to the sum of all the remaining ones. So an expression like `(sum (Node 1 (Node 2 (Node 3 Empty))))` is evaluated like this:

  * `sum (Node 1 (Node 2 (Node 3 Empty)))`
  * `1 + sum (Node 2 (Node 3 Empty))`
  * `1 + (2 + sum (Node 3 Empty))`
  * `1 + (2 + (3 + sum Empty))`
  * `1 + (2 + (3 + 0))`
  * `1 + (2 + 3)`
  * `1 + 5`
  * `6`

On each line, we see one evaluation step. When we call `sum` it transforms the list based on whether it is looking at a `Node` or an `Empty` value.

Making lists is just the start, we can easily create all sorts of data structures, like [binary trees][binary].

 [binary]: https://en.wikipedia.org/wiki/Binary_tree "Binary Trees"

```elm
type Tree a = Empty | Node a (Tree a) (Tree a)
```

A tree is either empty or it is a node with a value and two children. Check out [this example][trees] to see some more examples of union types for data structures. If you can do all of the exercises at the end of the example, consider yourself a capable user of this feature!

[trees]: /examples/binary-tree

> **Note:** Imagine doing this binary tree exercise in Java. We would probably be working with one super class and two sub classes just to define a tree in the first place! Imagine doing it in JavaScript. It is not quite as bad at first, but imagine trying to refactor the resulting code later if you need to change the core representation. Sneaky breakages everywhere!

We can even model a programming language as data if we want to go really crazy! In this case, it is one that only deals with [Boolean algebra][algebra]:

[algebra]: https://en.wikipedia.org/wiki/Boolean_algebra#Operations "Boolean Algebra"

```elm
type Boolean
    = T
    | F
    | Not Boolean
    | Or  Boolean Boolean
    | And Boolean Boolean

true = Or T F
false = And T (Not T)
```

Once we have modeled the possible values we can define functions like `eval` which evaluates any `Boolean` to `True` or `False`. See [this example][bool] for more about representing boolean expressions.

[bool]: /examples/boolean-expressions