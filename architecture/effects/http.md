# HTTP

```elm
import Html exposing (..)
import Html.App as Html
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Http
import Json.Decode as Json
import Task


main =
  Html.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }


-- MODEL

type alias Model =
  { topic : String
  , gifUrl : String
  }


init : String -> (Model, Cmd Msg)
init topic =
  Model topic "assets/waiting.gif"
    ! [ getRandomGif topic ]


-- UPDATE

type Msg
    = RequestMore
    | NewGif String
    | Fail Http.Error


update : Msg -> Model -> (Model, Cmd Msg)
update action model =
  case action of
    RequestMore ->
      model ! [ getRandomGif model.topic ]

    NewGif url ->
      { model | gifUrl = url } ! []

    Fail _ ->
      model ! []


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


-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none
```
