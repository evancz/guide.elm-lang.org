# Parsing URLs

In a realistic web app, we want to show different content for different URLs:

- `/search`
- `/search?q=seiza`
- `/settings`

How do we do that? We use the [`elm/url`](https://package.elm-lang.org/packages/elm/url/latest/) to parse the raw strings into nice Elm data structures. This package makes the most sense when you just look at examples, so that is what we will do!


## Example 1

Say we have an art website where the following addresses should be valid:

- `/topic/architecture`
- `/topic/painting`
- `/topic/sculpture`
- `/blog/42`
- `/blog/123`
- `/blog/451`
- `/user/tom`
- `/user/sue`
- `/user/sue/comment/11`
- `/user/sue/comment/51`

So we have topic pages, blog posts, user information, and a way to look up individual user comments. We would use the [`Url.Parser`](https://package.elm-lang.org/packages/elm/url/latest/Url-Parser) module to write a URL parser like this:

```elm
import Url.Parser exposing (Parser, (</>), int, map, oneOf, s, string)

type Route
  = Topic String
  | Blog Int
  | User String
  | Comment String Int

routeParser : Parser (Route -> a) a
routeParser =
  oneOf
    [ map Topic   (s "topic" </> string)
    , map Blog    (s "blog" </> int)
    , map User    (s "user" </> string)
    , map Comment (s "user" </> string </> s "comment" </> int)
    ]

-- /topic/pottery        ==>  Just (Topic "pottery")
-- /topic/collage        ==>  Just (Topic "collage")
-- /topic/               ==>  Nothing

-- /blog/42              ==>  Just (Blog 42)
-- /blog/123             ==>  Just (Blog 123)
-- /blog/mosaic          ==>  Nothing

-- /user/tom/            ==>  Just (User "tom")
-- /user/sue/            ==>  Just (User "sue")
-- /user/bob/comment/42  ==>  Just (Comment "bob" 42)
-- /user/sam/comment/35  ==>  Just (Comment "sam" 35)
-- /user/sam/comment/    ==>  Nothing
-- /user/                ==>  Nothing
```

The `Url.Parser` module makes it quite concise to fully turn valid URLs into nice Elm data!


## Example 2

Now say we have a personal blog where addresses like this are valid:

- `/blog/12/the-history-of-chairs`
- `/blog/13/the-endless-september`
- `/blog/14/whale-facts`
- `/blog/`
- `/blog?q=whales`
- `/blog?q=seiza`

In this case we have individual blog posts and a blog overview with an optional query parameter. We need to add the [`Url.Parser.Query`](https://package.elm-lang.org/packages/elm/url/latest/Url-Parser-Query) module to write our URL parser this time:

```elm
import Url.Parser exposing (Parser, (</>), (<?>), int, map, oneOf, s, string)
import Url.Parser.Query as Query

type Route
  = BlogPost Int String
  | BlogQuery (Maybe String)

routeParser : Parser (Route -> a) a
routeParser =
  oneOf
    [ map BlogPost  (s "blog" </> int </> string)
    , map BlogQuery (s "blog" <?> Query.string "q")
    ]

-- /blog/14/whale-facts  ==>  Just (BlogPost 14 "whale-facts")
-- /blog/14              ==>  Nothing
-- /blog/whale-facts     ==>  Nothing
-- /blog/                ==>  Just (BlogQuery Nothing)
-- /blog                 ==>  Just (BlogQuery Nothing)
-- /blog?q=chabudai      ==>  Just (BlogQuery (Just "chabudai"))
-- /blog/?q=whales       ==>  Just (BlogQuery (Just "whales"))
-- /blog/?query=whales   ==>  Just (BlogQuery Nothing)
```

The `</>` and `<?>` operators let us write parsers that look quite like the actual URLs we want to parse. And adding `Url.Parser.Query` allowed us to handle query parameters like `?q=seiza`.


## Example 3

Okay, now we have a documentation website with addresses like this:

- `/Basics`
- `/Maybe`
- `/List`
- `/List#map`
- `/List#filter`
- `/List#foldl`

We can use the [`fragment`](https://package.elm-lang.org/packages/elm/url/latest/Url-Parser#fragment) parser from `Url.Parser` to handle these addresses like this:

```elm
type alias Docs =
  (String, Maybe String)

docsParser : Parser (Docs -> a) a
docsParser =
  map Tuple.pair (string </> fragment identity)

-- /Basics     ==>  Just ("Basics", Nothing)
-- /Maybe      ==>  Just ("Maybe", Nothing)
-- /List       ==>  Just ("List", Nothing)
-- /List#map   ==>  Just ("List", Just "map")
-- /List#      ==>  Just ("List", Just "")
-- /List/map   ==>  Nothing
-- /           ==>  Nothing
```

So now we can handle URL fragments as well!


## Synthesis

Now that we have seen a few parsers, we should look at how this fits into a `Browser.application` program. Rather than just saving the current URL like last time, can we parse it into useful data and show that instead?

```elm
module Main exposing (Model, Msg(..), Route(..), init, links, main, routeParser, subscriptions, toRoute, update, view, viewLink)

import Browser
import Browser.Navigation as Nav
import Debug
import Html exposing (..)
import Html.Attributes exposing (..)
import Url exposing (Url)
import Url.Parser as UP exposing ((</>), Parser, int, map, oneOf, parse, s, string, top)



-- MAIN


main : Program () Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlChange = UrlChanged
        , onUrlRequest = LinkClicked
        }



-- MODEL


type alias Model =
    { key : Nav.Key
    , route : Route
    }


type Route
    = Topic String
    | Blog Int
    | User String
    | Comment String Int
    | NotFound
    | Home


init : () -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url key =
    ( Model key (toRoute url), Cmd.none )



-- UPDATE


type Msg
    = LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        LinkClicked urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    ( model, Nav.pushUrl model.key (Url.toString url) )

                Browser.External href ->
                    ( model, Nav.load href )

        UrlChanged url ->
            ( { model | route = toRoute url }
            , Cmd.none
            )


routeParser : Parser (Route -> a) a
routeParser =
    oneOf
        [ UP.map Topic (UP.s "topic" </> string)
        , UP.map Blog (UP.s "blog" </> int)
        , UP.map User (UP.s "user" </> string)
        , UP.map Comment (UP.s "user" </> string </> UP.s "comment" </> int)
        , UP.map Home top
        ]


toRoute : Url -> Route
toRoute url =
    Maybe.withDefault NotFound (parse routeParser url)



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- VIEW


view : Model -> Browser.Document Msg
view model =
    case model.route of
        Topic name ->
            { title = name
            , body =
                [ text "The current topic is: "
                , b [] [ text name ]
                , ul [] links
                ]
            }

        Blog id ->
            let
                stringID =
                    String.fromInt id
            in
            { title = stringID
            , body =
                [ text "This blog id is: "
                , b [] [ text stringID ]
                , ul [] links
                ]
            }

        User name ->
            { title = "User " ++ name
            , body =
                [ text "The current user name is: "
                , b [] [ text name ]
                , ul [] links
                ]
            }

        Comment name id ->
            let
                stringID =
                    String.fromInt id
            in
            { title = "Comment " ++ stringID ++ " from " ++ name
            , body =
                [ text "The current comment ID is: "
                , b [] [ text stringID ]
                , text " and is from the user: "
                , b [] [ text name ]
                , ul [] links
                ]
            }

        Home ->
            { title = "home page"
            , body =
                [ text "This is the home page"
                , ul [] links
                ]
            }

        NotFound ->
            { title = "Page not Found"
            , body =
                [ text "Page not found"
                ]
            }


links : List (Html msg)
links =
    [ viewLink "/topic/architecture"
    , viewLink "/topic/painting"
    , viewLink "/topic/sculpture"
    , viewLink "/blog/42"
    , viewLink "/blog/123"
    , viewLink "/blog/451"
    , viewLink "/user/tom"
    , viewLink "/user/sue"
    , viewLink "/user/sue/comment/11"
    , viewLink "/user/sue/comment/51"
    , viewLink "/"
    ]


viewLink : String -> Html msg
viewLink path =
    li [] [ a [ href path ] [ text path ] ]
```

The major new things are:

1. Our `update` parses the URL when it gets a `UrlChanged` message.
2. Our `view` function shows different content for different addresses!

It is really not too fancy. Nice!

But what happens when you have 10 or 20 or 100 different pages? Does it all go in this one `view` function? Surely it cannot be all in one file. How many files should it be in? What should be the directory structure? That is what we will discuss next!
