> **Note :** Les *types personnalisés* étaient auparavant appelés *union types* en Elm. D'autres noms véhiculant le même concept issus d'autres communautés sont [*tagged unions*](https://en.wikipedia.org/wiki/Tagged_union) et [*ADTs*](https://en.wikipedia.org/wiki/Algebraic_data_type).


# Types personnalisés

Jusqu'ici nous avons vu quelques types comme `Bool`, `Int` et `String`. Mais comment créer nos *propres* types ?

Imaginons un salon de discussion en ligne. Chaque usager a besoin d'un identifiant, mais certains n'ont pas créé de compte et fournissent simplement un identifiant à chaque fois qu'ils se connectent.

Nous pouvons décrire cette situation en définissant un type `UserStatus` listant toutes les variantes possibles :

```elm
type UserStatus = Regular | Visitor
```

Le type `UserStatus` a deux **variantes**. Les usagers peuvent être `Regular` ou `Visitor`. Nous pouvons représenter nos usagers en utilisant un *record*, comme ceci :

```elm
type UserStatus
  = Regular
  | Visitor

type alias User =
  { status : UserStatus
  , name : String
  }

thomas = { status = Regular, name = "Thomas" }
kate95 = { status = Visitor, name = "kate95" }
```

De cette façon, nous pouvons déterminer si nos usagers disposent d'un compte (`Regular`) ou pas (`Visitor`). Ce n'est pas trop compliqué, mais on peut rendre ça encore plus simple !

Plutôt que de créer un type personnalisé *et* un alias de type, on peut représenter l'ensemble au moyen *d'un seul* type personnalisé. Les variantes `Regular` et `Visitor` se voient chacune associée à un identifiant de type `String` :

```elm
type User
  = Regular String
  | Visitor String

thomas = Regular "Thomas"
kate95 = Visitor "kate95"
```

La donnée étant attachée directement à la variante, il n'y a même plus besoin de record.

Un autre avantage de cette approche est que chaque variante peut avoir des données associées de types différents. Admettons qu'on propose à nos usagers `Regular` d'ajouter leur âge à la création de leur compte. Il n'y a pas de moyen évident de modéliser ça avec un record, mais avec un type personnalisé, aucun problème. Ajoutons quelques données spécifiques à notre variante `Regular` :

{% replWithTypes %}
[
  {
    "add-type": "User",
    "input": "type User\n  = Regular String Int\n  | Visitor String\n"
  },
  {
    "input": "Regular",
    "value": "\u001b[36m<function>\u001b[0m",
    "type_": "String -> Int -> User"
  },
  {
    "input": "Visitor",
    "value": "\u001b[36m<function>\u001b[0m",
    "type_": "String -> User"
  },
  {
    "input": "Regular \"Thomas\" 44",
    "value": "\u001b[96mRegular\u001b[0m \u001b[93m\"Thomas\"\u001b[0m \u001b[95m44\u001b[0m",
    "type_": "User"
  },
  {
    "input": "Visitor \"kate95\"",
    "value": "\u001b[96mVisitor\u001b[0m \u001b[93m\"kate95\"\u001b[0m",
    "type_": "User"
  }
]
{% endreplWithTypes %}

Essayez de définir un usager `Regular` avec son identifiant et son âge ⬆️

Nous avons simplement ajouté l'âge, mais les variantes d'un type peuvent diverger de façon encore plus spectaculaire. Par exemple, nous pourrions ajouter la localisation des participants de type `Regular` pour leur proposer des salons régionalisés. Ou peut-être souhaitons-nous permettre l'utilisation de notre salon de façon anonyme. Ajoutez une troisième variante `Anonymous`, afin d'obtenir quelque chose de ce genre :

```elm
type User
  = Regular String Int Location
  | Visitor String
  | Anonymous
```

Aucun souci ! Maintenant, voyons d'autres exemples.


## Messages

Dans le chapitre abordant l'[Architecture Elm](/architecture/), nous avons vu quelques exemples de définition d'un type `Msg`, très courant en Elm. Pour notre salon de discussion, on pourrait définir un type `Msg` comme celui-ci :

```elm
type Msg
  = PressedEnter
  | ChangedDraft String
  | ReceivedMessage { user : User, message : String }
  | ClickedExit
```

Nous avons quatre variantes. Deux d'entre elles n'ont aucune donnée associée, d'autres en ont. Notez que `ReceivedMessage` dispose d'un record associé : c'est tout à fait valide ! On peut associer n'importe quel type à une variante, ce qui permet de décrire les interactions applicatives de façon très précise.


## Modélisation

Les types personnalisés deviennent extrêmement puissants lorsqu'on commence à modéliser les situations très précisément. Par exemple, si vous chargez des données, vous pourriez avoir envie de modéliser l'état d'attente ou les échecs avec un type personnalisé :

```elm
type Profile
  = Failure
  | Loading
  | Success { name : String, description : String }
```

Ici on peut démarrer par `Loading` et transitionner vers `Failure` ou `Success` en fonction de ce qu'il advient. Cela rend triviale l'écriture d'une fonction `view` qui affichera dans tous les cas quelque chose de pertinent en fonction de l'état du chargement des données.

Maintenant que nous savons créer des types personnalisés, la section suivante va nous montrer comment les utiliser !

> **Note : Les types personnalisés sont la fonctionnalité la plus importante de Elm.** Ils apportent énormément de profondeur et de précision dans la modélisation des scénarios applicatifs. Nous avons essayé de détailler un peu de cette profondeur dans les sections [Les types sous forme d'ensembles](/appendix/types_as_sets.html) et [Les types sous forme de bits](/appendix/types_as_bits.html). Nous espérons qu'elles vous seront utiles !
