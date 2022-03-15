# Gestion d'erreur

Une des principales garanties qu'apporte Elm est que vous n'obtiendrez pas d'erreur à l'exécution ; c'est en partie parce que **Elm traite les erreurs comme des données**. Plutôt que de “planter” notre application, nous modélisons de façon explicite la possibilité d'un échec au moyen du typage. Par exemple, imaginons que nous voulions transformer une saisie utilisateur textuelle en âge. On peut créer un type personnalisé comme celui-ci :

```elm
type MaybeAge
  = Age Int
  | InvalidInput

toAge : String -> MaybeAge
toAge userInput =
  ...

-- toAge "24" == Age 24
-- toAge "99" == Age 99
-- toAge "ZZ" == InvalidInput
```

Quelle que soit la valeur de saisie passée à la fonction `toAge`, elle produira toujours une valeur. Les saisies correctes produisent des valeurs comme `Age 24` ou `Age 39`, tandis que les saisies invalides produisent une valeur `InvalidInput`. Nous pouvons *pattern matcher* ces valeurs afin de nous assurer que l'ensemble des cas sont gérés. Pas de plantage !

Ce genre de situation arrive fréquemment ! Par exemple, peut-être voulez-vous transformer les valeurs d'un certain nombre de champs de saisie utilisateur en `BlogPost`, pour l'enregistrer et le partager. Mais que se passe t-il si l'auteur oublie le titre ? Ou si le contenu du billet est vide ? Nous pouvons tout à fait décrire ces différents scénarios avec un type dédié :

```elm
type MaybePost
  = Post { title : String, content : String }
  | NoTitle
  | NoContent

toPost : String -> String -> MaybePost
toPost title content =
  ...

-- toPost "hi" "sup?" == Post { title = "hi", content = "sup?" }
-- toPost ""   ""     == NoTitle
-- toPost "hi" ""     == NoContent
```

Plutôt que de nous contenter de dire que la saisie est “invalide”, nous décrivons ici chaque situation d'échec. Si nous disposons d'une fonction `viewPreview : MaybePost -> Html msg` pour prévisualiser notre billet, nous pouvons désormais détailler la nature des erreurs rencontrées !

Ce type de situation est extrêmement courant. Il est souvent utile de créer un type personnalisé particulièrement adapté à votre cas, mais pour les cas simples vous pouvez recourir à des types standard comme `Maybe` ou `Result`. Dans la suite de ce chapitre, nous allons les étudier afin d'illustrer comment ils sont à même de traiter vos erreurs comme de la donnée !
