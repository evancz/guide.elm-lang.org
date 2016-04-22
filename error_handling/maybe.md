# Maybe



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
