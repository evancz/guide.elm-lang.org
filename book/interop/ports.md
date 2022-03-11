# Ports

Les ports autorisent la communication entre Elm et JavaScript. Ils sont par exemple couramment utilisés pour gérer les [`WebSockets`](https://github.com/elm-community/js-integration-examples/tree/master/websockets) et [`localStorage`](https://github.com/elm-community/js-integration-examples/tree/master/localStorage).

Examinons plus particulièrement le cas des `WebSockets` :

## Les ports en JavaScript

Le code HTML ci-dessous, très similaire aux exemples précédents, s'est vu ajouté un peu de JavaScript. Nous initialisons une connexion à `wss://echo.websocket.org` qui répondra systématiquement la même chose que ce que nous lui envoyons (très pratique pour tester ou déboguer son code !). Si vous lancez la [démo interactive](https://ellie-app.com/8yYgw7y7sM2a1), vous constaterez que nous ne sommes pas très loin d'obtenir le socle minimal d'un salon de discussion en ligne :

```html
<!DOCTYPE HTML>
<html>

<head>
  <meta charset="UTF-8">
  <title>Elm + Websockets</title>
  <script type="text/javascript" src="elm.js"></script>
</head>

<body>
    <div id="myapp"></div>
</body>

<script type="text/javascript">

// Démarrer l'application
var app = Elm.Main.init({
    node: document.getElementById('myapp')
});

// Créer la WebSocket.
var socket = new WebSocket('wss://echo.websocket.org');

// Quand une commande déclenche le port `sendMessage`, nous envoyons le message
// au travers de la WebSocket.
app.ports.sendMessage.subscribe(function(message) {
    socket.send(message);
});

// Quand un message arrive sur notre WebSocket, nous le passons au port de réception.
socket.addEventListener("message", function(event) {
    app.ports.messageReceiver.send(event.data);
});

// Si vous souhaitez utiliser une librairie JavaScript pour gérer votre connexion
// à la WebSocket, remplacez le code JavaScript par votre propre implémentation.
</script>

</html>
```

Comme dans les autres exemples de ce chapitre, nous invoquons `Elm.Main.init()`, cependant nous exploitons désormais l'objet contenu dans la variable `app`:

- Nous envoyons des messages par le biais du port `sendMessage` ;
- Nous recevons les nouveaux messages entrants grâce au port `messageReceiver`.

Ces ports sont, vous vous en doutez, implémentés en Elm.

## Les ports, côté Elm

Portons notre attention sur les lignes qui utilisent le mot-clé `port` dans le module ci-dessous : c'est de cette façon que nous déclarons les ports que nous venons de mettre en œuvre en JavaScript.

```elm
port module Main exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Decode as D



-- MAIN


main : Program () Model Msg
main =
  Browser.element
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }




-- PORTS


port sendMessage : String -> Cmd msg
port messageReceiver : (String -> msg) -> Sub msg



-- MODEL


type alias Model =
  { draft : String
  , messages : List String
  }


init : () -> ( Model, Cmd Msg )
init flags =
  ( { draft = "", messages = [] }
  , Cmd.none
  )



-- UPDATE


type Msg
  = DraftChanged String
  | Send
  | Recv String


-- Le port `sendMessage` est invoqué quand les utilisateurs appuient sur
-- la touche Entrée ou cliquent le bouton "Send" (Envoyer)
-- Inspectez le fichier index.html pour voir comment JavaScript envoie
-- les données sur la WebSocket.
--
update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    DraftChanged draft ->
      ( { model | draft = draft }
      , Cmd.none
      )

    Send ->
      ( { model | draft = "" }
      , sendMessage model.draft
      )

    Recv message ->
      ( { model | messages = model.messages ++ [message] }
      , Cmd.none
      )



-- SUBSCRIPTIONS


-- Ici on souscrit au port `messageReceiver` pour écouter les messages entrants
-- envoyés depuis JavaScript. Inspectez le fichier index.html pour voir comment
-- c'est câblé en JavaScript.
--
subscriptions : Model -> Sub Msg
subscriptions _ =
  messageReceiver Recv



-- VIEW


view : Model -> Html Msg
view model =
  div []
    [ h1 [] [ text "Echo Chat" ]
    , ul []
        (List.map (\msg -> li [] [ text msg ]) model.messages)
    , input
        [ type_ "text"
        , placeholder "Draft"
        , onInput DraftChanged
        , on "keydown" (ifIsEnter Send)
        , value model.draft
        ]
        []
    , button [ onClick Send ] [ text "Send" ]
    ]



-- DETECT ENTER


ifIsEnter : msg -> D.Decoder msg
ifIsEnter msg =
  D.field "key" D.string
    |> D.andThen (\key -> if key == "Enter" then D.succeed msg else D.fail "some other key")
```

Notez la déclaration `port module` au lieu de `module` sur la première ligne, qui autorise la définition de ports dans le module.

Examinons plus précisément l'implémentation Elm des ports `sendMessage` and `messageReceiver`.

## Messages sortants (`Cmd`)

Le port `sendMessage` permet d'envoyer des messages au-delà de notre conteneur applicatif Elm, typiquement à l'environnement JavaScript de la page HTML qui l'accueille.

```elm
port sendMessage : String -> Cmd msg
```

Ici nous envoyons des valeurs de type `String`, mais nous pourrions tout aussi bien envoyer n'importe quel autre type compatible avec les *flags*. Nous avons déjà évoqué ces types précédemment, mais vous pouvez également inspecter cet [exemple de mise en œuvre de `localStorage`](https://ellie-app.com/8yYddD6HRYJa1) pour voir comment envoyer une valeur de type [`Json.Encode.Value`](https://package.elm-lang.org/packages/elm/json/latest/Json-Encode#Value) à JavaScript.

Nous pouvons appeler `sendMessage` comme n'importe quelle autre fonction. Si votre fonction `update` retourne une commande `sendMessage "bonjour"`, elle sera reçue du côté de JavaScript :

```javascript
app.ports.sendMessage.subscribe(function(message) {
    console.log(message); // "bonjour"
    socket.send(message);
});
```

Ce code JavaScript souscrit à tous les messages sortants et les envoie sur la socket. Les méthodes `subscribe` et `unsubscribe` vous permettent de souscrire à de multiples fonctions et de résilier la souscription à une fonction par référence, mais une approche simple et statique suffira la majeur partie du temps.

Nous vous recommandons également d'envoyer des messages sortants *riches* plutôt que d'implémenter de multiples ports individuels. Cela peut impliquer de définir un type spécifique permettant de modéliser l'ensemble des informations que vous souhaitez transmettre à JavaScript, en utilisant [`Json.Encode`](https://package.elm-lang.org/packages/elm/json/latest/Json-Encode) pour le sérialiser et l'envoyer à une souscription unique côté JS. De nombreux utilisateurs apprécient la meilleure [séparation des responsabilités](https://fr.wikipedia.org/wiki/S%C3%A9paration_des_pr%C3%A9occupations) que cette approche procure.

## Messages entrants (`Sub`)

Le port `messageReceiver` nous permet d'écouter l'arrivée de nouveaux messages entrants.

```elm
port messageReceiver : (String -> msg) -> Sub msg
```

Ici nous recevons des valeurs de type `String`, mais comme dans le cas des messages sortants, nous pourrions décider de recevoir des messages de tout autre type compatible pouvant être importés via les *flags* ou les messages sortants.

Comme pour les messages sortants, nous pouvons invoquer `messageReceiver` comme n'importe quelle autre fonction. Ici, nous appelons `messageReceiver Recv` au moment de définir nos souscriptions pour intercepter tous les messages entrants provenant de JavaScript, nous permettant de recevoir des messages comme `Recv "comment ça va ?"` dans notre fonction `update`.

Côté JavaScript, nous sommes capables d'envoyer des données à ce port à n'importe quel moment :

```javascript
socket.addEventListener("message", function(event) {
    console.log(event.data); // "comment ça va ?"
    app.ports.messageReceiver.send(event.data);
});
```

Dans cet exemple, nous envoyons à Elm des données à chaque fois que la WebSocket en reçoit… Mais nous pourrions tout à fait décider d'en envoyer pour d'autres raisons, à d'autres moments. Par exemple, si nous recevons des messages d'une autre source de données, il suffit d'appeler le port en lui passant ces données en argument !

## Notes

**Les ports ont pour but de créer des frontières fortes !** N'essayez surtout pas de créer autant de ports que de fonctions JavaScript dont vous avez besoin. Même si vous adorez Elm et souhaitez tout implémenter en Elm quel qu'en soit le coût, les ports ne sont pas faits pour ça. Questionnez plutôt à quel domaine revient la gestion d'état, et utilisez un ou deux ports pour dialoguer avec lui si besoin. Face à un scénario complexe, vous pouvez simuler des valeurs de type `Msg` en envoyant des données JavaScript comme `{ tag: "active-users-changed", list: ... }`, pour lesquelles vous disposeriez d'un tag pour chaque variante d'informations susceptible d'être envoyée.

Voici quelques conseils simples et pièges courants à éviter :

- **Il est recommandé d'envoyer des valeurs de type `Json.Encode.Value` aux ports.** Comme pour les *flags*, [certains types de base](/interop/flags.html#verifying-flags) peuvent passer à travers les ports. Cela date du temps où les décodeurs JSON n'existaient pas encore.

- **Tous les ports doivent être déclarés dans un `port module`.** Il est par ailleurs préférable de déclarer tous vos ports dans un module unique afin d'accéder simplement à l'intégralité de son interface.

- **Les ports sont destinés aux applications.** Il n'est possible d'exposer un module de ports que dans une application, pas dans un package. De cette façon, les auteurs d'applications bénéficient d'une souplesse totale, mais les packages restent intégralement écrits en Elm. Nous pensons que c'est ce qui permet de garantir la meilleure fiabilité de l'écosystème sur le long terme, et nous développons nos arguments en ce sens [dans la section suivante](/interop/limits.html).

- **Les ports non exploités peuvent être supprimés.** Elm dispose d'une [stratégie d'elimination de code mort](https://fr.wikipedia.org/wiki/R%C3%A9usinage_de_code#Suppression_du_code_mort) agressive qui supprimera les ports qui ne sont jamais invoqués par le code Elm. Le compilateur ne sait jamais ce qui se passe en JavaScript, donc commencez toujours par développer vos ports en Elm avant de les exploiter en JavaScript.

Nous espérons que ces informations vous aideront à introduire Elm dans votre existant JavaScript ! Ce n'est certes pas aussi enthousiasmant que de tout réécrire en Elm *from scratch*, mais l'histoire nous a montré que c'est une approche souvent plus efficace.
