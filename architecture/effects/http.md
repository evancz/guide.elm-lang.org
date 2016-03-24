# HTTP

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
  | FetchFail
```

We still have `MorePlease` from before, but for the HTTP results, we add `FetchSucceed` that holds the new gif URL and `FetchFail` that indicates there was some HTTP issue (server is down, bad URL, etc.)

That is enough to start filling in `update`:

```elm
update : Msg -> Model -> (Model, Cmd Msg)
update action model =
  case action of
    MorePlease ->
      (model, getRandomGif model.topic)

    FetchSucceed newUrl ->
      (Model model.topic newUrl, Cmd.none)

    FetchFail ->
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
    Http.simpleGet FetchFail FetchSuccess decodeGifUrl url

decodeGifUrl : Json.Decoder String
decodeGifUrl =
  Json.at ["data", "image_url"] Json.string
```

Okay, so the `getRandomGif` function is not exceptionally crazy. We first define the `url` we need to hit to get random gifs.

Next we have [this `Http.simpleGet` function](TODO) which is going to GET some JSON from the `url` we give it. The other arguments all clarify what to do with the result of this GET. The **first** argument is a message for when the GET fails. If the server is down or the URL is a 404, we want the `FetchFail` message to be fed into our `update` function. The **second** argument is a way to tag the result of a successful GET. So when we get some URL back like `http://example.com/json`, we convert it into  `FetchSuccess "http://example.com/json"` so that it can be fed into our `update` function. The **third** argument is a JSON decoder. This value describes how to turn a JSON string into an Elm value. In our case, we are saying "try to get the value at `json.data.image_url` and it should be a strung. (If you want a deeper understanding of JSON decoders, check out the full section on it later in this guide! For now you just need to know that it converts JSON into Elm values.)

Ultimately, `Http.simpleGet` is not doing anything too crazy. It GETs JSON from a URL, and turns the result into a message for our `update` function.

So now when you click the "More" button, it actually goes and fetches a random gif!

> **Exercises:** To get more comfortable with this code, try augmenting it with skills we learned in previous sections:
> 
>   - Show a message explaining why the image didn't change when you get a `FetchFail`.
>   - Allow the user to modify the `topic` with a text field.
>   - Allow the user to modify the `topic` with a drop down menu.


