# Boutons

Notre premier example est un compteur qui peut être incrémenté ou décrémenté.

J’ai ajouté le programme ci-dessous. Cliquez sur le bouton bleu "Éditer" pour l'afficher dans l’éditeur en ligne. Essayez de changer le texte sur un des boutons.
**Clique maintenant sur le bouton bleu !**

<div class="edit-link"><a href="https://elm-lang.org/examples/buttons">Éditer</a></div>

```elm
import Browser
import Html exposing (Html, button, div, text)
import Html.Events exposing (onClick)



-- MAIN


main =
  Browser.sandbox { init = init, update = update, view = view }



-- MODEL

type alias Model = Int

init : Model
init =
  0


-- UPDATE

type Msg = Increment | Decrement

update : Msg -> Model -> Model
update msg model =
  case msg of
    Increment ->
      model + 1

    Decrement ->
      model - 1


-- VIEW

view : Model -> Html Msg
view model =
  div []
    [ button [ onClick Decrement ] [ text "-" ]
    , div [] [ text (String.fromInt model) ]
    , button [ onClick Increment ] [ text "+" ]
    ]
```

Maintenant que vous vous êtes familiariser avec le code, vous devriez vous poser quelques questions. Que fait la valeur `main` ? Comment tout cela fonctionne ? Parcourons le code afin d'en discuter.

> **Note:** Le code qui est ici correspond aux [type annotations](/types/reading_types.html), [type aliases](/types/type_aliases.html), et [custom types](/types/custom_types.html). Le but ici est de vous donner une idée du fonctionnement de l’architecture de ELM, nous les aborderons un peu plus tard. Je vous encourage à aller jeter un coup d’oeil, si vous êtes bloqué·e·s sur ces aspects !

## La fonction principale `Main`

La valeur `main` est spéciale en Elm. Elle décrit ce qui sera affiché à l’écran. Dans notre cas, nous allons initialiser notre application avec la valeur `init`, la fonction `view` affichera tout ce qu’il y’aura à l’écran, et les entrées de l’utilisateur seront transmises à la function `update`. Ayez en tête que c’est le fonctionnement global de notre programme.

## Le Modèle

La modelisation des données est extrêment important en ELM. L’intérêt du modèle est de projeter tous les détails de votre application sous forme de donnée.

Pour faire un compteur, nous devons garder la trace d’un nombre qui monte et descend. Notre modèle est vraiment simple cette fois-ci:

```elm
type alias Model = Int
```

Nous avons juste besoin d’une valeur `Int` pour garder la valeur courante du compteur. Nous pouvons voir notre valeur initiale:

```elm
init : Model
init =
  0
```

La valeur initiale est zéro, et elle augmentera ou diminuera au fur et à mesure que les gens cliqueront sur les différents boutons.

## La vue

Nous avons un modèle mais comment allons-nous l'afficher à l'écran ? C'est le role de la fonction `view`:

```elm
view : Model -> Html Msg
view model =
  div []
    [ button [ onClick Decrement ] [ text "-" ]
    , div [] [ text (String.fromInt model) ]
    , button [ onClick Increment ] [ text "+" ]
    ]
```

Cette fonction prend le `model` en paramètre et renvoie du HTML. Nous souhaitons afficher un bouton pour incrementer, décrementer et voir la valeur du compteur.

À savoir que nous avons un gestionnaire d’évenements `onClick` pour chaque boutons. Cela veut dire que : **Quand quelqu’un clique, envoie un message**. Donc, le bouton plus envoie le message `Increment`. Que se passe-t-il et où part le message ? À la fonction `update` !

## La fonction de mise à jour `Update`

La fonction `update` décrit la façon dont le modèle va changer au fur et à mesure du temps.

Nous avons défini deux messages qu'elle pourra recevoir:

```elm
type Msg = Increment | Decrement
```

À partir de là, la fonction `update` décrit simplement ce qu’il faut faire lorsqu’elle reçoit un des messages.

```elm
update : Msg -> Model -> Model
update msg model =
  case msg of
    Increment ->
      model + 1

    Decrement ->
      model - 1
```

Si vous recevez un message `Increment`, vous incrémentez le modèle. Si vous recevez le message `Decrement`, vous le décrementez.

À chaque fois que nous recevons un message, la fonction `update` traite afin d'obtenir un nouveau modèle. Ensuite, nous appelons la vue afin d'afficher le nouveau model dans à l’écran. Tous ceci se repète ! L'entrée utilisateur envoie un message, la fonction `update` met à jour le model, et la fonction `view` l'affiche sur l'écran. Etc.

## En résumé

Maintenant que nous avons abordé toutes les parties d'un programme Elm, il est peut-être un peu plus facile de voir comment elles s’intègrent dans le diagramme que nous avons vu précédemment:

![Diagram of The Elm Architecture](buttons.svg)

Elm commence par rendre la valeur initiale sur l’écran. Ensuite, vous entrez dans cette boucle :

1. En attente d’une entrée utilisateur.
2. Envoie le message à la fonction `update`
3. Produit un nouveau `model`
4. Appelle la vue `view` pour avoir un nouveau HTML
5. Affiche le nouveu HTML sur l’écran
6. Et on boucle !

C'est l'essence même de l'architecture Elm. Chaque exemple que nous verrons à partir de maintenant sera une légère variation de ce modèle.

> **Exercice:** Ajouter un bouton pour réinitialiser le compteur à zéro :
>
> 1. Ajouter un nouveau message `Reset` sur le type `Msg`
> 2. Ajouter une branche `Reset` dans la fonction `update`
> 3. Ajouter un bouton dans le fontion `view`.
>
> Vous pouvez éditer l'exemple dans l’éditeur en ligne [ici](https://elm-lang.org/examples/buttons).
>
> Si tout s'est bien passé, essayer d'ajouter un bouton qui permet d'incrementer le compteur de 10.
