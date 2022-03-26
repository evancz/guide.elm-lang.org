# Les alias de type

Les annotations peuvent devenir très longues, particulièrement si vous avez des [*records*](/bases_du_langage.html#records) contenant de nombreux champs ! C'est pour répondre à ce problème que les *alias* ont été conçus. Un **alias de type** est en quelque sorte un diminutif pour ce dernier, permettant de le référencer en utilisant un nom plus court. Par exemple, vous pourriez créer un alias `User` de cette façon :

```elm
type alias User =
  { name : String
  , age : Int
  }
```

Plutôt que d'écrire explicitement le type explicite du record tout le temps, on peut juste le référencer en utilisant `User`, ce qui nous permet d'écrire des annotations beaucoup plus simples à lire :

```elm
-- AVEC ALIAS

isOldEnoughToVote : User -> Bool
isOldEnoughToVote user =
  user.age >= 18


-- SANS ALIAS

isOldEnoughToVote : { name : String, age : Int } -> Bool
isOldEnoughToVote user =
  user.age >= 18
```

Ces deux déclarations sont équivalentes, mais celle utilisant un alias est plus courte et plus simple à lire. Ici nous utilisons simplement un **alias** en replacement d'un type plus long.


## Modèles

Il est très courant d'utiliser des alias de type quand on crée un modèle. Quand on a étudié l'Architecture Elm, on a vu un modèle de ce type :

```
type alias Model =
  { name : String
  , password : String
  , passwordAgain : String
  }
```

L'utilisation d'un alias de type se révèle particulièrement intéressante à l'heure d'écrire les annotations de nos fonctions `update` et `view`. Écrire `Msg -> Model -> Model` est tellement plus simple et confortable que de recopier la forme exhaustive… En plus, si nous ajoutons ou modifions les champs de notre modèle, nous n'avons pas besoin de mettre à jours nos annotations.


## Constructeurs de record

Quand vous créez un alias de record, cela génère du même coup un **constructeur de record**. Donc si vous définissez un alias de type `User`, on peut commencer à construire les records correspondants comme ceci :

{% replWithTypes %}
[
	{
		"add-type": "User",
		"input": "type alias User = { name : String, age : Int }"
	},
	{
		"input": "User",
		"value": "\u001b[36m<function>\u001b[0m",
		"type_": "String -> Int -> User"
	},
	{
		"input": "User \"Sue\" 58",
		"value": "{ \u001b[37mname\u001b[0m = \u001b[93m\"Sue\"\u001b[0m, \u001b[37mage\u001b[0m = \u001b[95m58\u001b[0m }",
		"type_": "User"
	},
	{
		"input": "User \"Tom\" 31",
		"value": "{ \u001b[37mname\u001b[0m = \u001b[93m\"Tom\"\u001b[0m, \u001b[37mage\u001b[0m = \u001b[95m31\u001b[0m }",
		"type_": "User"
	}
]
{% endreplWithTypes %}

Essayez de créer un autre `User`, puis de créer votre propre alias ⬆️

Notez que l'ordre des arguments passés au constructeur de record correspond à l'ordre des champs dans l'alias de type !

Encore une fois, ceci n'est **valable que pour les records.** Créer des alias pour d'autres types ne fournira pas de constructeur.
