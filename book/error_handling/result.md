# Result

Le type `Maybe` est très utile pour une fonction pouvant échouer, mais ne nous explique pas *pourquoi* elle a échoué. Imaginez qu'un compilateur ne vous affiche que “`Nothing`” en cas d'erreur au niveau de votre code… Bon courage pour identifier le souci !

C'est en cela que le type [`Result`][Result] est particulièrement utile. Il est défini de cette façon :

```elm
type Result error value
  = Ok value
  | Err error
```

Son but est de fournir des informations supplémentaires en cas de problème. C'est particulièrement utile pour rapporter les erreurs et réagir plus efficacement quand elles surviennent !

[Result]: https://package.elm-lang.org/packages/elm-lang/core/latest/Result#Result


## Rapport d'erreur

Reprenons notre exemple d'application dans laquelle les utilisateurs peuvent renseigner leur âge. On pourrait vérifier que l'âge est valide avec une fonction comme celle-ci :

```elm
isReasonableAge : String -> Result String Int
isReasonableAge input =
  case String.toInt input of
    Nothing ->
      Err "Ce n'est pas un nombre !"

    Just age ->
      if age < 0 then
        Err "Vous n'êtes pas encore né !"

      else if age > 135 then
        Err "Êtes-vous une tortue ?"

      else
        Ok age

-- isReasonableAge "abc" == Err ...
-- isReasonableAge "-13" == Err ...
-- isReasonableAge "24"  == Ok 24
-- isReasonableAge "150" == Err ...
```

Non seulement nous validons l'âge, mais nous pouvons également afficher à nos utilisateurs des messages d'erreur utiles quand ils saisissent n'importe quoi. Ce type de feedback est tout de même bien plus intéressant que `Nothing` !


## Résilience

Le type `Result` peut également vous permettre d'être plus résilient face aux erreurs. Une bonne illustration est le requêtage HTTP. Imaginons vouloir afficher le texte intégral d'_Anna Karénine_ de Léon Tolstoï ; notre requête HTTP retourne un `Result Error String` qui modélise le fait que notre requête peut aboutir et nous retourner une `String` contenant le contenu de l'œuvre, ou échouer de différentes façons :

```elm
type Error
  = BadUrl String
  | Timeout
  | NetworkError
  | BadStatus Int
  | BadBody String

-- Ok "All happy ..." : Result Error String
-- Err Timeout        : Result Error String
-- Err NetworkError   : Result Error String
```

Dans ce type de cas et comme vu précédemment, nous pouvons afficher des messages très explicites, mais nous pouvons aussi essayer d'effectuer une récupération sur incident ! Si nous obtenons un `Timeout`, ça peut valoir le coup d'attendre un peu et retenter la requête. Alors que si nous obtenons une `BadStatus 404`, aucun intérêt puisque la ressource n'existe pas ou plus.

Le chapitre suivant aborde comment effectuer des requêtes HTTP, alors préparez vous à rencontrer les types `Result` et `Error` à nouveau très vite !
