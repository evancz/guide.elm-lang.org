# HTTP

We are about to make an app that fetches a random GIF when the user asks for another image.

Now, I am going to assume you just read the randomness example. It (1) introduces a two step process for writing apps like this and (2) shows the simplest kind of commands possible. Here we will be using the same two step process to build up to fancier kinds of commands, so I very highly recommend going back one page. I swear you will reach your goals faster if you start with a solid foundation!

...

Okay, so you read it now right? Good. Let's get started on our random gif fetcher!


## Phase One - The Bare Minimum

As always, you start out by guessing at what your `Model` should be:

```elm
type alias Model =
  { topic : String
  , gifUrl : String
  }
```

I decided to track a `topic` so I know what kind of gifs to fetch. Maybe later we will want to let the user decide the topic too. I also tracked the `gifUrl` which is a URL that points at some random gif.

Then I would quickly sketch out the `view` function because it seems like the easiest next step.

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

Now the `update` function has the same overall shape as before, but the return type is a bit different. Instead of just giving back a `Model`, it produces both a `Model` and a command. The idea is: **we still want to step the model forward, but we also want to do some stuff.** In our case, we want to send an HTTP request when the user presses the "More" button.

For now, I just fill it in with [`Cmd.none`](TODO) which means "I have no commands, do nothing." We will need to fill this in with an HTTP request in phase two, but the goal now is just to get something on screen.

Finally, I would create an `init` value like this:

```elm
init : (Model, Cmd Msg)
init =
  (Model "funny cats" "waiting.gif", Cmd.none)
```

Here we specify both the initial model and some commands we'd like to run immediately when the app starts. This is exactly the kind of stuff that `update` is producing now too.

At this point, it is possible to wire it all up and take a look. You can click the "More" button, but nothing happens. Let's fix that!


## Phase Two - Adding the Cool Stuff

The obvious thing missing right now is the HTTP request. When the user clicks a button we want to command Elm to send a request to `giphy.com` and ask for a random gif. I think it is easiest to start this process by adding new kinds of messages:

```elm
type Msg
  = MorePlease
  | FetchSucceed String
  | FetchFail Http.Error
```

We still have `MorePlease` from before, but now we add `FetchSucceed` and `FetchFail` to handle the results of an HTTP request. In the case of `FetchSucceed` we get the new gif URL, and in the case of `FetchFail` we get some information about what went wrong in particular.

That is enough to start filling in `update`:

```elm
update : Msg -> Model -> (Model, Cmd Msg)
update action model =
  case action of
    MorePlease ->
      (model, getRandomGif model.topic)

    FetchSucceed newUrl ->
      (Model model.topic newUrl, Cmd.none)

    FetchFail _ ->
      (model, Cmd.none)
```

So I added branches for our new messages. In the case of `FetchSucceed` we update the `gifUrl` field to have the new URL. In the case of `FetchFail` we pretty much ignore it, giving back the same model and doing nothing.

I also changed the `MorePlease` branch a bit! Instead of giving back `Cmd.none`, it is calling this `getRandomGif` function with the current topic. This is more aspirational for now. I know I will be describing an HTTP command in a moment


```elm
init : String -> (Model, Cmd Msg)
init topic =
  (Model topic "waiting.gif", getRandomGif topic)


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


> **Exercises:** To get more comfortable with this code, try augmenting it with skills we learned in previous sections:
> 
>   - Show a message explaining why the image didn't change when you get a `FetchFail`.
>   - Allow the user to modify the `topic` with a text field.
>   - Allow the user to modify the `topic` with a drop down menu.


