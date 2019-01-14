# Error Handling

One of the guarantees of Elm is that you will not see runtime errors in practice. This is partly because **Elm treats errors as data**. Rather than crashing, we model the possibility of failure explicitly with custom types. For example, say you want to turn user input into an age. You might create a custom type like this:

```elm
type MaybeAge
  = Age Int
  | InvalidInput

toAge : String -> MaybeAge
toAge userInput =
  ...

-- toAge "24" == Age 24
-- toAge "99" == Age 99
-- toAge "ZZ" == InvalidInput
```

Instead of crashing on bad input, we say explicitly that the result may be an `Age 24` or an `InvalidInput`. No matter what input we get, we always produce one of these two variants. From there, we use pattern matching which will ensure that both possibilities are accounted for. No crashing!

This kind of thing comes up all the time! For example, maybe you want to turn a bunch of user input into a `Post` to share with others. But what happens if they forget to add a title? Or there is no content in the post? We could model all these problems explicitly:

```
type MaybePost
  = Post { title : String, content : String }
  | NoTitle
  | NoContent

toPost : String -> String -> MaybePost
toPost title content =
  ...

-- toPost "hi" "sup?" == Post { title = "hi", content = "sup?" }
-- toPost ""   ""     == NoTitle
-- toPost "hi" ""     == NoContent
```

Instead of just saying that the input is invalid, we are describing each of the ways things might have gone wrong. If we have a `viewPreview : MaybePost -> Html msg` function to preview valid posts, now we can give more specific error messages in the preview area when something goes wrong!

These kinds of situations are extremely common. It is often valuable to create a custom type for your exact situation, but in some of the simpler cases, you can use an off-the-shelf type instead. So the rest of this chapter explores the `Maybe` and `Result` types, showing how they can help you treat errors as data!
