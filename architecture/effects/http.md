# HTTP

---
#### [Clone the code](https://github.com/evancz/elm-architecture-tutorial/) or follow along in the [online editor](http://elm-lang.org/examples/http).
---

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
  | NewGif (Result Http.Error String)
```

We add a case for `NewGif` that holds a `Result`. You can read more about results [here](/error_handling/result.md), but the key idea is that it captures the two possible outcomes of an HTTP request. It either (1) succeeded with the URL of a random gif or (2) failed with some HTTP error (server is down, bad URL, etc.)

That is enough to start filling in `update`:

```elm
update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    MorePlease ->
      (model, getRandomGif model.topic)

    NewGif (Ok newUrl) ->
      ( { model | gifUrl = newUrl }, Cmd.none)

    NewGif (Err _) ->
      (model, Cmd.none)
```

So I added branches for our new messages. When `NewGif` holds a success, we update the `gifUrl` field to have the new URL. When `NewGif` holds an error, we ignore it, giving back the same model and doing nothing.

I also changed the `MorePlease` branch a bit. We need an HTTP command, so I called the `getRandomGif` function. The trick is that I made that function up. It does not exist yet. That is the next step!

Defining `getRandomGif` might look something like this:

```elm
getRandomGif : String -> Cmd Msg
getRandomGif topic =
  let
    url =
      "https://api.giphy.com/v1/gifs/random?api_key=dc6zaTOxFJmzC&tag=" ++ topic

    request =
      Http.get url decodeGifUrl
  in
    Http.send NewGif request

decodeGifUrl : Decode.Decoder String
decodeGifUrl =
  Decode.at ["data", "image_url"] Decode.string
```

With that added, the "More" button actually goes and fetches a random gif. Check it out [here](http://elm-lang.org/examples/http)! But how does `getRandomGif` work exactly?

It starts out simple, we define `url` to be some giphy endpoint for random gifs. Next we create an HTTP `request` with [`Http.get`](http://package.elm-lang.org/packages/elm-lang/http/latest/Http#get). Finally, we turn it into a command with [`Http.send`](http://package.elm-lang.org/packages/elm-lang/http/latest/Http#send). Let’s break those steps down a bit more:

  - `Http.get : String -> Decode.Decoder value -> Http.Request value`

  This function takes a URL and a JSON decoder. This is our first time seeing a JSON decoder (and we will cover them in depth [later](/interop/json.md)), but for now, you really just need a high-level understanding. It turns JSON into Elm. In our case, we defined `decodeGifUrl` which tries to find a string value at `json.data.image_url`. Between the URL and the JSON decoder, we create an `Http.Request`. This is similar to a `Random.Generator` like we saw in [the previous example](random.md). It does not actually *do* anything. It just describes how to make an HTTP request.

  - `Http.send : (Result Error value -> msg) -> Http.Request value -> Cmd msg`

  Once we have an HTTP request, we can turn it into a command with `Http.send`. This is just like how we used `Random.generate` to create a command with a random generator. The first argument is a way to turn the result of the HTTP request into a message for our `update` function. In this case, we create a `NewGif` message.

This has been a very quick introduction, but the key idea is that you must (1) create an HTTP request and (2) turn that into a command so Elm will actually *do* it. You can go pretty far using the basic pattern here, and we will be looking into JSON decoders [later on](/interop/json.md), which will let you deal with whatever crazy JSON you run into.

> **Exercises:** To get more comfortable with this code, try augmenting it with skills we learned in previous sections:
>
>   - Show a message explaining why the image didn't change when you get an [`Http.Error`](http://package.elm-lang.org/packages/elm-lang/http/latest/Http#Error).
>   - Allow the user to modify the `topic` with a text field.
>   - Allow the user to modify the `topic` with a drop down menu.


