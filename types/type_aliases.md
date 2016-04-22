# Type Aliases

The whole point of type aliases is to make your type annotations easier to read.

As you programs get more complicated, you find yourself working with larger and more complex data. For example, maybe you are making twitter-for-dogs and you need to represent a user. And maybe you want a function that checks to see if a user has a bio or not. You might write a function like this:

```elm
hasBio : { name : String, bio : String, pic : String } -> Bool
hasBio user =
  String.length user.bio > 0
```

That type annotation is kind of a mess, and users do not even have that many details! Imagine if there were ten fields. Or if you had a function that took users as an argument and gave users as the result.

In cases like this, you should create a *type alias* for your data:

```elm
type alias User =
  { name : String
  , bio : String
  , pic : String
  }
```

This is saying, wherever you see `User`, replace it by all this other stuff. So now we can rewrite our `hasBio` function in a much nicer way:

```elm
hasBio : User -> Bool
hasBio user =
  String.length user.bio > 0
```

Looks way better! It is important to emphasize that *these two definitions are exactly the same*. We just made an alias so we can say the same thing in fewer key strokes.

So if we write a function to add a bio, it would be like this:

```elm
addBio : String -> User -> User
addBio bio user =
  { user | bio = bio }
```

Imagine what that type annotation would look like if we did not have type aliases. Bad!

It is not just about cosmetics though. When writing Elm programs, it is often best to *start* with the type alias before writing a bunch of functions. I find it helps direct my progress in a way that ends up being more efficient overall. Suddenly you know exactly what kind of data you are working with. If you need to add stuff to it, the compiler will tell you about any existing code that is affected by it. I would recommend it!

> **Note:** When you create a type alias specifically for a record, it also generates a *record constructor*. So our `User` type alias will also generate this function:
> 
> ```elm
User : String -> String -> String -> User
```
> 
> The arguments are in the order they appear in the type alias declaration. You may want to use this sometimes.
