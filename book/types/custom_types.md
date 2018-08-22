> **Note:** Custom types used to be referred to as “union types” in Elm. Names from other communities include [tagged unions](https://en.wikipedia.org/wiki/Tagged_union) and [ADTs](https://en.wikipedia.org/wiki/Algebraic_data_type).

# Custom Types

So far we have seen a bunch of types like `Bool`, `Int`, and `String`. But how do we define our own?

Say we are making a chat room. Everyone needs a name, but maybe some users do not have a permanent account. They just give a name each time they show up.

We can describe this situation by defining a `UserStatus` type, listing all the possible variations:

```elm
type UserStatus = Regular | Visitor
```

The `UserStatus` type has two **variants**. Someone can be a `Regular` or a `Visitor`. So we could represent a user as a record like this:

```elm
type UserStatus
  = Regular
  | Visitor

type alias User =
  { status : UserStatus
  , name : String
  }

thomas = { status = Regular, name = "Thomas" }
kate95 = { status = Visitor, name = "kate95" }
```

So now we can track if someone is a `Regular` with an account or a `Visitor` who is just passing through. It is not too tough, but we can make it simpler!

Rather than creating a custom type and a type alias, we can represent all this with just a single custom type. The `Regular` and `Visitor` variants each have an associated data. In our case, the associated data is a `String` value:

```elm
type User
  = Regular String
  | Visitor String

thomas = Regular "Thomas"
kate95 = Visitor "kate95"
```

The data is attached directly to the variant, so there is no need for the record anymore.

Another benefit of this approach is that each variant can have different associated data. Say that `Regular` users gave their age when they signed up. There is no nice way to capture that with records, but when you define your own custom type it is no problem. We add some associated data to the `Regular` variant:

```elm
type User
  = Regular String Int
  | Visitor String

thomas = Regular "Thomas" 33
kate95 = Visitor "kate95"
```

The different variants of a type can diverge quite dramatically. For example, maybe we add location for `Regular` users so we can suggest regional chat rooms. Add more associated data! Or maybe we want to have anonymous users. Add a third variant called `Anonymous`. Maybe we end up with:

```elm
type User
  = Regular String Int Location
  | Visitor String
  | Anonymous
```

No problem! Let’s see some other examples now.


## Messages

In the architecture section, we saw a couple of examples of defining a `Msg` type. This sort of type is extremely common in Elm. In our chat room, we might define a `Msg` type like this:

```elm
type Msg
  = PressedEnter
  | ChangedDraft String
  | ReceivedMessage { user : User, message : String }
  | ClickedExit
```

We have four variants. Some variants have no associated data, others have a bunch. Notice that `ReceivedMessage` actually has a record as associated data. That is totally fine. Any type can be associated data! This allows you to describe interactions in your application very precisely.

So you will be defining your own custom types, but you will also run into types defined by others.


## Common Examples

There are quite a few types defined in `elm/core` that you are sure to run into. For example, the [`Bool`][Bool] type:

```elm
type Bool = True | False
```

It has two variants. `True` and `False`. Neither has associated data.

Another common one is the [`Maybe`][Maybe] type:

```elm
type Maybe a = Just a | Nothing
```

This is useful for functions that may not succeed. The function [`String.toInt`][toInt] has type `String -> Maybe Int`, making it a great example:

- `String.toInt "abc" == Nothing`
- `String.toInt "2x4" == Nothing`
- `String.toInt "403" == Just 403`
- `String.toInt "100" == Just 100`

Not all `String` values can become `Int` values in a reasonable way. By using `Maybe` we are able to capture that explicitly.

[Bool]: https://package.elm-lang.org/packages/elm-lang/core/latest/Basics#Bool
[Maybe]: https://package.elm-lang.org/packages/elm-lang/core/latest/Maybe#Maybe
[toInt]: https://package.elm-lang.org/packages/elm-lang/core/latest/String#toInt


> **Note: Custom types are the most important feature in Elm.**
>
> They may seem sort of boring on the surface, but do not be fooled! I think of them like kitchen knives. They may seem like any other boring utensil, but they have surprising depth. From [design](https://youtu.be/LO35cdWL1MQ) to [maintenance](https://youtu.be/SIw5ChGOADE) to [use](https://youtu.be/RjWkO9A-Ckk), there are so many techniques that are both foundational and totally invisible.
>
> For example, if no one tells you that knives must be sharpened with a whetstone periodically, your knives become dull and annoying. And then cooking becomes dull and annoying. The more you practice, the worse it gets. But once you know about whetstones, chopping becomes easier and more fun. Cooking becomes easier and more fun. The more you practice, the better it gets. It is a cruel pair of feedback loops, seperated only by technique. And until you know to look for it, you cannot see it!
>
> Point is, ~~knives~~ custom types are extremely important. I tried to share some of the hidden knowledge in [Types as Sets](/appendix/types_as_sets.html) and [Types as Bits](/appendix/types_as_bits.html) in the appendix. I hope you find them helpful!