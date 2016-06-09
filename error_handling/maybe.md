# Maybe

It is best to just start with the definition of `Maybe`. It is a union type just like in all the examples [here](../types/union_types.md). It is defined like this:

```elm
> type Maybe a = Nothing | Just a

> Nothing
Nothing : Maybe a

> Just
<function> : a -> Maybe a

> Just "hello"
Just "hello" : Maybe String

> Just 1.618
Just 1.618 : Maybe Float
```

If you want to have a `Maybe` value, you have to use the `Nothing` or `Just` constructors to create it. This means that to deal with the data, you have to use a `case` expression. This means the compiler can ensure that you have definitely covered both possibilities!

There are two major cases where you will see `Maybe` values.


## Optional Fields

Say we are running a social networking website. Connecting people, friendship, etc. You know the spiel. The Onion outlined our real goals best: [mine as much data as possible for the CIA](http://www.theonion.com/video/cias-facebook-program-dramatically-cut-agencys-cos-19753). And if we want *all* the data, we need to ease people into it. Let them add it later. Add features that encourage them to share more and more information over time.

So let's start with a simple model of a user. They must have a name, but we are going to make the age optional.

```elm
type alias User =
  { name : String
  , age : Maybe Int
  }
```

Now say Sue logs in and decides not to provide her birthday:

```elm
sue : User
sue =
  { name = "Sue", age = Nothing }
```

Now her friends cannot wish her a happy birthday. Sad! Later Tom creates a profile and *does* give his age:

```elm
tom : User
tom =
  { name = "Tom", age = Just 24 }
```

Great, that will be nice on his birthday. But more importantly, Tom is part of a valuable demographic! The advertisers will be pleased.

Alright, so now that we have some users, how can we market alcohol to them without breaking any laws? People would probably be mad if we market to people under 21, so let's check for that:

```elm
canBuyAlcohol : User -> Bool
canBuyAlcohol user =
  case user.age of
    Nothing ->
      False
      
    Just age ->
      age >= 21
```

Now the cool thing is that we are forced to use a `case` to pattern match on the users age. It is actually impossible to write code where you forget that users may not have an age. Elm can make sure of it. Now we can advertise alcohol confident that we are not influencing minors directly! Only their older peers.


## Partial Functions

Sometimes you want a function that gives an answer sometimes, but just does not in other cases. 

Let's say Mountain Dew wants to do some ad buys for people ages 13 to 18. Honestly, it is better to start kids on Mountain Dew younger than that, but it is illegal for kids under 13 to be on our site.

So let's say we want to write a function that will tell us a user's age, but only if they are between 13 and 18:

```elm
getTeenAge : User -> Maybe Int
getTeenAge user =
  case user.age of
    Nothing ->
      Nothing
      
    Just age ->
      if 13 <= age && age <= 18 then
        Just age
        
      else
        Nothing
```

Again, we are reminded that users may not have an age, but if they do, we only want to return it if it is between 13 and 18. Now Elm can guarantee that anyone who calls `getTeenAge` will have to handle the possibility that the age is out of range.

This gets pretty cool when you start combining it with library functions like [`List.filterMap`](http://package.elm-lang.org/packages/elm-lang/core/latest/List#filterMap) that help you process more data. For example, maybe we want to figure out the distribution of ages between 13 and 18. We could do it like this:

```elm
> alice = User "Alice" (Just 14)
... : User

> bob = User "Bob" (Just 16)
... : User

> users = [ sue, tom, alice, bob ]
... : List User

> List.filterMap getTeenAge users
[14,16] : List Int
```

We end up with only the ages we care about. Now we can feed our `List Int` into a function that figures out the distributions of each number.