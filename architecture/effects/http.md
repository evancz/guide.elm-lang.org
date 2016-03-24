# HTTP

We are about to make an app that fetches a random GIF when the user asks for another image.

When I write code like this, I usually break it into two phases. Phase one is about getting something on screen, just doing the bare minimum to have something to work from. Phase two is iteratively filling in details until I end up with the real thing.


## Phase One - The Bare Minimum

As always, you start out by guessing at what your `Model` should be:

```elm
type alias Model =
  { topic : String
  , gifUrl : String
  }
```

I decided to track a `topic` so I know what kind of gifs to fetch. Maybe later we will want to let the user decide the topic too. I also tracked the `gifUrl` which is a URL that points at some random gif.

At this point I would quickly sketch out the `view` function because it seems like the easiest next step.

```elm
view : Model -> Html Msg
view model =
  div []
    [ h2 [] [text model.topic]
    , img [src model.gifUrl] []
    , button [ onClick MorePlease ] [ text "More Please!" ]
    ]
```

So this is typical. Same stuff we have been doing with the user input examples of The Elm Architecture. We created a `<button>` that produces `MorePlease` messages, so I guess it is time to take a first pass at the `update` function as well.

```elm
type Msg = MorePlease

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    MorePlease ->
      (model, Cmd.none)
```

The `update` function has some new stuff though:

  1. The return type of `update` is not just a `Model`. It is a pair of `Model` and commands now. The idea is that when we step the model forward, we may also want to do some stuff. In our case, we want to send an HTTP request when the user presses the "More" button.

  2. The `MorePlease` branch is using this weird `(!)` operator. This 


## Phase Two - Adding the Cool Stuff

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


