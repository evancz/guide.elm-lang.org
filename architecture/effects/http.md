# HTTP

We are about to make an app that fetches a random GIF when the user asks for another image.

The last section showed how we can use commands to get random values. Here we use commands to make HTTP requests. It is exactly the same mechanism, but the data we are putting in the command is a bit fancier.

The full code lives [here](TODO). I recommend cloning that repo and playing with it yourself!

As always, you start out by guessing at what your `Model` should be:

```elm
type alias Model =
  { topic : String
  , gifUrl : String
  }
```

I decided to track a `topic` so I know what kind of gifs to fetch. Maybe later we will want to let the user decide the topic too. I also tracked the `gifUrl` which is a URL that points at some random gif.

> **Note:** At this point I would start experimenting to proceed. Often I'll just start with the parts I definitely understand, so I'd set up my `update` and `view` to show a waiting gif and a button that does nothing. You click the button and nothing changes. From there I'd figure out HTTP and JSON stuff. From there I'd figure out what that means for the `update` and `init` functions. Refactor. Add more stuff. Etc. My favorite thing about The Elm Architecture is that I can muddle along without a clear idea of what I'm doing and somehow end up with decent code at the end. Hopefully this perspective is helpful for when you write your own code, but for the sake of clarity, I will present things as if I knew what to do the first time around!

So now that we have a model, we should figure out what kind of messages we will be getting. We know the user will click a button. We also know we will send an HTTP request that may succeed or fail. So I'd go with this:

```elm
type Msg
  = RequestMore
  | FetchSucceed String
  | FetchFail Http.Error
```

In the case of `FetchSucceed` we get the new gif URL, and in the case of `FetchFail` we get some information about what went wrong in particular.

That is enough to start filling in `update`:

```elm
update : Msg -> Model -> (Model, Cmd Msg)
update action model =
  case action of
    RequestMore ->
      model ! [ getRandomGif model.topic ]

    NewGif url ->
      { model | gifUrl = url } ! []

    Fail _ ->
      model ! []
```



```elm
init : String -> (Model, Cmd Msg)
init topic =
  Model topic "assets/waiting.gif"
    ! [ getRandomGif topic ]



-- VIEW

view : Model -> Html Msg
view model =
  div []
    [ h2 [] [text model.topic]
    , div [imgStyle model.gifUrl] []
    , button [ onClick RequestMore ] [ text "More Please!" ]
    ]


imgStyle : String -> Attribute msg
imgStyle url =
  style [ ("background-image", "url('" ++ url ++ "')")  ]


-- COMMANDS

getRandomGif : String -> Cmd Msg
getRandomGif topic =
  Task.perform Fail NewGif
    (Http.get decodeUrl (randomUrl topic))


randomUrl : String -> String
randomUrl topic =
  Http.url "http://api.giphy.com/v1/gifs/random"
    [ ("api_key", "dc6zaTOxFJmzC")
    , ("tag", topic)
    ]


decodeUrl : Json.Decoder String
decodeUrl =
  Json.at ["data", "image_url"] Json.string
```

> **Notes:** A bunch of concepts are needed here, but we need to stay focused on commands and subscriptions for now.
> 
>   - If you are interested in learning more about the HTTP library, I recommend you read through the entire section on Error Handling, working from `Maybe` to `Result` to `Task`. It can be tricky if you dive into tasks directly, so do not be afraid of building a conceptual foundation first! This kind of investment pays off in Elm.
>   - If you want to learn more about JSON decoders, go read that section. It is way easier with guidance!

```elm
subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none
```

> **Exercises:** To get more comfortable with this code, try augmenting it with skills we learned in previous sections:
> 
>   - Show a message explaining why the image didn't change when you get a `FetchFail`.
>   - Allow the user to modify the `topic` with a text field.
>   - Allow the user to modify the `topic` with a drop down menu.


