# Une introduction à Elm

**Elm est un langage fonctionnel qui compile en Javascript.** Il va vous aider à réaliser des sites webs et des applications. Elm met fortement l'accent sur la simplicité et la qualité des outils.

Ce guide va :

  - Vous apprendre les fondamentaux de la programmation en Elm.
  - Vous montrer comment réaliser des applications intéractives à l'aide de **L'Architecture Elm**.
  - Mettre l'accent sur des principes et des patterns valables dans d'autres langages de programmation.


J'espère qu'à la fin de ce guide, vous serez non seulement capable de créer de superbes applications Web avec Elm, mais aussi de comprendre les idées et les concepts fondamentaux qui rendent Elm agréable à utiliser.

Si vous hésitez encore, je peux vous garantir que si vous donnez une chance à Elm et que vous l'utilisez pour réellement coder un projet, vous finirez quoiqu'il en soit par écrire un meilleur code JavaScript. Les idées sont facilement transférables !


## Un rapide exemple

Voici un petit programme qui vous permet d'incrémenter et de décrémenter un nombre :

```elm
import Browser
import Html exposing (Html, button, div, text)
import Html.Events exposing (onClick)

main =
  Browser.sandbox { init = 0, update = update, view = view }

type Msg = Increment | Decrement

update msg model =
  case msg of
    Increment ->
      model + 1

    Decrement ->
      model - 1

view model =
  div []
    [ button [ onClick Decrement ] [ text "-" ]
    , div [] [ text (String.fromInt model) ]
    , button [ onClick Increment ] [ text "+" ]
    ]
```

Essayez-le dans l'éditeur en ligne [ici](https://elm-lang.org/examples/buttons).

Le code peut sembler peu familier au premier abord, c'est pourquoi nous verrons bientôt comment fonctionne cet exemple !


## Pourquoi un *langage* fonctionnel?


Vous pouvez obtenir certains avantages en programmant dans un *style* fonctionnel, mais il y a des choses que vous ne pouvez obtenir que dans un *langage* fonctionnel comme Elm :

  - Aucune erreur d'exécution en pratique.
  - Des messages d'erreur conviviaux.
  - Un refactoring fiable.
  - Un versionnement sémantique automatique de tous les paquets Elm.

Aucune combinaison de bibliothèques JS ne peut vous donner toutes ces garanties car elles proviennent de la conception même du langage ! Et grâce à ces garanties, il est assez courant pour les programmeurs Elm de dire qu'ils ne se sont jamais sentis aussi **confiants** en programmant. Confiants pour ajouter des fonctionnalités rapidement. Confiants pour remanier des milliers de lignes. Mais sans l'angoisse de manquer quelque chose d'important !

J'ai mis l'accent sur la facilité d'apprentissage et d'utilisation d'Elm, donc tout ce que je vous demande, c'est d'essayer Elm et de voir ce que vous en pensez. J'espère que vous serez agréablement surpris !
