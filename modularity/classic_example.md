
# A Classic Example

Now that we know the basic syntax around modules, we will make a `Queue` library.

> **Note:** Why start with a data structure? No one ever writes data structures in day-to-day work! The point is to *think* right. Data structures happen to highlight a bunch of important aspects of writing great modules. Think of this as an introduction to the ideal use of modules.


## Creating the Contract

A `Queue` is just like the line at the post office or grocery store. If you speak British English, it is just like a queue. Things start at the end and they come out the front. That is all there is to it. We will start by outlining the skeleton of the `Queue` module:

```elm
module Queue exposing (Queue, empty, enqueue, dequeue)

type Queue a

empty : Queue a

enqueue : a -> Queue a -> Queue a

dequeue : Queue a -> (Maybe a, Queue a)
```

We are starting with a very limited API. We have this opaque `Queue` type. The only way to create a queue is with `empty`. From there we can add elements with `enqueue` or remove elements with `dequeue`.

We are going to work through three different implementations of this library. We will start with the &ldquo;obvious&rdquo; implementation and work towards a good implementation.


## The Slow and Leaky Implementation

We are going to start with an implementation that is slow *and* leaks implementation details. The whole mistake comes in the definition of the `Queue` type:

```elm
module Queue exposing (Queue, empty, enqueue, dequeue)

type alias Queue a =
  List a

empty : Queue a
empty =
  []

enqueue : a -> Queue a -> Queue a
enqueue element queue =
  queue ++ [element]

dequeue : Queue a -> (Maybe a, Queue a)
dequeue queue =
  case queue of
    [] ->
      ( Nothing, empty )

    first :: rest ->
      ( Just first, rest )
```

Now this may *seem* fine, but it has a serious problem.

We decide that our core representation will be a [type alias](../types/type_aliases.md), so anytime you see the type `Queue Int` you can replace it by `List Int` and everything still works. In other words, using a type alias means you are public promising a particular data format. Users can use `List.reverse` on your queues, and they probably will. If you ever want to change the data format, you will break all of their code!

So our implementation is simple, but we are leaking our implementation!


## The Slow Implementation

In the previous section, we saw that when you create a [union type](../types/union_types.md), you can expose the type *without* its type constructors. That means no one can break into the internal representation on their own. We are going to use that same trick here. In our case, we create a `Queue` type with only one type constructor `Q`:

```elm
module Queue exposing (Queue, empty, enqueue, dequeue)

type Queue a =
  Q (List a)

empty : Queue a
empty =
  Q []

enqueue : a -> Queue a -> Queue a
enqueue element (Q queue) =
  Q (queue ++ [element])

dequeue : Queue a -> (Maybe a, Queue a)
dequeue (Q queue) =
  case queue of
    [] ->
      ( Nothing, empty )

    first :: rest ->
      ( Just first, Q rest )
```

This code is almost exactly the same as our first implementation except we are wrapping our list in this `Q` type constructor. Since we are not exposing `Q`, no one can create or destructure the `Queue` type from outside. This means the `empty`, `enqueue`, and `dequeue` functions really are the only way to work with a `Queue`!

Okay, so now we have a working implementation that does not leak implementation details. If anyone needs this module, they can start using it right now! If they decide they need additional functionality, you add it to the public contract.

> **Exercise 1:** Your users start running into more complicated scenarios, so they need additional functionality. Add the following functions for them:
>
> ```elm
length : Queue a -> Int
map : (a -> b) -> Queue a -> Queue b
```
>
> The `length` function just tells you how many elements are in the `Queue`. The `map` function lets you transform every value in the `Queue`, just like `List.map`.

> **Exercise 2:** Try to implement `enqueue` and `dequeue` using only `(::)` and `List.reverse`. You cannot use `(++)` or any other functions from the `List` module. Just `(::)` and `List.reverse`. As a hint, you should define `Queue` like this:
>
```elm
type Queue a =
  Q { front : List a, back : List a }
```
>
> Sometimes people refer to this as &ldquo;using two stacks to make a queue&rdquo;. Why would this implementation be faster than the one we created together?