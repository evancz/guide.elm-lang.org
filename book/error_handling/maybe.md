# Maybe

As you work more with Elm, you will start seeing the [`Maybe`][Maybe] type quite frequently. It is defined like this:

```elm
type Maybe a
  = Just a
  | Nothing

-- Just 3.14 : Maybe Float
-- Just "hi" : Maybe String
-- Just True : Maybe Bool
-- Nothing   : Maybe a
```

This is a type with two variants. You either have `Nothing` or you have `Just` a value. The type variable makes it possible to have a `Maybe Float` and `Maybe String` depending on the particular value.

This can be handy in two main scenarios: partial functions and optional fields.

[Maybe]: https://package.elm-lang.org/packages/elm-lang/core/latest/Maybe#Maybe


## Partial Functions

Sometimes you want a function that gives an answer for some inputs, but not others. Many people run into this with [`String.toFloat`][toFloat] when trying to convert user input into numbers. Open up `elm repl` to see it in action:

```elm
> String.toFloat
<function> : String -> Maybe Float

> String.toFloat "3.1415"
Just 3.1415 : Maybe Float

> String.toFloat "abc"
Nothing : Maybe Float
```

Not all strings make sense as numbers, so this function models that explicitly. Can a string be turned into a float? Maybe! From there we can pattern match on the resulting data and continue as appropriate.

> **Exercise:** I wrote a little program [here](https://ellie-app.com/3P9hcDhdsc5a1) that converts from Celsius to Fahrenheit. Try refactoring the `view` code in different ways. Can you put a red border around invalid input? Can you add more conversions? Fahrenheit to Celsius? Inches to Meters?

[toFloat]: https://package.elm-lang.org/packages/elm-lang/core/latest/String#toFloat


## Optional Fields

Another place you commonly see `Maybe` values is in records with optional fields.

For example, say we are running a social networking website. Connecting people, friendship, etc. You know the spiel. The Onion outlined our real goals best back in 2011: [mine as much data as possible for the CIA](https://www.theonion.com/cias-facebook-program-dramatically-cut-agencys-costs-1819594988). And if we want *all* the data, we need to ease people into it. Let them add it later. Add features that encourage them to share more and more information over time.

So let's start with a simple model of a user. They must have a name, but we are going to make the age optional.

```elm
type alias User =
  { name : String
  , age : Maybe Int
  }
```

Now say Sue creates an account, but decides not to provide her birthday:

```elm
sue : User
sue =
  { name = "Sue", age = Nothing }
```

Sue’s friends cannot wish her a happy birthday though. I wonder if they _really_ care about her... Later Tom creates a profile and *does* give his age:

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

Notice that the `Maybe` type forces us to pattern match on the users age. It is actually impossible to write code where you forget that users may not have an age. Elm makes sure of it! Now we can advertise alcohol confident that we are not influencing minors directly! Only their older peers.


## Avoiding Overuse

This `Maybe` type is quite useful, but there are limits. Beginners are particularly prone to getting excited about `Maybe` and using it everywhere, even though a custom type would be more appropriate.

For example, say we have an exercise app where we compete against our friends. You start with a list of your friend’s names, but you can load more fitness information about them later. You might be tempted to model it like this:

```elm
type alias Friend =
  { name : String
  , age : Maybe Int
  , height : Maybe Float
  , weight : Maybe Float
  }
```

All the information is there, but you are not really modeling the way your particular application works. It would be much more precise to model it like this instead:

```elm
type Friend
  = Less String
  | More String Info

type alias Info =
  { age : Int
  , height : Float
  , weight : Float
  }
```

This new model is capturing much more about your application. There are only two real situations. Either you have just the name, or you have the name and a bunch of information. In your view code, you just think about whether you are showing a `Less` or `More` view of the friend. You do not have to answer questions like &ldquo;what if I have an `age` but not a `weight`?&rdquo; That is not possible with our more precise type!

Point is, if you find yourself using `Maybe` everywhere, it is worth examining your `type` and `type alias` definitions to see if you can find a more precise representation. This often leads to a lot of nice refactors in your update and view code!


> ## Aside: Connection to `null` references
>
> The inventor of `null` references, Tony Hoare, described them like this:
>
> > I call it my billion-dollar mistake. It was the invention of the null reference in 1965. At that time, I was designing the first comprehensive type system for references in an object oriented language (ALGOL W). My goal was to ensure that all use of references should be absolutely safe, with checking performed automatically by the compiler. But I couldn't resist the temptation to put in a null reference, simply because it was so easy to implement. This has led to innumerable errors, vulnerabilities, and system crashes, which have probably caused a billion dollars of pain and damage in the last forty years.
>
> That design makes failure **implicit**. Any time you think you have a `String` you just might have a `null` instead. Should you check? Did the person giving you the value check? Maybe it will be fine? Maybe it will crash your server? I guess we will find out later!
>
> Elm avoids these problems by not having `null` references at all. We instead use custom types like `Maybe` to make failure **explicit**. This way there are never any surprises. A `String` is always a `String`, and when you see a `Maybe String`, the compiler will ensure that both variants are accounted for. This way you get the same flexibility, but without the surprise crashes.
