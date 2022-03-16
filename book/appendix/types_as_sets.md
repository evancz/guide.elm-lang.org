# Les types sous formes d'ensembles

Nous avons vu des types primitifs comme `Bool` et `String`. Nous avons créé nos propres types personnalisés comme ceci :

```elm
type Couleur = Rouge | Jaune | Vert
```

L'une des techniques les plus importantes de la programmation Elm consiste à faire en sorte que **les valeurs possibles dans le code** correspondent exactement aux **valeurs valides dans la vie réelle**. Cela ne laisse aucune place aux données invalides, et c'est pourquoi j'encourage toujours les gens à se concentrer sur les types personnalisés et les structures de données.

Dans la poursuite de cet objectif, j'ai trouvé utile de comprendre la relation entre les types et les ensembles. Ça a l'air de venir de loin, mais cela aide vraiment à développer votre compréhension !



## Les ensembles

On peut voir les types comme des ensembles de valeurs.

- `Bool` est l'ensemble `{ True, False }`
- `Couleur` est l'ensemble `{ Rouge, Jaubne, Vert }`
- `Int` est l'ensemble `{ ... -2, -1, 0, 1, 2 ... }`
- `Float` est l'ensemble `{ ... 0.9, 0.99, 0.999 ... 1.0 ... }`
- `String` est l'ensemble `{ "", "a", "aa", "aaa" ... "bonjour" ... }`

Ainsi, lorsque vous dites `x : Bool`, cela revient à dire que `x` est dans l'ensemble `{ True, False }`.


## Cardinalité

Des choses intéressantes se produisent lorsque vous commencez à déterminer le nombre de valeurs dans ces ensembles. Par exemple, l'ensemble `Bool` `{ True, False }` contient deux valeurs. Ainsi, les mathématiciens disent que `Bool` a une [cardinalité](https://fr.wikipedia.org/wiki/Cardinalit%C3%A9) de deux. Donc conceptuellement :

- cardinalité(`Bool`) = 2
- cardinalité(`Couleur`) = 3
- cardinalité(`Int`) = ∞
- cardinalité(`Float`) = ∞
- cardinalité(`String`) = ∞

Cela devient plus intéressant lorsque nous commençons à penser à des types comme `(Bool, Bool)` qui combinent des ensembles.

> **Remarque :** La cardinalité pour `Int` et `Float` est en fait inférieure à l'infini. Les ordinateurs doivent contraindre les nombres dans un nombre fixe de bits (comme décrit [ici](/appendix/types_as_bits.html)) donc c'est plutôt cardinalité(`Int32`) = 2^32 and cardinalité(`Float32`) = 2^32. Au bout du compte, ça fait beaucoup.


## Multiplication (Tuples et Records)

Lorsque vous combinez des types avec des tuples, les cardinalités sont multipliées :

- cardinalité(`(Bool, Bool)`) = cardinalité(`Bool`) × cardinalité(`Bool`) = 2 × 2 = 4
- cardinalité(`(Bool, Couleur)`) = cardinalité(`Bool`) × cardinalité(`Couleur`) = 2 × 3 = 6

Pour vous en assurer, essayez de lister toutes les valeurs possibles de `(Bool, Bool)` et `(Bool, Couleur)`. Correspondent-elles aux chiffres que nous avons prédits ? Et pour `(Couleur, Couleur)` ?

Mais que se passe-t-il lorsque nous utilisons des ensembles infinis comme `Int` et `String` ?

- cardinalité(`(Bool, String)`) = 2 × ∞
- cardinalité(`(Int, Int)`) = ∞ × ∞

Personnellement, j'aime beaucoup l'idée d'avoir deux infinis. Un ne suffisait pas ? Et puis avoir des infinis infinis. N'allons-nous pas en manquer à un moment donné?

> **Remarque :** Jusqu'à présent, nous avons utilisé des tuples, mais les records fonctionnent exactement de la même manière :
>
> - cardinalité(`(Bool, Bool)`) = cardinalité(`{ x : Bool, y : Bool }`)
> - cardinalité(`(Bool, Couleur)`) = cardinalité(`{ active : Bool, color : Color }`)
>
> Et si vous définissez `type Point = Point Float Float` alors cardinalité(`Point`) est équivalent à cardinalité(`(Float, Float)`). Tout n'est que multiplication !


## Addition (types personnalisés)

Lorsque vous déterminez la cardinalité d'un type personnalisé, vous additionnez la cardinalité de chaque variante. Commençons par examiner certains types `Maybe` et `Result` :

- cardinalité(`Result Bool Couleur`) = cardinalité(`Bool`) + cardinalité(`Couleur`) = 2 + 3 = 5
- cardinalité(`Maybe Bool`) = 1 + cardinalité(`Bool`) = 1 + 2 = 3
- cardinalité(`Maybe Int`) = 1 + cardinalité(`Int`) = 1 + ∞

Pour vous persuader que c'est vrai, essayez de lister toutes les valeurs possibles dans les ensembles `Maybe Bool` et `Result Bool Couleur`. Est-ce que cela correspond aux chiffres que nous avons obtenus ?

Voici quelques autres exemples :

```elm
type Hauteur
  = Pouces Int
  | Metres Float

-- cardinalité(Hauteur)
-- = cardinalité(Int) + cardinality(Float)
-- = ∞ + ∞


type Emplacement
  = NullePart
  | QuelquePart Float Float

-- cardinalité(Location)
-- = 1 + cardinalité((Float, Float))
-- = 1 + cardinalité(Float) × cardinalité(Float)
-- = 1 + ∞ × ∞
```

Envisager les types personnalisés de cette manière nous aide à voir quand deux types sont équivalents. Par exemple, `Emplacement` est équivalent à `Maybe (Float, Float)`. Une fois que vous savez cela, lequel devez-vous utiliser ? Je préfère `Emplacement` pour deux raisons :

1. Le code devient plus auto-documenté. Pas besoin de se demander si `Just (1.6, 1.8)` est un emplacement ou une paire de hauteurs.
2. Le module `Maybe` peut exposer des fonctions qui n'ont pas de sens pour mes données particulières. Par exemple, la combinaison de deux emplacements ne devrait probablement pas fonctionner comme `Maybe.map2`. Est-ce qu'un `NullePart` combiné à un `QuelquePart x y` devrait donner `NullePart` ? Ça semble bizarre!

En d'autres termes, j'écris quelques lignes de code qui sont _similaires_ à d'autres lignes de codes, mais cela me donne un niveau de clarté et de contrôle extrêmement précieux pour les grandes bases de code et les équipes.


## On s'en fout ?

Voir les « types comme des ensembles » aide à expliquer une classe importante de bogues : les **données invalides**. Par exemple, imaginons que nous voulons représenter la couleur d'un feu de circulation. L'ensemble des valeurs valides est { rouge, orange, vert } mais comment coder cela ? Voici trois approches différentes :

- `type alias Couleur = String` &mdash; Nous pourrions décider que `"rouge"`, `"orange"`, `"vert"` sont les trois chaînes que nous utiliserons, et que toutes les autres sont des _données invalides_. Mais que se passe-t-il si des données invalides sont produites ? Peut-être que quelqu'un fait une faute de frappe comme `"roug"`. Peut-être que quelqu'un tape `"ROUGE"` à la place. Toutes les fonctions devraient-elles vérifier les arguments de couleur entrants ? Toutes les fonctions devraient-elles avoir des tests pour s'assurer que les résultats de couleur sont valides ? Le problème fondamental est que cardinalité(`Couleur`) = ∞, ce qui signifie qu'il y a (∞ - 3) valeurs invalides. Nous devrons faire beaucoup de vérifications pour nous assurer qu'aucune d'entre elles n'apparaît jamais !

- `type alias Couleur = { rouge : Bool, orange : Bool, vert : Bool }` &mdash; L'idée ici est que l'idée de "rouge" est représentée par `Couleur True False False`. Mais qu'en est-il de `Couleur True True True` ? Qu'est-ce que cela signifie d'être de toutes les couleurs à la fois ? Il s'agit de _données invalides_. Tout comme avec la représentation `String`, nous finissons par écrire des vérifications dans notre code et des tests pour nous assurer qu'il n'y a pas d'erreurs. Dans ce cas, cardinalité(`Color`) = 2 × 2 × 2 = 8, il n'y a donc que 5 valeurs invalides. Il y a certainement moins de façons de se tromper, mais nous devrions encore avoir quelques vérifications et tests.

- `type Couleur = Rouge | Orange | Vert` &mdash; Dans ce cas, les données invalides sont impossibles. cardinalité(`Color`) = 1 + 1 + 1 = 3, correspondant exactement à l'ensemble des trois valeurs dans la vie réelle. Il est donc inutile de vérifier les données de couleur non valides dans notre code ou nos tests. Elles ne peuvent pas exister !

Donc, l'essentiel ici est que **exclure les données non valides rend votre code plus court, plus simple et plus fiable.** En s'assurant que l'ensemble de valeurs _possibles_ dans le code correspond exactement à l'ensemble de valeurs _valides_ dans la vie réelle, de nombreux problèmes disparaissent. C'est un couteau bien aiguisé !

Au fur et à mesure que votre programme change, l'ensemble de valeurs possibles dans le code peut commencer à diverger de l'ensemble de valeurs valides dans la vie réelle. **Je vous recommande fortement de revoir périodiquement vos types pour les faire correspondre à nouveau.** C'est comme remarquer que votre couteau est devenu émoussé, et l'aiguiser avec une pierre à aiguiser. Ce type de maintenance est au cœur de la programmation dans Elm.

**Lorsque vous commencez à penser de cette façon, vous finissez par avoir besoin de moins de tests, tout en ayant un code plus fiable.** Vous commencez à utiliser moins de dépendances, tout en accomplissant les choses plus rapidement. De même, quelqu'un habile avec un couteau n'achètera probablement pas un [SlapChop](https://www.slapchop.com/). Il y a bien sûr une place pour les mixeurs et les robots culinaires, mais elle est plus petite que vous ne le pensez. Personne ne fait de publicité sur la façon dont vous pouvez être indépendant et autosuffisant sans aucun inconvénient sérieux. Il n'y a pas d'argent à se faire dans ce domaine !


> ## Parenthèse sur la conception de langeage
> 
> Considérer les types comme des ensembles de cette manière peut également être utile pour expliquer pourquoi un langage semblerait « facile », « restrictif » ou « prône aux erreurs » pour certaines personnes. Par exemple:
>
> - **Java** &mdash; Il existe des valeurs primitives comme `Bool` et `String`. À partir de là, vous pouvez créer des classes avec un ensemble fixe de champs de différents types. Cela ressemble beaucoup aux enregistrements dans Elm, vous permettant de multiplier les cardinalités. Mais il est assez difficile d'avoir l'addition de cardinalité. Vous pouvez le faire avec le sous-typage, mais c'est un processus assez complexe. Ainsi, là où `Result Bool Couleur` est facile en Elm, c'est assez difficile en Java. Je pense que certaines personnes trouvent Java "restrictif" car concevoir un type avec une cardinalité de 5 est assez difficile, donnant souvent l'impression que cela n'en vaut pas la peine.
>
> - **JavaScript** &mdash; Là encore, il existe des valeurs primitives telles que `Bool` et `String`. De là, vous pouvez créer des objets avec un ensemble dynamique de champs, vous permettant de multiplier les cardinalités. C'est beaucoup plus léger que de créer des classes. Mais tout comme en Java, faire des additions de cardinalités n'est pas particulièrement facile. Par exemple, vous pouvez simuler `Maybe Int` avec des objets comme `{ tag: "just", value: 42 }` et `{ tag: "nothing" }`, mais c'est dans les faits une multiplication de cardinalité. Il est donc assez difficile de faire correspondre exactement l'ensemble de valeurs valides dans la vie réelle. Je pense donc que les gens trouvent JavaScript "facile" car concevoir un type avec cardinalité (∞ × ∞ × ∞) est super facile et cela peut convenir à peu près à tout, mais d'autres le trouvent "prône aux erreurs" car concevoir un type avec cardinalité 5 n'est pas vraiment possible, laissant beaucoup de place pour les données invalides.
>
> Fait intéressant, certains langages impératifs ont des types personnalisés ! Rust en est un excellent exemple. Ils les appellent [enums](https://doc.rust-lang.org/book/second-edition/ch06-01-defining-an-enum.html) pour profiter des habitudes que les gens peuvent avoir de C et Java. Ainsi, en Rust, l'ajout de cardinalités est aussi simple que en Elm, et cela apporte les mêmes avantages !
>
> Je pense que le point ici est que « l'addition » de types est extraordinairement sous-estimée en général, et penser aux « types comme des ensembles » aide à clarifier pourquoi certaines conceptions de langages peuvent produire certaines frustrations.
