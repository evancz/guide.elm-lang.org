port module Repl exposing (main)

import Browser
import Browser.Dom as Dom
import Browser.Events as E
import Dict exposing (Dict)
import Elm.Error as Error
import Error
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Html.Keyed as Keyed
import Html.Lazy exposing (..)
import Http
import Json.Decode as D
import Json.Encode as E
import Time
import Task



-- MAIN


main =
  Browser.element
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }



-- PORTS


port evaluate : String -> Cmd msg

port outcomes : (D.Value -> msg) -> Sub msg


type EvalOutcome
  = Throw String
  | Return (Maybe String) String String


evalOutcomeDecoder : D.Decoder EvalOutcome
evalOutcomeDecoder =
  D.oneOf
    [ D.map Throw D.string
    , D.map3 Return
        (D.field "name" (D.nullable D.string))
        (D.field "value" D.string)
        (D.field "type" D.string)
    ]


getEvalOutcome : (EvalOutcome -> msg) -> D.Value -> msg
getEvalOutcome toMsg value =
  case D.decodeValue evalOutcomeDecoder value of
    Ok outcome ->
      toMsg outcome

    Err _ ->
      toMsg (Throw "Error: implementation bug")



-- MODEL


type alias Model =
  { imports : Dict String String
  , types : Dict String String
  , decls : Dict String String
  --
  , history : List Entry
  , activity : Activity
  , id : String
  , focus : Focus
  , visibility : E.Visibility
  --
  , showTypes : Bool
  , initialHistory : List Entry
  }


type Activity
  = Input (List String) String String
  | Waiting (List String) Int


type Focus
  = Inactive
  | Active Cursor


type Cursor = On | Off



-- INIT


type alias Flags =
  { id : Int
  , types : Bool
  , entries : List { input : String, value : String, type_ : String }
  }


init : Flags -> (Model, Cmd Msg)
init flags =
  let
    initialHistory =
      List.map toEntry flags.entries

    toEntry {input,value,type_} =
      Entry (String.split "\n" input) (GoodWork value type_)
  in
  ( { imports = Dict.empty
    , types = Dict.empty
    , decls = Dict.empty
    --
    , history = initialHistory
    , activity = Input [] "" ""
    , id = "elm-repl-" ++ String.fromInt flags.id
    , focus = Inactive
    , visibility = E.Visible
    --
    , showTypes = flags.types
    , initialHistory = initialHistory
    }
  , Cmd.none
  )



-- ENTRY


type alias Entry =
  { lines : List String
  , answer : Answer
  }


type Answer
  = BadRequest
  | BadEntry Error.Error
  | BadSituation String
  | GoodEntry
  | GoodWork String String



-- UPDATE


type Msg
  = NoOp
  | Blur
  | Focus
  | VisibilityChange E.Visibility
  | Blink
  | Tick
  | Press String Bool Bool Bool
  | GotWorkerResponse (List String) (Result () Outcome)
  | GotEvalOutcome EvalOutcome


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    NoOp ->
      ( model, Cmd.none )

    Blur ->
      ( { model | focus = Inactive }
      , Cmd.none
      )

    Focus ->
      ( { model | focus = Active On }
      , Task.attempt (\_ -> NoOp) (Dom.focus model.id)
      )

    VisibilityChange visibility ->
      ( { model | visibility = visibility }
      , Cmd.none
      )

    Blink ->
      ( { model | focus = blink model.focus }
      , Cmd.none
      )


    Tick ->
      case model.activity of
        Input _ _ _ ->
          ( model, Cmd.none )

        Waiting input n ->
          ( { model | activity = Waiting input (n + 1) }
          , Cmd.none
          )

    Press key alt ctrl meta ->
      case model.activity of
        Waiting _ _ ->
          ( model, Cmd.none )

        Input lines before after ->
          if alt && not ctrl && not meta then
            let
              (newBefore, newAfter) = processAltKey key before after
            in
            ( { model | activity = Input lines newBefore newAfter }
            , Cmd.none
            )

          else if alt || ctrl || meta then
            ( model, Cmd.none )

          else
            case processKey key before after of
              Edit newBefore newAfter ->
                ( { model | activity = Input lines newBefore newAfter }
                , Cmd.none
                )

              Enter ->
                let
                  waitingLines =
                    lines ++ [before ++ after]
                in
                ( { model | activity = Waiting waitingLines 0 }
                , checkEntry model waitingLines
                )

    GotWorkerResponse lines result ->
      case result of
        Err () ->
          ( { model
                | history = model.history ++ [ Entry lines BadRequest ]
                , activity = Input [] "" ""
            }
          , Cmd.none
          )

        Ok outcome ->
          case outcome of
            NewImport name ->
              ( { model
                    | imports = Dict.insert name (String.join "\n" lines ++ "\n") model.imports
                    , history = model.history ++ [ Entry lines GoodEntry ]
                    , activity = Input [] "" ""
                }
              , Cmd.none
              )

            NewType name ->
              ( { model
                    | types = Dict.insert name (String.join "\n" lines ++ "\n") model.types
                    , history = model.history ++ [ Entry lines GoodEntry ]
                    , activity = Input [] "" ""
                }
              , Cmd.none
              )

            NewWork javascript ->
              ( model
              , evaluate javascript
              )

            Reset ->
              ( { model
                    | history = model.initialHistory
                    , activity = Input [] "" ""
                }
              , Cmd.none
              )

            Skip ->
              ( { model
                    | history = model.history ++ [ Entry lines GoodEntry ]
                    , activity = Input [] "" ""
                }
              , Cmd.none
              )

            Indent ->
              ( { model | activity = Input lines "  " "" }
              , Cmd.none
              )

            DefStart name ->
              ( { model | activity = Input lines (name ++ " ") "" }
              , Cmd.none
              )

            NoPorts ->
              ( { model
                    | history = model.history ++ [ Entry lines (BadSituation "Error: cannot define ports here.") ]
                    , activity = Input [] "" ""
                }
              , Cmd.none
              )

            InvalidCommand ->
              ( { model
                    | history = model.history ++ [ Entry lines (BadSituation "Error: unrecognized command.") ]
                    , activity = Input [] "" ""
                }
              , Cmd.none
              )

            Failure error ->
              ( { model
                    | history = model.history ++ [ Entry lines (BadEntry error) ]
                    , activity = Input [] "" ""
                }
              , Cmd.none
              )

    GotEvalOutcome outcome ->
      let
        lines = getLines model.activity
      in
      case outcome of
        Throw message ->
          ( { model
                | history = model.history ++ [ Entry lines (BadSituation message) ]
                , activity = Input [] "" ""
            }
          , Cmd.none
          )

        Return maybeName ansiValue tipe ->
          let
            newDecls =
              case maybeName of
                Nothing ->
                  model.decls

                Just name ->
                  Dict.insert name (String.join "\n" lines ++ "\n") model.decls
          in
          ( { model
                | decls = newDecls
                , history = model.history ++ [ Entry lines (GoodWork ansiValue tipe) ]
                , activity = Input [] "" ""
            }
          , Cmd.none
          )


blink : Focus -> Focus
blink focus =
  case focus of
    Inactive   -> Inactive
    Active On  -> Active Off
    Active Off -> Active On


getLines : Activity -> List String
getLines activity =
  case activity of
    Input lines before after ->
      lines ++ [ before ++ after ]

    Waiting lines _ ->
      lines



-- PROCESS KEY


type NewInput
  = Edit String String
  | Enter


processKey : String -> String -> String -> NewInput
processKey key before after =
  case key of
    "Backspace" ->
      Edit (String.dropRight 1 before) after

    "Delete" ->
      Edit before (String.dropLeft 1 after)

    "ArrowLeft" ->
      Edit (String.dropRight 1 before) (String.right 1 before ++ after)

    "ArrowRight" ->
      Edit (before ++ String.left 1 after) (String.dropLeft 1 after)

--    "ArrowDown" ->
--      Debug.todo "ArrowDown"

--    "ArrowUp" ->
--      Debug.todo "ArrowUp"

    "Enter" ->
      Enter

    _ ->
      if String.length key == 1 then
        Edit (before ++ key) after
      else
        Edit before after



-- PROCESS ALT KEY


processAltKey : String -> String -> String -> (String, String)
processAltKey key before after =
  case key of
    "ArrowLeft" ->
      case List.reverse (String.toList before) of
        [] ->
          ("", after)

        c :: cs ->
          let
            (skipped, remaining) = findNextBoundary [] c cs
          in
          ( String.fromList (List.reverse remaining)
          , String.fromList skipped ++ after
          )

    "ArrowRight" ->
      case String.toList after of
        [] ->
          (before, "")

        c :: cs ->
          let
            (skipped, remaining) = findNextBoundary [] c cs
          in
          ( before ++ String.fromList (List.reverse skipped)
          , String.fromList remaining
          )

    _ ->
      ( before, after )



findNextBoundary : List Char -> Char -> List Char -> (List Char, List Char)
findNextBoundary skipped char remaining =
  case remaining of
    [] ->
      ( char :: skipped, [] )

    c :: cs ->
      if Char.isAlphaNum char && not (Char.isAlphaNum c) then
        ( char :: skipped, remaining )
      else
        findNextBoundary (char :: skipped) c cs



-- CHECK ENTRY


checkEntry : Model -> List String -> Cmd Msg
checkEntry model lines =
  Http.post
    { url = "https://worker.elm-lang.org/repl"
    , body =
        Http.jsonBody <|
          E.object
            [ ( "imports", E.dict identity E.string model.imports )
            , ( "types", E.dict identity E.string model.types )
            , ( "decls", E.dict identity E.string model.decls )
            , ( "entry", E.string (String.join "\n" lines) )
            ]
    , expect =
        Http.expectStringResponse (GotWorkerResponse lines) toOutcome
    }


type Outcome
  = NewImport String
  | NewType String
  | NewWork String
  --
  | Reset
  | Skip
  | Indent
  | DefStart String
  --
  | NoPorts
  | InvalidCommand
  | Failure Error.Error


toOutcome : Http.Response String -> Result () Outcome
toOutcome response =
  case response of
    Http.BadUrl_ _      -> Err ()
    Http.Timeout_       -> Err ()
    Http.NetworkError_  -> Err ()
    Http.BadStatus_ _ _ -> Err ()
    Http.GoodStatus_ metadata body ->
      case Dict.get "content-type" metadata.headers of
        Just "text/plain" ->
          case String.split ":" body of
            ["add-import",name] -> Ok (NewImport name)
            ["add-type",name]   -> Ok (NewType name)
            ["reset"]           -> Ok Reset
            ["skip"]            -> Ok Skip
            ["indent"]          -> Ok Indent
            ["def-start",name]  -> Ok (DefStart name)
            ["no-ports"]        -> Ok NoPorts
            ["invalid-command"] -> Ok InvalidCommand
            _                   -> Err ()

        Just "application/json" ->
          case D.decodeString Error.decoder body of
            Ok  e -> Ok (Failure e)
            Err _ -> Err ()

        Just "application/javascript" ->
          Ok (NewWork body)

        _ ->
          Err ()



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.batch
    [ E.onVisibilityChange VisibilityChange
    , outcomes (getEvalOutcome GotEvalOutcome)
    , case model.focus of
        Inactive -> Sub.none
        Active _ -> Time.every 500 (\_ -> Blink)
    , case model.activity of
        Input _ _ _ ->
          Sub.none

        Waiting _ _ ->
          case model.visibility of
            E.Visible -> Time.every delay (\_ -> Tick)
            E.Hidden -> Sub.none
    ]


delay : Float
delay =
  500



-- VIEW


view : Model -> Html Msg
view model =
  div
    [ style "background" "black"
    , style "color" "white"
    , style "width" "80ch"
    , style "padding" "2ch"
    , style "margin" "0 0 1.275em 0"
    , style "fontFamily" "monospace"
    , style "whiteSpace" "pre"
    , onClick Focus
    ]
    [ lazy2 viewHistory model.showTypes model.history
    , viewActivity model.activity model.focus
    , lazy viewInputCatcher model.id
    ]



-- VIEW ACTIVITY


viewActivity : Activity -> Focus -> Html msg
viewActivity activity focus =
  case activity of
    Input lines before after ->
      p [ style "margin" "0" ] <|
        unrollInput "> " lines before after focus

    Waiting lines n ->
      p [ style "margin" "0" ]
        [ text ("> " ++ String.join "\n| " lines ++ "\n")
        , viewWaitingFrame n
        ]


unrollInput : String -> List String -> String -> String -> Focus -> List (Html msg)
unrollInput starter lines before after focus =
  case lines of
    [] ->
      [ text starter
      , text before
      , span
          [ case focus of
              Active On  -> style "background" "rgb(96,96,96)"
              Active Off -> style "outline" "1px solid rgb(96,96,96)"
              Inactive   -> style "outline" "1px solid rgb(96,96,96)"
          ]
          [ text (if String.isEmpty after then " " else String.left 1 after)
          ]
      , text (String.dropLeft 1 after)
      ]

    line :: newerLines ->
      text (starter ++ line ++ "\n") :: unrollInput "| " newerLines before after focus



-- VIEW WAITING FRAME


viewWaitingFrame : Int -> Html msg
viewWaitingFrame tick =
  let
    index =
      tick - ceiling (1000 / delay)
  in
  if index < 0 then
    text " "
  else
    case List.drop (modBy numFrames index) waitingFrames of
      [] ->
        text " "

      frame :: _ ->
        span [ style "color" "rgb(129,131,131)" ] [ text frame ]


numFrames : Int
numFrames =
  List.length waitingFrames


waitingFrames : List String
waitingFrames =
  ["⣇","⡧","⡗","⡏","⡗","⡧"]



-- VIEW HISTORY


viewHistory : Bool -> List Entry -> Html msg
viewHistory showTypes history =
  Keyed.node "p" [ style "margin" "0" ] <|
    List.indexedMap (viewKeyedEntry showTypes) history


viewKeyedEntry : Bool -> Int -> Entry -> (String, Html msg)
viewKeyedEntry showTypes index entry =
  ( String.fromInt index, lazy2 viewEntry showTypes entry )


viewEntry : Bool -> Entry -> Html msg
viewEntry showTypes entry =
  span [] <|
    text ("> " ++ String.join "\n| " entry.lines ++ "\n")
    ::
    case entry.answer of
      BadRequest ->
        [ text "<bad request>\n\n" ]

      BadEntry error ->
        Error.view error

      BadSituation message ->
        [ text (message ++ "\n\n") ]

      GoodEntry ->
        [ text "\n" ]

      GoodWork ansiValue tipe ->
        viewGoodWork ansiValue tipe showTypes


viewGoodWork : String -> String -> Bool -> List (Html msg)
viewGoodWork ansiValue tipe showTypes =
  viewAnsiString ansiValue
  ++
  [
    if showTypes then
      span [ style "color" "rgb(129,131,131)" ] [ text (formatType ansiValue tipe) ]
    else
      text "\n\n"
  ]


formatType : String -> String -> String
formatType ansiValue tipe =
  if String.length ansiValue + 3 + String.length tipe >= 80 || String.contains "\n" tipe
  then "\n    : " ++ String.replace "\n" "\n      " tipe ++ "\n\n"
  else " : " ++ tipe ++ "\n\n"


viewAnsiString : String -> List (Html msg)
viewAnsiString ansiValue =
  case String.split "\u{001b}[" ansiValue of
    [] ->
      []

    start :: chunks ->
      text start :: List.map viewAnsiChunk chunks


viewAnsiChunk : String -> Html msg
viewAnsiChunk chunk =
  let
    viewAnsi color =
      span [ style "color" color ] [ text (String.dropLeft 3 chunk) ]
  in
  case String.left 3 chunk of
    "30m" -> viewAnsi "rgb(0,0,0)"
    "31m" -> viewAnsi "rgb(194,54,33)"
    "32m" -> viewAnsi "rgb(37,188,36)"
    "33m" -> viewAnsi "rgb(173,173,39)"
    "34m" -> viewAnsi "rgb(73,46,225)"
    "35m" -> viewAnsi "rgb(211,56,211)"
    "36m" -> viewAnsi "rgb(51,187,200)"
    "37m" -> viewAnsi "rgb(203,204,205)"
    "90m" -> viewAnsi "rgb(129,131,131)"
    "91m" -> viewAnsi "rgb(252,57,31)"
    "92m" -> viewAnsi "rgb(49,231,34)"
    "93m" -> viewAnsi "rgb(234,236,35)"
    "94m" -> viewAnsi "rgb(88,51,255)"
    "95m" -> viewAnsi "rgb(249,53,248)"
    "96m" -> viewAnsi "rgb(20,240,240)"
    "97m" -> viewAnsi "rgb(233,235,235)"
    _ ->
      text (if String.startsWith "0m" chunk then String.dropLeft 2 chunk else chunk)



-- VIEW INPUT CATCHER


viewInputCatcher : String -> Html Msg
viewInputCatcher uid =
  input
    [ id uid
    , style "position" "absolute"
    , style "outline" "none"
    , style "border" "none"
    , style "opacity" "0"
    , onBlur Blur
    , onKeyDown
    ]
    [ text ""
    ]


onKeyDown : Attribute Msg
onKeyDown =
  preventDefaultOn "keydown" <|
    D.map4 (\key alt ctrl meta -> ( Press key alt ctrl meta, not (alt || ctrl || meta) ))
      (D.field "key" D.string)
      (D.field "altKey" D.bool)
      (D.field "ctrlKey" D.bool)
      (D.field "metaKey" D.bool)

