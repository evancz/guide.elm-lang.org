# Maybe

Plus vous travaillez avec Elm, plus vous verrez le type [`Maybe`][Maybe] employé très fréquemment. Sa définition est celle-ci :

```elm
type Maybe a
  = Just a
  | Nothing

-- Just 3.14 : Maybe Float
-- Just "hi" : Maybe String
-- Just True : Maybe Bool
-- Nothing   : Maybe a
```

C'est un type comportant deux variantes ; soit vous obtenez “juste” une valeur (`Just`), soit vous n'en obtenez aucune (`Nothing`). Le type générique `a` vous permet d'utiliser `Maybe Float` ou `Maybe String` en fonction du besoin.

Cela peut s'avérer très utile dans deux scénarios : les fonctions partielles et les champs optionnels.

[Maybe]: https://package.elm-lang.org/packages/elm-lang/core/latest/Maybe#Maybe


## Fonctions partielles

Parfois vous avez besoin d'une fonction qui renvoie un résultat pour certaines valeurs mais pas pour d'autres. Beaucoup de gens rencontrent ce problèmes avec [`String.toFloat`][toFloat] en essayant de convertir une saisie utilisateur en nombre flottant. Regardons cela :

{% replWithTypes %}
[
  {
    "input": "String.toFloat",
    "value": "\u001b[36m<function>\u001b[0m",
    "type_": "String -> Maybe Float"
  },
  {
    "input": "String.toFloat \"3.1415\"",
    "value": "\u001b[96mJust\u001b[0m \u001b[95m3.1415\u001b[0m",
    "type_": "Maybe Float"
  },
  {
    "input": "String.toFloat \"abc\"",
    "value": "\u001b[96mNothing\u001b[0m",
    "type_": "Maybe Float"
  }
]
{% endreplWithTypes %}

Essayez d'appeler `String.toFloat` avec d'autres chaînes de caractères pour voir ce qui se passe ⬆️

Toutes les chaînes de caractères ne sont pas interpretables comme nombre, ce que modélise cette fonction explicitement. Est-ce que cette chaîne correspond à un nombre ? *Maybe!* (peut-être). Nous pouvons *pattern-matcher* la valeur résultante pour savoir si on a réussi cette conversion ou pas.

> **Exercice :** Nous avons écrit un [petit programme](https://ellie-app.com/bJSMQz9tydqa1) qui permet de convertir des températures exprimées en degrés Celsius vers Fahrenheit. Essayez de refactorer la vue (`view`) de différentes façons. Est-ce que vous arrivez à mettre une bordure rouge autour du champ de saisie lorsque la valeur qu'il contient est invalide ? Pouvez-vous ajouter d'autres conversions ? Fahrenheit en Celsius ? Pouces en Mètres ?

[toFloat]: https://package.elm-lang.org/packages/elm-lang/core/latest/String#toFloat


## Champs optionnels

Une autre utilisation commune de `Maybe` est la gestion des champs optionnels dans les *records*.

Par exemple, imaginons une application de réseau social. Connecter les utilisateurs, gérer leur amitié, … Vous connaissez la chanson. *The Onion*, journal satirique américain, a bien mis en lumière l'un de nos vrais buts cachés dès 2011 : [récolter autant de données personnelles que possible pour la CIA](https://www.theonion.com/cias-facebook-program-dramatically-cut-agencys-costs-1819594988) (article en anglais). Et si nous voulons *toutes* les données de nos utilisateurs, nous avons besoin de les inciter à les fournir graduellement, en ajoutant des fonctionnalités qui les encouragent à partager de plus en plus d'informations personnelles au fil du temps.

Commençons avec un modèle simple pour décrire nos utilisateurs ; ils doivent avoir un *nom*, mais on va rendre le champs *âge* optionnel.

```elm
type alias User =
  { name : String
  , age : Maybe Int
  }
```

Maintenant disons qu'Alice crée un compte, mais décide de ne pas fournir son âge :

```elm
alice : User
alice =
  { name = "Alice", age = Nothing }
```

Du coup, les amis d'Alice ne peuvent pas lui souhaiter un bon anniversaire. On se demande s'ils tiennent _vraiment_ à elle… Peu après, Bernard crée à son tour un profil et *donne* son âge :

```elm
bernard : User
bernard =
  { name = "Bernard", age = Just 24 }
```

Parfait, ça sera vraiment cool le jour de son anniversaire. Mais plus important, Bernard fait désormais partie d'une cohorte démographique très intéressante, pour le plus grand bonheur des annonceurs.

Ok, maintenant que nous avons des utilisateurs, comment pouvons nous essayer de leur vendre de l'alcool sans tomber sous le coup de la loi ? Les gens seraient probablement furieux si on essayait de viser les mineurs, donc assurons-nous de ne pas le faire :

```elm
canBuyAlcohol : User -> Bool
canBuyAlcohol user =
  case user.age of
    Nothing ->
      False

    Just age ->
      age >= 18
```

Notez que le type `Maybe` nous force à pattern matcher l'âge de l'utilisateur. Il est actuellement impossible d'écrire du code qui ne traiterait pas le cas d'un utilisateur dont on ne connaît pas l'âge. Elm le garantit ! Nous pouvons désormais vendre de l'alcool sereinement, certains que nous ne le ferons pas à des mineurs directement. Juste aux majeurs.


## Éviter la surutilisation

Ce type `Maybe` est vraiment pratique, mais il a des limites. Les débutants s'enthousiasment facilement pour `Maybe` et commencent à en mettre partout, alors même qu'un type personnalisé aurait plus de sens.

Par exemple, imaginons une application de fitness dans laquelle on pourrait rivaliser avec nos amis. On commencerait par importer la liste de nos amis, mais on pourrait charger plus d'informations de santé à leur propos plus tard. Vous pourriez être tenté de modéliser ça ainsi :

```elm
type alias Friend =
  { name : String
  , age : Maybe Int
  , height : Maybe Float
  , weight : Maybe Float
  }
```

Toutes les informations sont là, mais vous ne modélisez pas concrètement comment votre application fonctionne. Cela serait plus précis ainsi :

```elm
type Friend
  = Less String
  | More String Info

type alias Info =
  { age : Int
  , height : Float
  , weight : Float
  }
```

Ce nouveau modèle explicite bien mieux la logique applicative sous-jacente.  Il n'y a que deux situations possibles : soit vous avez juste le nom, soit vous avez le nom et tout un tas d'autres informations associées. Dans le code de votre vue, vous ne vous préoccupez plus que de savoir si vous affichez la version `Less` ou `More` d'un profil. Vous n'avez plus à vous poser des questions du type &ldquo;que se passe t-il si j'ai un `age` mais pas de `weight` ?&rdquo;, parce que c'est n'est plus possible avec notre type plus strict !

Retenez simplement que si vous utilisez `Maybe` partout, ça peut valoir le coup d'examiner vos définitions de `type` et `type alias` pour voir si vous ne pourriez pas trouver des représentations plus précises. Ça donne généralement de jolis refactors dans vos udpates et vues !


> ## Aparté : du côté de chez `null`
>
> L'inventeur des références nulles (*`null` references* en anglais), Tony Hoare, les a décrites ainsi:
>
> > Je l’appelle mon erreur à un milliard de dollars. En 1965, je concevais le premier système de typage complet pour un langage orienté objet et je n'ai pas pu résister à ajouter la référence nulle, simplement parce que c'était si facile à implémenter. Ceci a conduit à un nombre incalculable d'erreurs, vulnérabilités, plantages système… qui ont probablement causé des dommages d'un milliard de dollars dans les quarante dernières années.
>
> Cette conception rend les échecs **implicites**. À chaque fois que vous pensez avoir une `String`, vous pouvez tout aussi bien avoir un `null` à la place. Devriez-vous vérifier ? Est-ce que la personne qui vous a fournit cette valeur l'a vérifiée ? Peut-être que ça se passera bien ? Tant pis, on verra plus tard !
>
> Elm évite ce problème complètement en n'implémentant pas `null`. À la place, nous utilisons des types comme `Maybe` pour rendre les cas d'erreur **explicites**. De cette façon, il n'y a jamais de surprises : une `String` est toujours une `String`, et quand vous voyez un `Maybe String`, le compilateur s'assure que les deux variantes — `Just str` et `Nothing` — sont traitées. De cette façon, vous conservez la même flexibilité qu'en utilisant `null`, mais sans les plantages surprise.
