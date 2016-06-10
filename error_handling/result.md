# Result

A `Result` is useful when you have logic that may "fail". For example, parsing a `String` into an `Int` may fail. What if the string is filled with the letter B? In cases like this, we want a function with this type:

```elm
String.toInt : String -> Result String Int
```

This means that `String.toInt` will take in a string value and start processing the string. If it cannot be turned into an integer, we provide a `String` error message. If it can be turned into an integer, we return that `Int`. So the `Result String Int` type is saying, "my errors are strings and my successes are integers."

To make this as concrete as possible, let's see the actual definition of `Result`. It is actually pretty similar to the `Maybe` type, but it has *two* type variables:

```elm
type Result error value
  = Err error
  | Ok value
```

You have two constructors: `Err` to tag errors and `Ok` to tag successes. Let's see what happens when we actually use `String.toInt` in the REPL:

```elm
> import String

> String.toInt "128"
Ok 128 : Result String Int

> String.toInt "64"
Ok 64 : Result String Int

> String.toInt "BBBB"
Err "could not convert string 'BBBB' to an Int" : Result String Int
```

So instead of throwing an exception like in most languages, we return data that indicates whether things have gone well or not. Let's imagine someone is typing their age into a text field and we want to show a validation message:

```elm
view : String -> Html msg
view userInputAge =
  case String.toInt userInputAge of
    Err msg ->
      span [class "error"] [text msg]
      
    Ok age ->
      if age < 0 then
        span [class "error"] [text "I bet you are older than that!"]
        
      else if age > 140 then
        span [class "error"] [text "Seems unlikely..."]
        
      else
        text "OK!"
```

Again, we have to use `case` so we are guaranteed to handle the special case where the number is bad.
