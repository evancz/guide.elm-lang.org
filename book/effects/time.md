# Temps

Nous allons maintenant fabriquer une horloge numérique. (L'analogique sera un exercice !)

Jusqu'à présent, nous nous sommes concentrés sur les commandes. Avec les exemples HTTP et les exemples de génération de nombres aléatoires, nous avons demandé à Elm de faire un travail spécifique immédiatement, mais c'est une sorte de modèle bizarre pour une horloge. Nous voulons _toujours_ connaître l'heure actuelle. C'est là que les **abonnements** (_subscriptions_) entrent en jeu !

Commencez par cliquer sur le bouton bleu "Edit" et regardez un peu le code dans l'éditeur en ligne.

<div class="edit-link"><a href="https://elm-lang.org/examples/time">Edit</a></div>

```elm
import Browser
import Html exposing (..)
import Task
import Time



-- MAIN


main =
  Browser.element
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }



-- MODEL


type alias Model =
  { zone : Time.Zone
  , time : Time.Posix
  }


init : () -> (Model, Cmd Msg)
init _ =
  ( Model Time.utc (Time.millisToPosix 0)
  , Task.perform AdjustTimeZone Time.here
  )



-- UPDATE


type Msg
  = Tick Time.Posix
  | AdjustTimeZone Time.Zone



update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Tick newTime ->
      ( { model | time = newTime }
      , Cmd.none
      )

    AdjustTimeZone newZone ->
      ( { model | zone = newZone }
      , Cmd.none
      )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
  Time.every 1000 Tick



-- VIEW


view : Model -> Html Msg
view model =
  let
    hour   = String.fromInt (Time.toHour   model.zone model.time)
    minute = String.fromInt (Time.toMinute model.zone model.time)
    second = String.fromInt (Time.toSecond model.zone model.time)
  in
  h1 [] [ text (hour ++ ":" ++ minute ++ ":" ++ second) ]
```

Les nouveaux éléments proviennent tous du paquet [`elm/time`][time]. Passons en revue ces éléments !

[time]: https://package.elm-lang.org/packages/elm/time/latest/


## `Time.Posix` et `Time.Zone`

Pour bien travailler avec le temps en programmation, nous avons besoin de trois concepts différents :

- **Le temps humain** &mdash; C'est ce que vous voyez sur les horloges (8h du matin) ou sur les calendriers (3 mai). Super ! Mais si mon appel téléphonique est à 8 heures du matin à Boston, quelle heure est-il pour mon ami à Vancouver ? S'il est à 8 heures à Tokyo, est-ce que c'est le même jour à New York ? (Non !) Donc, entre les [fuseaux horaires][tz] basés sur des frontières politiques en constante évolution et l'utilisation incohérente de l'[heure d'été][dst], le temps humain ne devrait jamais être stocké dans votre `Model` ou votre base de données ! Il ne sert qu'à l'affichage !


- **Le temps POSIX** &mdash; Avec le temps POSIX, l'endroit où vous vivez ou la période de l'année n'ont pas d'importance. Il s'agit simplement du nombre de secondes écoulées depuis un moment arbitraire (en 1970). Où que vous alliez sur Terre, le temps POSIX est le même.


- **Fuseaux horaires** &mdash; Un fuseau horaire (_time zone_) est un ensemble de données qui vous permet de transformer le temps POSIX en temps humain. Ce n'est _pas_ juste `UTC-7` ou `UTC+3` cependant ! Les fuseaux horaires sont bien plus compliqués qu'un simple décalage ! Chaque fois que [la Floride passe en heure d'été pour toujours][floride] ou que [les Samoa passent de UTC-11 à UTC+13][samoa], une pauvre âme ajoute une note à la [base de données des fuseaux horaires de l'IANA][iana]. Cette base de données est chargée sur chaque ordinateur, et entre l'heure POSIX et tous les cas particuliers de la base de données, il devient possible de calculer l'heure humaine !


Donc pour montrer une heure à un être humain, vous devez toujours connaître `Time.Posix` et `Time.Zone`. Et c'est tout ! Donc, tous ces trucs de "temps humain" sont pour la fonction `view`, pas pour le `Model`. En fait, vous pouvez le voir dans notre `view` :

```elm
view : Model -> Html Msg
view model =
  let
    hour   = String.fromInt (Time.toHour   model.zone model.time)
    minute = String.fromInt (Time.toMinute model.zone model.time)
    second = String.fromInt (Time.toSecond model.zone model.time)
  in
  h1 [] [ text (hour ++ ":" ++ minute ++ ":" ++ second) ]
```

La fonction [`Time.toHour`][toHour] prend `Time.Zone` et `Time.Posix` et nous renvoie un `Int` de `0` à `23` indiquant l'heure qu'il est dans _votre_ fuseau horaire.

Il y a beaucoup plus d'informations sur la gestion des temps dans le README de [`elm/time`][time]. Lisez-le absolument avant d'en faire plus avec la gestion du temps ! Surtout si vous travaillez avec des planifications, des calendriers, etc.


[tz]: https://fr.wikipedia.org/wiki/Fuseau_horaire
[dst]: https://fr.wikipedia.org/wiki/Heure_d%27%C3%A9t%C3%A9
[iana]: https://fr.wikipedia.org/wiki/Tz_database
[samoa]: https://en.wikipedia.org/wiki/Time_in_Samoa
[florida]: https://www.npr.org/sections/thetwo-way/2018/03/08/591925587/
[toHour]: https://package.elm-lang.org/packages/elm/time/latest/Time#toHour


## `subscriptions`

Ok, mais comment obtenir notre `Time.Posix` ? Avec une **souscription** !



```elm
subscriptions : Model -> Sub Msg
subscriptions model =
  Time.every 1000 Tick
```

Nous utilisons la fonction [`Time.every`][every] :

[every]: https://package.elm-lang.org/packages/elm/time/latest/Time#every

```elm
every : Float -> (Time.Posix -> msg) -> Sub msg
```

Elle prend deux arguments :

1. Un interval de temps en millisecondes. Nous spécifions `1000` qui signifie chaque seconde. Mais nous pourrions aussi spécifier `60 * 1000` pour chaque minute ou `5 * 60 * 1000` pour chaque cinq minutes.
2. Un fonction qui transforme le temps actuel en `Msg`. Ainsi, chaque seconde, le temps actuel va être transformé en un `Tick <time>` pour notre fonction `update`.

C'est le fonctionnement de base de n'importe quelle souscription. Vous donnez une configuration et vous décrivez comment produite des valeurs de type `Msg`. Pas si mal !


## `Task.perform`

Obtenir `Time.Zone` est un peu plus compliqué. Notre programme a créé une **commande** avec :

```elm
Task.perform AdjustTimeZone Time.here
```

Parcourir la documentation de [`Task`][task] est la meilleure façon de comprendre cette ligne. Les documentations sont écrites pour expliquer les nouveaux concepts, et je pense que ce serait une trop grande digression que d'inclure une moindre version de cette information ici. L'idée est simplement que nous commandons au runtime de nous donner le `Time.Zone` où que le code soit exécuté.

[utc]: https://package.elm-lang.org/packages/elm/time/latest/Time#utc
[task]: https://package.elm-lang.org/packages/elm/core/latest/Task


> **Exercices:**
>
> - Ajouter un bouton pour mettre l'horloge en pause, en désactivant l'abonnement `Time.every`.
> - Rendre l'horloge numérique plus jolie. Peut-être ajouter quelques attributs [`style`][style].
> - Utilisez [`elm/svg`][svg] pour créer une horloge analogique avec une trotteuse rouge !

[style]: https://package.elm-lang.org/packages/elm/html/latest/Html-Attributes#style
[svg]: https://package.elm-lang.org/packages/elm/svg/latest/
