# HTTP

---
#### [Clone the code](https://github.com/evancz/elm-architecture-tutorial/) or follow along in the [online editor](https://elm-lang.org/examples/http).
---

We are about to make an app that fetches a random GIF when the user asks for another image.

Now, I am going to assume you just read the randomness example. It introduces **commands** which are really important for this example!

...

Okay, so you read it now right? Good!

In this example we use the [`elm/http`][http], [`elm/url`][url], and [`elm/json`][json] packages. We will talk about all that after you look through the code a bit:

[http]: https://package.elm-lang.org/packages/elm/http/latest
[json]: https://package.elm-lang.org/packages/elm/json/latest
[url]: https://package.elm-lang.org/packages/elm/url/latest

```elm
import Browser
import Html exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode as Decode
import Url.Builder as Url



-- MAIN


main =
  Browser.embed
    { init = init
    , update = update
    , subscriptions = subscriptions
    , view = view
    }



-- MODEL


type alias Model =
  { topic : String
  , url : String
  }


init : () -> (Model, Cmd Msg)
init _ =
  ( Model "cat" "waiting.gif"
  , getRandomGif "cat"
  )



-- UPDATE


type Msg
  = MorePlease
  | NewGif (Result Http.Error String)


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    MorePlease ->
      ( model
      , getRandomGif model.topic
      )

    NewGif result ->
      case result of
        Ok newUrl ->
          ( { model | url = newUrl }
          , Cmd.none
          )

        Err _ ->
          ( model
          , Cmd.none
          )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none



-- VIEW


view : Model -> Html Msg
view model =
  div []
    [ h2 [] [ text model.topic ]
    , button [ onClick MorePlease ] [ text "More Please!" ]
    , br [] []
    , img [ src model.url ] []
    ]



-- HTTP


getRandomGif : String -> Cmd Msg
getRandomGif topic =
  let
    request =
      Http.get (toGiphyUrl topic) gifUrlDecoder
  in
  Http.send NewGif request


toGiphyUrl : String -> String
toGiphyUrl topic =
  Url.crossOrigin "https://api.giphy.com" ["v1","gifs","random"]
    [ Url.string "api_key" "dc6zaTOxFJmzC"
    , Url.string "tag" topic
    ]


gifUrlDecoder : Decode.Decoder String
gifUrlDecoder =
  Decode.field "data" (Decode.field "image_url" Decode.string)

```

This program is quite similar to the random dice roller we just saw: `Model`, `init`, `update`, `subscriptions`, and `view`. The new stuff is mostly in the `HTTP` section which uses `elm/url`, `elm/json`, and `elm/http`. Let&rsqou;s go through those one-by-one.


## `elm/url`

Let&rsquo;s look at the `toGiphyUrl` function first. It may seem like we should have just made a string like this:

```elm
toBrokenGiphyUrl : String -> String
toBrokenGiphyUrl topic =
  "https://api.giphy.com/v1/gifs/random?api_key=dc6zaTOxFJmzC&tag=" ++ topic
```

It is nice and simple. But it will have quite odd results if `topic` contains characters like `=` or `&`. The user could start adding totally different query parameters!

So instead we use the [`Url.Builder`][builder] module from the `elm/url` package. We use two specific helper functions:

- [`crossOrigin`][crossOrigin] takes three arguments: (1) the domain, (2) each level of the path, and (3) a list of query parameters. It also guarantees that the query parameters will always be properly encoded. That means having `=` or `&` in the `topic` is not a problem anymore.
- [`string`][string] takes a `key` and a `value`. The `crossOrigin` function will turn them into `?key=value` to make the final URL, and the `value` will always be properly encoded!

So when you put them together, we end up with this `toGiphyUrl` function:

```elm
toGiphyUrl : String -> String
toGiphyUrl topic =
  Url.crossOrigin "https://api.giphy.com" ["v1","gifs","random"]
    [ Url.string "api_key" "dc6zaTOxFJmzC"
    , Url.string "tag" topic
    ]
```

Okay, but that URL is going to give us back some JSON. How do we handle JSON in Elm?

We are using

[builder]: https://package.elm-lang.org/packages/elm/url/latest/Url-Builder
[crossOrigin]: https://package.elm-lang.org/packages/elm/url/latest/Url-Builder#crossOrigin
[string]: https://package.elm-lang.org/packages/elm/url/latest/Url-Builder#string




## `elm/json`

The


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
      ( model
      , getRandomGif model.topic
      )

    NewGif (Ok newUrl) ->
      ( { model | gifUrl = newUrl }
      , Cmd.none
      )

    NewGif (Err _) ->
      ( model
      , Cmd.none
      )
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
  Decode.at [ "data", "image_url" ] Decode.string
```

With that added, the "More" button actually goes and fetches a random gif. Check it out [here](https://elm-lang.org/examples/http)! But how does `getRandomGif` work exactly?

It starts out simple, we define `url` to be some giphy endpoint for random gifs. Next we create an HTTP `request` with [`Http.get`](https://package.elm-lang.org/packages/elm/http/latest/Http#get). Finally, we turn it into a command with [`Http.send`](https://package.elm-lang.org/packages/elm/http/latest/Http#send). Let’s break those steps down a bit more:

  - `Http.get : String -> Decode.Decoder value -> Http.Request value`

  This function takes a URL and a JSON decoder. This is our first time seeing a JSON decoder (and we will cover them in depth [later](/interop/json.md)), but for now, you really just need a high-level understanding. It turns JSON into Elm. In our case, we defined `decodeGifUrl` which tries to find a string value at `json.data.image_url`. Between the URL and the JSON decoder, we create an `Http.Request`. This is similar to a `Random.Generator` like we saw in [the previous example](random.md). It does not actually *do* anything. It just describes how to make an HTTP request.

  - `Http.send : (Result Error value -> msg) -> Http.Request value -> Cmd msg`

  Once we have an HTTP request, we can turn it into a command with `Http.send`. This is just like how we used `Random.generate` to create a command with a random generator. The first argument is a way to turn the result of the HTTP request into a message for our `update` function. In this case, we create a `NewGif` message.

This has been a very quick introduction, but the key idea is that you must (1) create an HTTP request and (2) turn that into a command so Elm will actually *do* it. You can go pretty far using the basic pattern here, and we will be looking into JSON decoders [later on](/interop/json.md), which will let you deal with whatever JSON you run into.

> **Exercises:** To get more comfortable with this code, try augmenting it with skills we learned in previous sections:
>
>   - Show a message explaining why the image didn't change when you get an [`Http.Error`](https://package.elm-lang.org/packages/elm/http/latest/Http#Error).
>   - Allow the user to modify the `topic` with a text field.
>   - Allow the user to modify the `topic` with a drop down menu.


