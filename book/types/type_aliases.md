# Type Aliases

Elm allows you to create a **type alias**. An alias is just a shorter name for some other type. It looks like this:

```elm
type alias User =
  { name : String
  , bio : String
  }
```

So rather than having to type out this record type all the time, we can just say `User` instead. For example, you can shorten type annotations like this:

```elm
hasDecentBio : User -> Bool
hasDecentBio user =
  String.length user.bio > 80
```

That would be `{ name : String, bio : String } -> Bool` without the type alias. **The main point of type aliases is to help us write shorter and clearer type annotations.** This becomes more important as your application grows. Say we have a `updateBio` function:

```elm
updateBio : String -> User -> User
updateBio bio user =
  { user | bio = bio }
```

First, think about the type signature without a type alias! Now, imagine that as our application grows we add more fields to represent a user. We could add 10 or 100 fields to the `User` type alias, and we do not need any changes to our `updateBio` function. Nice!


## Record Constructors

When you create a type alias specifically for a record, it also generates a **record constructor**. So if we define a `User` type alias in `elm repl` we could start building records like this:

```elm
> type alias User = { name : String, bio : String }

> User "Tom" "Friendly Carpenter"
{ name = "Tom", bio = "Friendly Carpenter" }
```

The arguments are in the order they appear in the type alias declaration. This can be pretty handy.

And again, this is only for records. Making type aliases for non-record types will not result in a constructor.