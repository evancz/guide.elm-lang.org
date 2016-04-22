# Maybe

It is best to just start with the definition of `Maybe`. It is a union type just like in all the examples [here](types/union_types.md). It is defined like this:

```elm
> type Maybe a = Nothing | Just a

> Nothing
Nothing : Maybe a

> Just
<function> : a -> Maybe a

> Just "hello"
Just "hello" : Maybe String

> Just 1.618
Just 1.628 : Maybe Float
```

If you want to have a `Maybe` value, you have to use the `Nothing` or `Just` constructors to create it. This means that to deal with the data, you have to use a `case` expression. This means the compiler can ensure that you have definitely covered both possibilities!

There are two major cases where you will see `Maybe` values.


## Optional Fields

Say you are running a social networking website. Connecting people. Friendship. Yada yada. The real goal is to mine as much data as possible and [give it to the CIA](http://www.theonion.com/video/cias-facebook-program-dramatically-cut-agencys-cos-19753). And if we want *all* the data, we need to ease people into it. Let them add it later. Add features that encourage them to share more and more information over time.

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

Great, Tom is part of a valuable demographic! Maybe he has a nice job, no kids, and has not learned to budget well yet. The advertisers will be pleased.

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

Now the cool thing is that we are forced to use a `case` to pattern match on the users age. It is actually impossible to write code where you forget that users may not have an age. Elm can make sure of it. Now we can advertise alcohol confident that we are not influencing minors directly! Only older their peers.


## Partial Functions

Sometimes you want a function that gives an answer sometimes, but just does not in other cases. 

Let's say Mountain Dew wants to do some add buys for people ages 13 to 18. (It is illegal for kids under 13 to be on our site.) 

```elm
getTeenAge : User -> Maybe Int
```

...