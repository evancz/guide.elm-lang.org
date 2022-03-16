# Types de fonctions

Lorsque vous parcourez des paquets tels que [`elm/core`][core] et [`elm/html`][html], vous verrez certainement des fonctions avec plusieurs flèches. Par exemple :

```elm
String.repeat : Int -> String -> String
String.join : String -> List String -> String
```

Pourquoi tant de flèches ? Qu'est-ce qui se passe ici ?!

[core]: https://package.elm-lang.org/packages/elm/core/latest/
[html]: https://package.elm-lang.org/packages/elm/html/latest/


## Les parenthèses cachées

Cela devient plus clair lorsque vous voyez toutes les parenthèses. Par exemple, il est également valide d'écrire le type de `String.repeat` comme ceci :

```elm
String.repeat : Int -> (String -> String)
```

C'est une fonction qui prend un `Int` et produit ensuite _une autre_ fonction. Voyons cela en action :

{% replWithTypes %}
[
	{
		"input": "String.repeat",
		"value": "\u001b[36m<function>\u001b[0m",
		"type_": "Int -> String -> String"
	},
	{
		"input": "String.repeat 4",
		"value": "\u001b[36m<function>\u001b[0m",
		"type_": "String -> String"
	},
	{
		"input": "String.repeat 4 \"ha\"",
		"value": "\u001b[93m\"hahahaha\"\u001b[0m",
		"type_": "String"
	},
	{
		"input": "String.join",
		"value": "\u001b[36m<function>\u001b[0m",
		"type_": "String -> List String -> String"
	},
	{
		"input": "String.join \"|\"",
		"value": "\u001b[36m<function>\u001b[0m",
		"type_": "List String -> String"
	},
	{
		"input": "String.join \"|\" [\"red\",\"yellow\",\"green\"]",
		"value": "\u001b[93m\"red|yellow|green\"\u001b[0m",
		"type_": "String"
	}
]
{% endreplWithTypes %}

Donc, conceptuellement, **chaque fonction accepte un seul argument.** Elle peut renvoyer une autre fonction qui accepte un argument. Etc. À un moment donné, elle cessera de renvoyer des fonctions.

Nous _pourrions_ toujours mettre les parenthèses pour indiquer que c'est ce qui se passe réellement, mais cela commence à devenir assez lourd lorsque vous avez plusieurs arguments. C'est la même logique que derrière l'écriture `4 * 2 + 5 * 3` au lieu de `(4 * 2) + (5 * 3)`. Cela signifie qu'il y a un peu plus à apprendre, mais c'est tellement courant que cela en vaut la peine.

D'accord, mais à quoi sert cette fonctionnalité à la base ? Pourquoi ne pas faire `(Int, String) -> String` et donner tous les arguments en même temps ?


## Application partielle

C'est assez courant d'utiliser la fonction `List.map` dans les programmes Elm :

```elm
List.map : (a -> b) -> List a -> List b
```

Elle prend deux arguments : une fonction et une liste. À partir de là, elle transforme chaque élément de la liste avec cette fonction. Voici quelques exemples :

- `List.map String.reverse ["part","are"] == ["trap","era"]`
- `List.map String.length ["part","are"] == [4,3]`

Maintenant, rappelez-vous comment `String.repeat 4` avait juste le type `String -> String` ? Eh bien, cela signifie que nous pouvons écrire :

- `List.map (String.repeat 2) ["ha","choo"] == ["haha","choochoo"]`

L'expression `(String.repeat 2)` est une fonction `String -> String`, donc on peut l'utiliser directement. Nul besoin d'écrire `(\str -> String.repeat 2 str)`.

Elm utilise également la convention selon laquelle **la structure des données est toujours le dernier argument** dans l'écosystème. Cela signifie que les fonctions sont généralement conçues avec cette utilisation possible à l'esprit, ce qui en fait une technique assez courante.

Maintenant, il est important de se rappeler que **cela peut être surutilisé !** C'est parfois pratique et clair, mais je trouve qu'il vaut mieux l'utiliser avec modération. Je recommande donc de toujours extraire les fonctions utilitaires à la racine du fichier lorsque les choses deviennent même _un peu_ compliquées. De cette façon, elle a un nom clair, les arguments sont nommés et il est facile de tester cette nouvelle fonction utilitaire. Dans notre exemple, cela signifie créer :

```elm
-- List.map redoublement ["ha","choo"]

redoublement : String -> String
redoublement string =
  String.repeat 2 string
```

Ce cas est vraiment simple, mais (1) il est maintenant plus clair que je m'intéresse au phénomène linguistique connu sous le nom de [redoublement](https://fr.wikipedia.org/wiki/Redoublement_(linguistique)) et (2) ce sera assez facile d'ajouter une nouvelle logique à `redoublement` au fur et à mesure que mon programme évolue. Peut-être qu'il me faudra un [redoublement expressif](https://fr.wikipedia.org/wiki/Redoublement_(linguistique)#Redoublement_expressif) à un moment donné ?

En d'autres termes, **si votre application partielle devient longue, faites-en une fonction utilitaire.** Et si elle est multiligne, elle devrait _absolument_ être transformée en une fonction utilitaire à la racine du fichier ! Ce conseil s'applique également à l'utilisation des fonctions anonymes.

> **Remarque :** Si vous vous retrouvez avec "trop de" fonctions lorsque vous utilisez ce conseil, je vous conseille d'utiliser des commentaires tels que "-- REDOUBLEMENT" pour donner un aperçu des cinq ou dix fonctions suivantes. Comme à la vieille école! Je l'ai montré avec les commentaires `-- UPDATE` et `-- VIEW` dans les exemples précédents, mais c'est une technique générique que j'utilise dans tout mon code. Et si vous craignez que les fichiers ne deviennent trop longs avec ce conseil, je vous recommande de regarder [La vie d'un fichier](https://youtu.be/XpDsk374LDE) (en anglais) !of a File](https://youtu.be/XpDsk374LDE)!


## Pipelines

Elm a également un [opérateur pipe][pipe] qui repose sur une application partielle. Par exemple, supposons que nous ayons une fonction `assainir` pour transformer la saisie de l'utilisateur en nombres entiers :

```elm
-- AVANT
assainir : String -> Maybe Int
assainir input =
  String.toInt (String.trim input)
```

On peut la réécrire de la sorte :

```elm
-- APRÈS
assainir : String -> Maybe Int
assainir input =
  input
    |> String.trim
    |> String.toInt
```

Ainsi, dans ce "pipeline", nous transmettons la saisie à `String.trim`, puis celle-ci est transmise à `String.toInt`.

C'est bien car cela permet une lecture "de gauche à droite" que beaucoup de gens aiment, mais **les pipelines peuvent être surutilisés !** Lorsque vous avez trois ou quatre étapes, le code devient souvent plus clair si vous extrayez une fonction utilitaire à la racine du fichier. De cette sorte, la transformation a un nom. Les arguments sont nommés. Elle a une annotation de type. C'est beaucoup plus auto-documenté de cette façon, et vos coéquipiers et votre futur vous l'apprécieront ! Tester la logique devient également plus facile.

> **Remarque :** Personnellement, je préfère le `AVANT`, mais c'est peut-être simplement parce que j'ai appris la programmation fonctionnelle avec des langages sans pipelines !

[pipe]: https://package.elm-lang.org/packages/elm/core/latest/Basics#|&gt;

