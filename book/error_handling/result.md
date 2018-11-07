# Result

The `Maybe` type can help with simple functions that may fail, but it does not tell you _why_ it failed. Imagine if a compiler just said `Nothing` if anything was wrong with your program. Good luck figuring out what went wrong!

This is where the [`Result`][Result] type becomes helpful. It is defined like this:

```elm
type Result error value
  = Ok value
  | Err error
```

The point of this type is to give additional information when things go wrong. It is really helpful for error reporting and error recovery!

[Result]: https://package.elm-lang.org/packages/elm-lang/core/latest/Result#Result


## Error Reporting

Perhaps we have a website where people input their age. We could check that the age is reasonable with a function like this:

```elm
isReasonableAge : String -> Result String Int
isReasonableAge input =
  case String.toInt input of
    Nothing ->
      Err "That is not a number!"

    Just age ->
      if age < 0 then
        Err "Please try again after you are born."

      else if age > 135 then
        Err "Are you some kind of turtle?"

      else
        Ok age

-- isReasonableAge "abc" == Err ...
-- isReasonableAge "-13" == Err ...
-- isReasonableAge "24"  == Ok 24
-- isReasonableAge "150" == Err ...
```

Not only can we check the age, but we can also show people error messages depending on the particulars of their input. This kind of feedback is much better than `Nothing`!


## Error Recovery

The `Result` type can also help you recover from errors. One place you see this is when making HTTP requests. Say we want to show the full text of _Anna Karenina_ by Leo Tolstoy. Our HTTP request results in a `Result Error String` to capture the fact that the request may succeed with the full text, or it may fail in a bunch of different ways:

```elm
type Error
  = BadUrl String
  | Timeout
  | NetworkError
  | BadStatus Int
  | BadBody String

-- Ok "All happy ..." : Result Error String
-- Err Timeout        : Result Error String
-- Err NetworkError   : Result Error String
```

From there we can show nicer error messages as we discussed before, but we can also try to recover from the failure! If we see a `Timeout` it may work to wait a little while and try again. Whereas if we see a `BadStatus 404` then there is no point in trying again.

The next chapter shows how to actually make HTTP requests, so we will run into the `Result` and `Error` types again very soon!
