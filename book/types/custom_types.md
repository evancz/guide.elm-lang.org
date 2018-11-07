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

thomas = Regular "Thomas" 44
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


## Modeling

Custom types become extremely powerful when you start modeling situations very precisely. For example, if you are waiting for some data to load, you might want to model it with a custom type like this:

```elm
type Profile
  = Failure
  | Loading
  | Success { name : String, description : String }
```

So you can start in the `Loading` state and then transition to `Failure` or `Success` depending on what happens. This makes it really simple to write a `view` function that always shows something reasonable when data is loading.

Now we know how to create custom types, the next section will show how to use them!


> **Note: Custom types are the most important feature in Elm.** They have a lot of depth, especially once you get in the habit of trying to model scenarios more precisely. I tried to share some of this depth in [Types as Sets](/appendix/types_as_sets.html) and [Types as Bits](/appendix/types_as_bits.html) in the appendix. I hope you find them helpful!