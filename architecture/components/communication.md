# Communication

**Work in progress** - Full example coming in the next few weeks.

The basic trick is to communicate with additional data. If you want to tell a parent component about something, you can extend your `update` function to return additional data.

```elm
update : Msg -> Model -> ( Model, Cmd Msg, Whatever )
```

Now the parent must handle this extra information. It can be a `Maybe` or `List` or whatever. You can do anything.

All the methods of communication are just variations on adding arguments or returning more data.