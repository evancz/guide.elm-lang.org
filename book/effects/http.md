# HTTP

Il est souvent utile de récupérer des informations ailleurs sur Internet.

Par exemple, imaginons que nous voulions charger le texte complet de _Public Opinion_ de Walter Lippmann. Publié en 1922, ce livre offre une perspective historique sur la montée des médias de masse et ses implications pour la démocratie. Pour ce qui nous amène ici, nous allons nous concentrer sur la façon d'utiliser le paquetage [`elm/http`][http] pour charger ce livre dans notre programme !

Cliquez sur le bouton bleu "Edit" pour regarder ce programme dans l'éditeur en ligne. Vous verrez probablement l'écran afficher "Loading..." avant que le livre complet n'apparaisse. **Cliquez sur le bouton bleu maintenant !**

[http]: https://package.elm-lang.org/packages/elm/http/latest

<div class="edit-link"><a href="https://elm-lang.org/examples/book">Edit</a></div>

```elm
import Browser
import Html exposing (Html, text, pre)
import Http



-- MAIN


main =
  Browser.element
    { init = init
    , update = update
    , subscriptions = subscriptions
    , view = view
    }



-- MODEL


type Model
  = Failure
  | Loading
  | Success String


init : () -> (Model, Cmd Msg)
init _ =
  ( Loading
  , Http.get
      { url = "https://elm-lang.org/assets/public-opinion.txt"
      , expect = Http.expectString GotText
      }
  )



-- UPDATE


type Msg
  = GotText (Result Http.Error String)


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    GotText result ->
      case result of
        Ok fullText ->
          (Success fullText, Cmd.none)

        Err _ ->
          (Failure, Cmd.none)



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none



-- VIEW


view : Model -> Html Msg
view model =
  case model of
    Failure ->
      text "I was unable to load your book."

    Loading ->
      text "Loading..."

    Success fullText ->
      pre [] [ text fullText ]
```

Certaines parties du code ci-dessus devraient vous être familières grâce aux précédents exemples de l'Architecture Elm. Nous avons toujours un `Model` de notre application. Nous avons toujours un `update` qui répond aux messages. Nous avons toujours une function `view` qui montre le tout à l'écran.

Les nouvelles parties étendent le principe de base que nous avions vu précédemment avec des changements dans `init` et dans `update` et l'ajout de `subscription`.


## `init`

La fonction `init` décrit comment initialiser le programme :

```elm
init : () -> (Model, Cmd Msg)
init _ =
  ( Loading
  , Http.get
      { url = "https://elm-lang.org/assets/public-opinion.txt"
      , expect = Http.expectString GotText
      }
  )
```


Comme toujours, nous devons produire le `Model` initial, mais maintenant nous produisons aussi une **commande** de ce que nous voulons faire immédiatement. Cette commande produira finalement un `Msg` qui sera envoyé à la fonction `update`.

Le site web de notre livre commence dans l'état `Loading`, et nous voulons récupérer le texte complet de notre livre. Lorsque l'on fait une requête GET avec [`Http.get`][get], on spécifie l'`url` des données que l'on veut récupérer, et on spécifie ce que l'on attend (`expect`) de ces données. Dans notre cas, l'`url` pointe vers des données sur le site web d'Elm, et nous nous attendons (`expect`) à ce que ce soit une grande `String` que nous pouvons montrer à l'écran.


La ligne `Http.expectString GotText` indique un peu plus que juste le fait que nous _attendons_ (`expect`) un `String`. Elle dit aussi que lorsque nous recevons une réponse, elle doit être transformée en un message `GotText` :

```elm
type Msg
  = GotText (Result Http.Error String)

-- GotText (Ok "The Project Gutenberg EBook of ...")
-- GotText (Err Http.NetworkError)
-- GotText (Err (Http.BadStatus 404))
```

Remarquez que nous utilisons le type `Result` que nous avons déjà utilisé quelques sections auparavant. Cela nous permet de prendre en compte les éventuels échecs de notre fonction `update`. En parlant de fonctions `update`...

[get]: https://package.elm-lang.org/packages/elm/http/latest/Http#get

> **Note:** Si vous vous demandez pourquoi `init` est une fonction (et pourquoi nous en ignorons l'argument), nous en parlerons dans le prochain chapitre sur l'interopérabilité JavaScript ! (Aperçu : l'argument nous permet d'obtenir des informations venant de JavaScript à l'initialisation).

## `update`

Notre fonction `update` renvoie également un peu plus d'informations :

```elm
update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    GotText result ->
      case result of
        Ok fullText ->
          (Success fullText, Cmd.none)

        Err _ ->
          (Failure, Cmd.none)
```

En regardant la signature du type de la fonction, nous voyons que nous ne retournons pas seulement un modèle mis à jour. Nous produisons également une **commande** de ce que nous voulons qu'Elm fasse.

En ce qui concerne l'implémentation, nous faisons du _pattern matching_ sur les messages comme habituellement. Quand un message `GotText` arrive, nous inspectons le `Result` de notre requête HTTP et mettons à jour notre modèle selon qu'il s'agisse d'un succès ou d'un échec. La nouveauté est que nous fournissons également une commande.

Ainsi, dans le cas où nous avons obtenu le texte complet avec succès, nous disons `Cmd.none` pour indiquer qu'il n'y a plus de travail à faire car nous avons déjà obtenu le texte complet !

Et dans le cas où il y a une erreur, nous disons également `Cmd.none` et nous abandonnons. Le texte du livre n'a pas été chargé. Si nous voulions être plus fantaisistes, nous pourrions faire un _pattern matching_ sur le [`Http.Error`][Error] et réessayer la requête si nous obtenons un timeout ou autre.

Ce qu'il faut retenir, c'est que quelle que soit la façon dont nous décidons de mettre à jour notre modèle, nous sommes également libres d'émettre de nouvelles commandes. J'ai besoin de plus de données ! Je veux un nombre aléatoire ! Etc.


[Error]: https://package.elm-lang.org/packages/elm/http/latest/Http#Error


## `subscription`

L'autre nouveauté de ce programme est la fonction `subscription`. Elle vous permet de regarder le `Model` et de décider si vous voulez vous abonner à certaines informations. Dans notre exemple, nous disons `Sub.none` pour indiquer que nous n'avons pas besoin de nous abonner à quoi que ce soit, mais nous verrons bientôt un exemple d'horloge où nous voulons nous abonner à l'heure actuelle !


## Résumé

Lorsque nous créons un programme avec `Browser.element`, nous mettons en place un système comme celui-ci :


![](diagrams/element.svg)

Nous avons la possibilité d'émettre des **commandes** depuis `init` et `update`. Cela nous permet de faire des choses comme des requêtes HTTP lorsque le besoin s'en fait sentir. Nous avons également la possibilité de nous **abonner** (**subscribe**) à des informations intéressantes. (Nous verrons un exemple d'abonnement plus tard !)
