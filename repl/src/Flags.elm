module Flags exposing
  ( Flags
  , State
  , Entry(..)
  , decode
  )


import Dict exposing (Dict)
import Json.Decode as D



-- FLAGS


type alias Flags =
  { id : Int
  , types : Bool
  , state : State
  }


type alias State =
  { imports : Dict String String
  , types : Dict String String
  , decls : Dict String String
  , entries : List Entry
  }


type Entry
  = Expr String String String
  | Decl String String String String
  | Type String String
  | Import String String



-- FLAGS DECODER


decode : D.Value -> Maybe Flags
decode value =
  Result.toMaybe (D.decodeValue decoder value)


decoder : D.Decoder Flags
decoder =
  D.map3 Flags
    (D.field "id" D.int)
    (D.field "types" D.bool)
    (D.map toState (D.field "entries" (D.list entryDecoder)))


entryDecoder : D.Decoder Entry
entryDecoder =
  D.oneOf
    [ D.map4 Decl
        (D.field "add-decl" D.string)
        (D.field "input" D.string)
        (D.field "value" D.string)
        (D.field "type_" D.string)
    , D.map2 Type
          (D.field "add-type" D.string)
          (D.field "input" D.string)
    , D.map2 Import
          (D.field "add-import" D.string)
          (D.field "input" D.string)
    , D.map3 Expr
        (D.field "input" D.string)
        (D.field "value" D.string)
        (D.field "type_" D.string)
    ]



-- TO STATE


toState : List Entry -> State
toState entries =
  List.foldr addEntry (State Dict.empty Dict.empty Dict.empty []) entries


addEntry : Entry -> State -> State
addEntry entry state =
  case entry of
    Expr input value tipe ->
      { state
          | entries = entry :: state.entries
      }

    Decl name input value tipe ->
      { state
          | entries = entry :: state.entries
          , decls = Dict.insert name (checkNewline input) state.decls
      }

    Type name input ->
      { state
          | entries = entry :: state.entries
          , types = Dict.insert name (checkNewline input) state.types
      }

    Import name input ->
      { state
          | entries = entry :: state.entries
          , imports = Dict.insert name (checkNewline input) state.imports
      }


checkNewline : String -> String
checkNewline input =
  if String.endsWith "\n" input
  then input
  else input ++ "\n"
