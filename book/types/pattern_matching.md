# Pattern Matching

On the previous page, we learned how to create [custom types](/types/custom_types.html) with the `type` keyword. Our primary example was a `User` in a chat room:

```elm
type User
  = Regular String Int
  | Visitor String
```

Regulars have a name and age, whereas visitors only have a name. So we have our custom type, but how do we actually use it?


## `case`

Say we want a `toName` function that decides on a name to show for each `User`. We need to use a `case` expression:

```elm
toName : User -> String
toName user =
  case user of
    Regular name age ->
      name

    Visitor name ->
      name

-- toName (Regular "Thomas" 44) == "Thomas"
-- toName (Visitor "kate95")    == "kate95"
```

The `case` expression allows us to branch based on which variant we happen to see, so whether we see Thomas or Kate, we always know how to show their name.

And if we try invalid arguments like `toName (Visitar "kate95")` or `toName Anonymous`, the compiler tells us about it immediately. This means many simple mistakes can be fixed in seconds, rather than making it to users and costing a lot more time overall.


## Wild Cards

The `toName` function we just defined works great, but notice that the `age` is not used in the implementation? When some of the associated data is unused, it is common to use a “wild card” instead of giving it a name:

```elm
toName : User -> String
toName user =
  case user of
    Regular name _ ->
      name

    Visitor name ->
      name
```

The `_` acknowledges the data there, but also saying explicitly that nobody is using it.
