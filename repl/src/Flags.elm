module Flags exposing
  ( Flags
  , State
  , Content
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
  , content : List Content
  }


type alias Content =
  { input : String
  , value : String
  , type_ : String
  }



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



-- ENTRY DECODER


type Entry
  = Expr Content
  | Decl String Content
  | Type String Content
  | Import String Content


entryDecoder : D.Decoder Entry
entryDecoder =
  D.oneOf
    [ D.map2 Decl (D.field "add-decl" D.string) contentDecoder
    , D.map2 Type (D.field "add-type" D.string) contentDecoder
    , D.map2 Import (D.field "add-import" D.string) contentDecoder
    , D.map Expr contentDecoder
    ]


contentDecoder : D.Decoder Content
contentDecoder =
  D.map3 Content
    (D.field "input" D.string)
    (D.field "value" D.string)
    (D.field "type_" D.string)



-- TO STATE


toState : List Entry -> State
toState entries =
  List.foldr addEntry (State Dict.empty Dict.empty Dict.empty []) entries


addEntry : Entry -> State -> State
addEntry entry state =
  case entry of
    Expr content ->
      { state
          | content = content :: state.content
      }

    Decl name content ->
      { state
          | content = content :: state.content
          , decls = Dict.insert name content.input state.decls
      }

    Type name content ->
      { state
          | content = content :: state.content
          , types = Dict.insert name content.input state.types
      }

    Import name content ->
      { state
          | content = content :: state.content
          , imports = Dict.insert name content.input state.imports
      }

