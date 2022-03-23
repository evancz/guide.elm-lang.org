# Valeurs aléatoires

Jusqu'à présent, nous n'avons vu que des commandes pour effectuer des requêtes HTTP, mais nous pouvons commander d'autres choses également, comme générer des valeurs aléatoires ! Nous allons donc créer une application qui lance des dés et produit un nombre aléatoire entre 1 et 6.

Cliquez sur le bouton bleu "Edit" pour voir cet exemple en action. Générez quelques nombres aléatoires, et regardez le code pour essayer de comprendre comment cela fonctionne. **Cliquez sur le bouton bleu maintenant !**

<div class="edit-link"><a href="https://elm-lang.org/examples/numbers">Edit</a></div>

```elm
import Browser
import Html exposing (..)
import Html.Events exposing (..)
import Random



-- MAIN


main =
  Browser.element
    { init = init
    , update = update
    , subscriptions = subscriptions
    , view = view
    }



-- MODEL


type alias Model =
  { dieFace : Int
  }


init : () -> (Model, Cmd Msg)
init _ =
  ( Model 1
  , Cmd.none
  )



-- UPDATE


type Msg
  = Roll
  | NewFace Int


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Roll ->
      ( model
      , Random.generate NewFace (Random.int 1 6)
      )

    NewFace newFace ->
      ( Model newFace
      , Cmd.none
      )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none



-- VIEW


view : Model -> Html Msg
view model =
  div []
    [ h1 [] [ text (String.fromInt model.dieFace) ]
    , button [ onClick Roll ] [ text "Roll" ]
    ]
```

La nouveauté ici est la commande émise dans la fonction `update` :

```elm
Random.generate NewFace (Random.int 1 6)
```

La génération de valeurs aléatoires fonctionne un peu différemment que dans des langages comme JavaScript, Python, Java, etc. Voyons donc comment cela fonctionne dans Elm !


## Générateurs aléatoires

Nous utilisons le paquet [`elm/random`][readme] pour cela. Le module [`Random`][random] en particulier.

[readme]: https://package.elm-lang.org/packages/elm/random/latest
[random]: https://package.elm-lang.org/packages/elm/random/latest/Random


L'idée de base est que nous avons un `Generator` aléatoire qui décrit _comment_ générer une valeur aléatoire. Par exemple :

```elm
import Random

probability : Random.Generator Float
probability =
  Random.float 0 1

roll : Random.Generator Int
roll =
  Random.int 1 6

usuallyTrue : Random.Generator Bool
usuallyTrue =
  Random.weighted (80, True) [ (20, False) ]
```

Nous avons donc ici trois générateurs aléatoires. Le générateur `roll` dit qu'il produira un `Int`, et plus précisément, qu'il produira un entier entre `1` et `6` inclus. De même, le générateur `usuallyTrue` dit qu'il produira un `Bool`, et plus précisément, qu'il sera vrai 80% du temps.

En réalité, nous ne sommes pas encore en train de générer les valeurs. Nous décrivons simplement _comment_ les générer. À partir de là, vous pouvez utiliser [`Random.generate`][gen] pour la transformer en commande :

```elm
generate : (a -> msg) -> Generator a -> Cmd msg
```

Lorsque la commande est exécutée, le `Generator` produit une valeur, qui est ensuite transformée en un message pour votre fonction `update`. Ainsi, dans notre exemple, le `Generator` produit une valeur entre 1 et 6, et la transforme en un message comme `NewFace 1` ou `NewFace 4`. C'est tout ce que nous avons besoin de savoir pour obtenir nos lancers de dés aléatoires, mais les générateurs peuvent faire beaucoup plus !

[gen]: https://package.elm-lang.org/packages/elm/random/latest/Random#generate


## Combiner des générateurs

Une fois que nous avons des générateurs simples comme `probability` et `usuallyTrue`, nous pouvons commencer à les assembler avec des fonctions comme [`map3`](https://package.elm-lang.org/packages/elm/random/latest/Random#map3). Imaginons que nous voulions créer une simple machine à sous. Nous pourrions créer un générateur comme celui-ci :

```elm
import Random

type Symbol = Cherry | Seven | Bar | Grapes

symbol : Random.Generator Symbol
symbol =
  Random.uniform Cherry [ Seven, Bar, Grapes ]

type alias Spin =
  { one : Symbol
  , two : Symbol
  , three : Symbol
  }

spin : Random.Generator Spin
spin =
  Random.map3 Spin symbol symbol symbol
```

Nous créons d'abord `Symbol` pour décrire les images qui peuvent apparaître sur la machine à sous. Nous créons ensuite un générateur aléatoire qui génère chaque symbole avec une probabilité égale.


À partir de là, nous utilisons `map3` pour les combiner dans un nouveau générateur `spin`. Il est dit de générer trois symboles et de les combiner en un `Spin`.

Ce qui est important ici est que, à partir de petits blocs de construction, nous pouvons créer un `Generator` qui décrit un comportement assez complexe. Ensuite, dans notre application, il suffit de dire quelque chose comme `Random.generate NewSpin spin`" pour obtenir la prochaine valeur aléatoire.


> **Exercices:** Voici quelques idées pour rendre le code d'exemple de cette page un peu plus intéressant !
>
>   - Au lieu de montrer un nombre, montrez la face du dé sous forme d'image.
>   - Au lieu d'afficher une image de la face d'un dé, utilisez [`elm/svg`][svg] pour la dessiner vous-même.
>   - Créez un dé pondéré avec [`Random.weighted`][weighted].
>   - Ajoutez un deuxième dé et faites-les lancer en même temps.
>   - Faites en sorte que les dés se retournent de manière aléatoire avant de choisir une valeur finale.

[svg]: https://package.elm-lang.org/packages/elm/svg/latest/
[weighted]: https://package.elm-lang.org/packages/elm/random/latest/Random#weighted
