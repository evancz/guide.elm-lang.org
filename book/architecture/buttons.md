# Boutons

Notre premier exemple est un compteur qui peut être incrémenté ou décrémenté.

J’ai ajouté le programme complet ci-dessous. Cliquez sur le bouton bleu "Éditer" pour jouer avec l’éditeur en ligne. Essayez de changer le texte sur un des boutons.
**Cliquez maintenant sur le bouton bleu !**

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

Une fois familiarisés avec le code, nous devrions nous poser quelques questions. Que fait la valeur `main` ? Comment tout cela fonctionne ? Parcourons le code afin d’en discuter.

> **Note:** Le code qui est ici correspond aux [type annotations](/types/reading_types.html), [type aliases](/types/type_aliases.html), et [custom types](/types/custom_types.html). Cette section ne fait qu'esquisser les principes de l'Architecture Elm, que nous aborderons plus en détail par la suite. Cela dit, rien ne vous empêche de creuser dès à présent ces aspects si le cœur vous en dit !

## La fonction principale `Main`

La valeur `main` est spéciale en Elm. Elle décrit ce qui sera affiché à l’écran. Dans notre cas, nous allons initialiser notre application avec la valeur `init`, la fonction `view` affichera tout ce qu’il y aura à l’écran, et les entrées de l’utilisateur seront transmises à la function `update`. Ayez en tête que c’est le fonctionnement global de notre programme.

## Le Modèle

La modélisation des données est extrêmement important en Elm. L’intérêt du modèle est de projeter tous les détails de votre application sous forme de données.

Pour réaliser un compteur, nous devons garder trace d’un nombre qui monte et descend. Notre modèle est vraiment simple cette fois-ci :

```elm
type alias Model = Int
```

Nous avons juste besoin d’une valeur `Int` pour garder la valeur courante du compteur. Nous pouvons voir cela dans notre valeur initiale :

```elm
init : Model
init =
  0
```

La valeur initiale est zéro, et elle augmentera ou diminuera au fur et à mesure que les gens cliqueront sur les différents boutons.

## La vue

Nous avons un modèle mais comment allons-nous l'afficher à l'écran ? C'est le rôle de la fonction `view`:

```elm
view : Model -> Html Msg
view model =
  div []
    [ button [ onClick Decrement ] [ text "-" ]
    , div [] [ text (String.fromInt model) ]
    , button [ onClick Increment ] [ text "+" ]
    ]
```

Cette fonction prend le `model` en paramètre et renvoie du HTML. Nous souhaitons afficher un bouton pour incrémenter, décrémenter et voir la valeur du compteur.

À savoir que nous avons un gestionnaire d’événements `onClick` pour chaque bouton. Cela veut dire : **Quand quelqu’un clique, envoie un message**. Donc, le bouton _plus_ envoie le message `Increment`. Que se passe-t-il et où part le message ? À la fonction `update` !

## Mise à jour

La fonction `update` décrit la façon dont le modèle va changer au fil du temps.

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

Si vous recevez un message `Increment`, vous incrémentez le modèle. Si vous recevez le message `Decrement`, vous le décrémentez.

À chaque fois que nous recevons un message, la fonction `update` traite le message afin d'obtenir un nouveau modèle. Ensuite, nous appelons la vue afin d'afficher le nouveau modèle à l’écran. Tous ceci se répète ! L'entrée utilisateur envoie un message, la fonction `update` met à jour le modèle, et la fonction `view` l’affiche à l’écran. Etc.

## En résumé

Maintenant que nous avons abordé toutes les parties d’un programme Elm, il est peut-être un peu plus facile de voir comment elles s’intègrent dans le diagramme que nous avons vu précédemment :

![Diagram of The Elm Architecture](buttons.svg)

Elm commence par afficher la valeur initiale à l’écran. Ensuite, vous entrez dans cette boucle :

1. En attente d’une entrée utilisateur.
2. Envoie un message à la fonction `update`
3. Produit un nouveau `Model`
4. Appelle `view` pour obtenir un nouveau HTML
5. Affiche le nouveau HTML à l’écran
6. Et on boucle !

C'est l’essence même de l'Architecture Elm. Chaque exemple que nous verrons à partir de maintenant sera une légère variation de ce modèle.

> **Exercice :** Ajoutez un bouton pour réinitialiser le compteur à zéro :
>
> 1. Ajoutez un nouveau message `Reset` sur le type `Msg`
> 2. Ajoutez une branche `Reset` dans la fonction `update`
> 3. Ajoutez un bouton dans le fontion `view`.
>
> Vous pouvez éditer l’exemple dans l’éditeur en ligne [ici](https://elm-lang.org/examples/buttons).
>
> Si tout s’est bien passé, essayez d'ajouter un bouton qui permet d’incrémenter le compteur de 10.
