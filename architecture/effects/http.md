# HTTP

**[See Online](http://elm-lang.org/examples/http) / [Run Locally](https://github.com/evancz/elm-architecture-tutorial/)**

We are about to make an app that fetches a random GIF when the user asks for another image.

Now, I am going to assume you just read the randomness example. It (1) introduces a two step process for writing apps like this and (2) shows the simplest kind of commands possible. Here we will be using the same two step process to build up to fancier kinds of commands, so I very highly recommend going back one page. I swear you will reach your goals faster if you start with a solid foundation!

...

Okay, so you read it now right? Good. Let's get started on our random gif fetcher!


## Phase One - The Bare Minimum

At this point in this guide, you should be pretty comfortable smacking down the basic skeleton of an Elm app. Guess at the model, fill in some messages, etc. etc.

```elm
-- MODEL

type alias Model =
  { topic : String
  , gifUrl : String
  }

init : (Model, Cmd Msg)
init =
  (Model "cats" "waiting.gif", Cmd.none)


-- UPDATE

type Msg = MorePlease

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    MorePlease ->
      (model, Cmd.none)


-- VIEW

view : Model -> Html Msg
view model =
  div []
    [ h2 [] [text model.topic]
    , img [src model.gifUrl] []
    , button [ onClick MorePlease ] [ text "More Please!" ]
    ]
```

For the model, I decided to track a `topic` so I know what kind of gifs to fetch. I do not want to hard code it to `"cats"`, and maybe later we will want to let the user decide the topic too. I also tracked the `gifUrl` which is a URL that points at some random gif.

Like in the randomness example, I just made dummy `init` and `update` functions. None of them actually produce any commands for now. The point is just to get something on screen!


## Phase Two - Adding the Cool Stuff

Alright, the obvious thing missing right now is the HTTP request. I think it is easiest to start this process by adding new kinds of messages. Now remember, **when you give a command, you have to wait for it to happen.** So when we command Elm to do an HTTP request, it is eventually going to tell you "hey, here is what you wanted" or it is going to say "oops, something went wrong with the HTTP request". We need this to be reflected in our messages:

```elm
type Msg
  = MorePlease
  | FetchSucceed String
  | FetchFail Http.Error
```

We still have `MorePlease` from before, but for the HTTP results, we add `FetchSucceed` that holds the new gif URL and `FetchFail` that indicates there was some HTTP issue (server is down, bad URL, etc.)

That is enough to start filling in `update`:

```elm
update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    MorePlease ->
      (model, getRandomGif model.topic)

    FetchSucceed newUrl ->
      (Model model.topic newUrl, Cmd.none)

    FetchFail _ ->
      (model, Cmd.none)
```

So I added branches for our new messages. In the case of `FetchSucceed` we update the `gifUrl` field to have the new URL. In the case of `FetchFail` we pretty much ignore it, giving back the same model and doing nothing.

I also changed the `MorePlease` branch a bit. We need an HTTP command, so I called the `getRandomGif` function. The trick is that I made that function up. It does not exist yet. That is the next step!

Defining `getRandomGif` might look something like this:

```elm
getRandomGif : String -> Cmd Msg
getRandomGif topic =
  let
    url =
      "http://api.giphy.com/v1/gifs/random?api_key=dc6zaTOxFJmzC&tag=" ++ topic
  in
    Task.perform FetchFail FetchSucceed (Http.get decodeGifUrl url)

decodeGifUrl : Json.Decoder String
decodeGifUrl =
  Json.at ["data", "image_url"] Json.string
```

Okay, so the `getRandomGif` function is not exceptionally crazy. We first define the `url` we need to hit to get random gifs. Next we have [this `Http.get` function](http://package.elm-lang.org/packages/evancz/elm-http/3.0.1/Http#get) which is going to GET some JSON from the `url` we give it. The interesting part there is The `decodeGifUrl` argument which describes how to turn JSON into Elm values. In our case, we are saying &ldquo;try to get the value at `json.data.image_url` and it should be a string.&rdquo;

> **Note:** See [this](http://guide.elm-lang.org/interop/json.html) for more information on JSON decoders. It will clarify how it works, but for now, you really just need a high-level understanding. It turns JSON into Elm.

The `Task.perform` part is clarifying what to do with the result of this GET:

  1. The first argument `FetchFail` is for when the GET fails. If the server is down or the URL is a 404, we tag the resulting error with `FetchFail` and feed it into our `update` function.
  2. The second argument `FetchSuccess` is for when the GET succeeds. When we get some URL back like `http://example.com/json`, we convert it into  `FetchSuccess "http://example.com/json"` so that it can be fed into our `update` function.

We will get into the details of how this all works later in this guide, but for now, if you just follow the pattern here, you will be fine using HTTP.

And now when you click the "More" button, it actually goes and fetches a random gif!

> **Exercises:** To get more comfortable with this code, try augmenting it with skills we learned in previous sections:
> 
>   - Show a message explaining why the image didn't change when you get a `FetchFail`.
>   - Allow the user to modify the `topic` with a text field.
>   - Allow the user to modify the `topic` with a drop down menu.


