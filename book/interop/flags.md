# Flags

Les *flags* sont des valeurs transmises à Elm lors de la phase d'initialisation.

Ils sont typiquement utilisés pour passer à Elm des clés d'API, des variables d'environnement ou des données utilisateur, et ils s'avèrent particulièrement pratiques si vous générez du HTML dynamiquement. Les flags peuvent également servir à charger des informations depuis `localStorage`, comme [dans cet exemple](https://github.com/elm-community/js-integration-examples/tree/master/localStorage).

## Les flags en HTML

Reprenons notre exemple précédent de page HTML, en passant un argument `flags` à la fonction `Elm.Main.init()` :

```html
<html>
<head>
  <meta charset="UTF-8">
  <title>Main</title>
  <script src="main.js"></script>
</head>

<body>
  <div id="myapp"></div>
  <script>
  var app = Elm.Main.init({
    node: document.getElementById('myapp'),
    flags: Date.now()
  });
  </script>
</body>
</html>
```

Ici nous passons la date courante en millisecondes, mais n'importe quelle autre valeur JavaScript pouvant être décodée en JSON peut être utilisée comme *flag*.

> **Note :** Ces données supplémentaires sont appelées *flags* car elles évoquent les options passées à une ligne de commande. Vous pouvez appeler la commande `elm make src/Main.elm` et y passer des *flags* (options) comme `--optimize` ou `--output=main.js` pour modifier son comportement. C'est le même principe.

## Les flags en Elm

Pour gérer les flags dans le code Elm, nous avons besoin de modifier notre fonction `init` :

```elm
module Main exposing (..)

import Browser
import Html exposing (Html, text)


-- MAIN

main : Program Int Model Msg
main =
  Browser.element
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }


-- MODEL

type alias Model = { currentTime : Int }

init : Int -> ( Model, Cmd Msg )
init currentTime =
  ( { currentTime = currentTime }
  , Cmd.none
  )


-- UPDATE

type Msg = NoOp

update : Msg -> Model -> ( Model, Cmd Msg )
update _ model =
  ( model, Cmd.none )


-- VIEW

view : Model -> Html Msg
view model =
  text (String.fromInt model.currentTime)


-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions _ =
  Sub.none
```

L'élément le plus important ici est que notre fonction `init` accepte désormais un argument de type `Int`. C'est de cette façon qu'Elm accède aux flags passés depuis JavaScript. Une fois ces données reçues, vous pouvez les exploiter dans votre modèle ou déclencher des commandes.

Si vous êtes curieux, [cet exemple utilisant `localStorage`](https://github.com/elm-community/js-integration-examples/tree/master/localStorage) met en œuvre les flags de façon beaucoup plus intéressante !

## Vérification des flags

Attendez, que se passe t-il si `init` accepte un flag de type `Int` et qu'un petit malin essaye d'initialiser l'application avec `Elm.Main.init({ flags: "bazinga" })` ?

Elm effectue s'assure que les flags sont exactement de la nature escomptée. Sans ces vérifications, n'importe quels types de valeur pourraient être passés, déclenchant des erreurs Elm à l'exécution !

Il existe un certain nombre de types Elm natifs pouvant être utilisés pour les flags :

- `Bool`
- `Int`
- `Float`
- `String`
- `Maybe`
- `List`
- `Array`
- tuples
- records
- [`Json.Decode.Value`](https://package.elm-lang.org/packages/elm/json/latest/Json-Decode#Value)

Beaucoup de monde utilise `Json.Decode.Value` parce que ce type donne un contrôle très précis sur la nature des données. On peut écrire un décodeur dédié, permettant de traiter tous les types de scénarios bizarres qui peuvent survenir dans l'environnement Elm et retomber sur nos pieds.

Les autres types supportés ont été implémentés à une époque où les décodeurs JSON n'existaient pas encore. Si vous décidez de les utiliser, il y a quelques subtilités dont vous devez avoir conscience. Les exemples suivants montrent, pour un type de *flag* attendu, ce qui se passe quand des valeurs JavaScript de types différents lui sont transmises :

- `init : Int -> …`
  - `0` => `0`
  - `7` => `7`
  - `3.14` => erreur
  - `6.12` => erreur

- `init : Maybe Int -> …`
  - `null` => `Nothing`
  - `42` => `Just 42`
  - `"hi"` => erreur

- `init : { x : Float, y : Float } -> …`
  - `{ x: 3, y: 4, z: 50 }` => `{ x = 3, y = 4 }`
  - `{ x: 3, name: "Tom" }` => erreur
  - `{ x: 360, y: "why?" }` => erreur

- `init : (String, Int) -> …`
  - `["Tom", 42]` => `("Tom", 42)`
  - `["Sue", 33]` => `("Sue", 33)`
  - `["Bob", "4"]` => erreur
  - `["Joe", 9, 9]` => erreur

Notez que quand une conversion se passe mal, **vous obtenez une erreur JavaScript !**. Dans ce type de cas, Elm adopte une stratégie d'échec rapide (*fail fast*) ; plutôt que de propager l'erreur dans le code Elm, nous la rapportons avant même qu'elle l'atteigne. C'est une raison supplémentaire qui fait privilégier par beaucoup l'utilisation de `Json.Decode.Value` pour les flags. Plutôt que de déclencher des erreurs JavaScript, la valeur erronée transite par un décodeur, nous obligeant ainsi à traiter ces cas d'erreurs au travers des garanties qu'apporte Elm à ce niveau.
