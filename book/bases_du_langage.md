# Bases du langage

Commençons par nous familiariser avec le code Elm !

L'objectif est de vous familiariser avec les **valeurs** et les **fonctions** afin que vous soyez plus confiant dans la lecture du code Elm lorsque nous aborderons des exemples plus importants par la suite.


## Valeurs


Le plus petit bloc de construction dans Elm est appelé une **valeur**. Cela inclut des choses comme `42`, `True`, et `"Hello !"`.

Commençons par regarder les nombres :

{% repl %}
[
	{
		"input": "1 + 1",
		"value": "\u001b[95m2\u001b[0m",
		"type_": "number"
	}
]
{% endrepl %}

Tous les exemples de cette page sont interactifs. Cliquez sur la boîte noire au dessus ⬆️ et le curseur devrait commencer à clignoter. Tapez `2 + 2` et appuyez sur la touche _Entrée_. Le résultat devrait être "4". Vous devriez pouvoir interagir avec tous les exemples de cette page de la même manière !

Essayez de taper des choses comme `30 * 60 * 1000` et `2 ^ 4`. Cela devrait fonctionner comme une calculatrice !

Faire des maths, c'est symapthique, mais c'est étonnamment rare dans la plupart des programmes ! Il est beaucoup plus courant de travailler avec des **chaînes de caractères** comme ceci :


{% repl %}
[
	{
		"input": "\"hello\"",
		"value": "\u001b[93m\"hello\"\u001b[0m",
		"type_": "String"
	},
	{
		"input": "\"butter\" ++ \"fly\"",
		"value": "\u001b[93m\"butterfly\"\u001b[0m",
		"type_": "String"
	}
]
{% endrepl %}


Essayez d'assembler quelques chaînes de caractères avec l'opérateur `(++)` ⬆️

Ces valeurs primitives deviennent plus intéressantes quand on commence à écrire des fonctions pour les transformer !


> **Note:** Vous pouvez en apprendre plus sur les opérateurs comme  [`(+)`](https://package.elm-lang.org/packages/elm/core/latest/Basics#+) et [`(/)`](https://package.elm-lang.org/packages/elm/core/latest/Basics#/) et [`(++)`](https://package.elm-lang.org/packages/elm/core/latest/Basics#++) dans la documentation du module [`Basics`](https://package.elm-lang.org/packages/elm/core/latest/Basics). Ça vaudra la peine de lire toute la documentation de ce paquet à un moment donné !


## Fonctions

Une **fonction** est une manière de transformer des valeurs. Elle prend en entrée une valeur et en produit une autre en sortie.

Par exemple, voici une fonction `greet` qui prend en entrée un et nom et dit bonjour :

{% repl %}
[
	{
		"add-decl": "greet",
		"input": "greet name =\n  \"Hello \" ++ name ++ \"!\"\n",
		"value": "\u001b[36m<function>\u001b[0m",
		"type_": "String -> String"
	},
	{
		"input": "greet \"Alice\"",
		"value": "\u001b[93m\"Hello Alice!\"\u001b[0m",
		"type_": "String"
	},
	{
		"input": "greet \"Bob\"",
		"value": "\u001b[93m\"Hello Bob!\"\u001b[0m",
		"type_": "String"
	}
]
{% endrepl %}

Essayer de dire bonjour à quelqu'un d'autre, comme `"Stokely"` ou `"Kwame"` ⬆️

Les valeurs passées en entrée de la fonction sont généralement appelée **arugments**, on pourrait alors dire que «`greet` est une fonction qui prend un argument ».

Maintenant que la politesse peut être mise de côté, que diriez-vous d'une fonction qui prend _deux_ arguments ?

{% repl %}
[
	{
		"add-decl": "madlib",
		"input": "madlib animal adjective =\n  \"The ostentatious \" ++ animal ++ \" wears \" ++ adjective ++ \" shorts.\"\n",
		"value": "\u001b[36m<function>\u001b[0m",
		"type_": "String -> String -> String"
	},
	{
		"input": "madlib \"cat\" \"ergonomic\"",
		"value": "\u001b[93m\"The ostentatious cat wears ergonomic shorts.\"\u001b[0m",
		"type_": "String"
	},
	{
		"input": "madlib (\"butter\" ++ \"fly\") \"metallic\"",
		"value": "\u001b[93m\"The ostentatious butterfly wears metallic shorts.\"\u001b[0m",
		"type_": "String"
	}
]
{% endrepl %}


Essayez de passer deux arguments à la fonction `madlib` ⬆️

Notez comment nous avons utilisé des parenthèses pour grouper `"butter" ++ "fly"` ensemble dans le deuxième exemple. Chaque argument doit être une valeur primitive comme `"cat"` ou doit obligatoirement se trouver entre parenthèses !

> **Note:** Les personnes venant de langages comme Javascript pourraient être suprises par l'aspect différent qu'ont les foncitons :

>     madlib "cat" "ergonomic"                  -- Elm
>     madlib("cat", "ergonomic")                // JavaScript
>
>     madlib ("butter" ++ "fly") "metallic"      -- Elm
>     madlib("butter" + "fly", "metallic")       // JavaScript
>
> Ça peut paraître surprenant au début, mais ce style permet d'utiliser moins de parenthèses et de virgules. Il donne une sensation de propreté et de minimalisme au langage une fois que vous y êtes habitué !


## Expressions If

Lorsque que l'on veut obtenir un comportement conditionnel en Elm, on utilise une expression `if`.

Faisons une nouvelle fonction `greet` qui respecte à sa juste valeur le président Abraham Lincoln :

{% repl %}
[
	{
		"add-decl": "greet",
		"input": "greet name =\n  if name == \"Abraham Lincoln\" then\n    \"Greetings Mr. President!\"\n  else\n    \"Hey!\"\n",
		"value": "\u001b[36m<function>\u001b[0m",
		"type_": "String -> String"
	},
	{
		"input": "greet \"Tom\"",
		"value": "\u001b[93m\"Hey!\"\u001b[0m",
		"type_": "String"
	},
	{
		"input": "greet \"Abraham Lincoln\"",
		"value": "\u001b[93m\"Greetings Mr. President!\"\u001b[0m",
		"type_": "String"
	}
]
{% endrepl %}

Il y a sûrement d'autres cas à gérer, mais on va dire que c'est suffisant comme ça pour l'instant !


## Listes

Les listes sont une des structures de données les plus courantes en Elm. Elles contiennent une séquence de choses similaires, comme les tableaux en JavaScript

Les listes peuvent contenir plusieurs valeurs. Ces valeurs doivent toutes avoir le même type. Voici quelques exemples qui utilisent des fonctions du module [`List`][list] :

[list]: https://package.elm-lang.org/packages/elm/core/latest/List

{% repl %}
[
	{
		"add-decl": "names",
		"input": "names =\n  [ \"Alice\", \"Bob\", \"Chuck\" ]\n",
		"value": "[\u001b[93m\"Alice\"\u001b[0m,\u001b[93m\"Bob\"\u001b[0m,\u001b[93m\"Chuck\"\u001b[0m]",
		"type_": "List String"
	},
	{
		"input": "List.isEmpty names",
		"value": "\u001b[96mFalse\u001b[0m",
		"type_": "Bool"
	},
	{
		"input": "List.length names",
		"value": "\u001b[95m3\u001b[0m",
		"type_": "String"
	},
	{
		"input": "List.reverse names",
		"value": "[\u001b[93m\"Chuck\"\u001b[0m,\u001b[93m\"Bob\"\u001b[0m,\u001b[93m\"Alice\"\u001b[0m]",
		"type_": "List String"
	},
	{
		"add-decl": "numbers",
		"input": "numbers =\n  [4,3,2,1]\n",
		"value": "[\u001b[95m4\u001b[0m,\u001b[95m3\u001b[0m,\u001b[95m2\u001b[0m,\u001b[95m1\u001b[0m]",
		"type_": "List number"
	},
	{
		"input": "List.sort numbers",
		"value": "[\u001b[95m1\u001b[0m,\u001b[95m2\u001b[0m,\u001b[95m3\u001b[0m,\u001b[95m4\u001b[0m]",
		"type_": "List number"
	},
	{
		"add-decl": "increment",
		"input": "increment n =\n  n + 1\n",
		"value": "\u001b[36m<function>\u001b[0m",
		"type_": "number -> number"
	},
	{
		"input": "List.map increment numbers",
		"value": "[\u001b[95m5\u001b[0m,\u001b[95m4\u001b[0m,\u001b[95m3\u001b[0m,\u001b[95m2\u001b[0m]",
		"type_": "List number"
	}
]
{% endrepl %}

Essayez de construire votre propre liste et d'utiliser des fonction comme `List.length` ⬆️

Et n'oubliez pas : tous les éléments d'une liste doivent avoir le même type !


## Tuples

Les tuples sont un autre type de structure de données utile. Un tuple peut contenir deux ou trois valeurs et chaque valeur peut être de n'importe quel type. Il est classiquement utilisé lorsque l'on veut retourner plus d'une valeur dans une fonction. La fonction suivante prend un nom et retourne un message à l'utilisateur :


{% repl %}
[
	{
		"add-decl": "isGoodName",
		"input": "isGoodName name =\n  if String.length name <= 20 then\n    (True, \"name accepted!\")\n  else\n    (False, \"name was too long; please limit it to 20 characters\")\n",
		"value": "\u001b[36m<function>\u001b[0m",
		"type_": "String -> ( Bool, String )"
	},
	{
		"input": "isGoodName \"Tom\"",
		"value": "(\u001b[96mTrue\u001b[0m, \u001b[93m\"name accepted!\"\u001b[0m)",
		"type_": "( Bool, String )"
	}
]
{% endrepl %}

Ça peu être pratique, mais lorsque les choses commencent à se compliquer, il est souvent préférable d'utiliser des _records_ au lieux des tuples.


## Records

Un _**record**_ peut contenir plusieurs valeurs, et chaque valeur est associée à un nom.

Voici un _record_ qui représente l'économiste britannique John A. Hobson :

{% repl %}
[
	{
		"add-decl": "john",
		"input": "john =\n  { first = \"John\"\n  , last = \"Hobson\"\n  , age = 81\n  }\n",
		"value": "{ \u001b[37mage\u001b[0m = \u001b[95m81\u001b[0m, \u001b[37mfirst\u001b[0m = \u001b[93m\"John\"\u001b[0m, \u001b[37mlast\u001b[0m = \u001b[93m\"Hobson\"\u001b[0m }",
		"type_": "{ age : number, first : String, last : String }"
	},
	{
		"input": "john.last",
		"value": "\u001b[93m\"Hobson\"\u001b[0m",
		"type_": "String"
	}
]
{% endrepl %}

Nous avons défini un _record_ avec trois **champs** qui contiennent des informations au sujet du nom et de l'âge de John.

Essayez d'accéder à d'autres champs comme `john.age` ⬆️

Vous pouvez aussi accéder aux champs d'un _record_ en utilisant une « fonction d'accès à un champ » comme ceci :

{% repl %}
[
	{
		"add-decl": "john",
		"input": "john = { first = \"John\", last = \"Hobson\", age = 81 }",
		"value": "{ \u001b[37mage\u001b[0m = \u001b[95m81\u001b[0m, \u001b[37mfirst\u001b[0m = \u001b[93m\"John\"\u001b[0m, \u001b[37mlast\u001b[0m = \u001b[93m\"Hobson\"\u001b[0m }",
		"type_": "{ age : number, first : String, last : String }"
	},
	{
		"input": ".last john",
		"value": "\u001b[93m\"Hobson\"\u001b[0m",
		"type_": "String"
	},
	{
		"input": "List.map .last [john,john,john]",
		"value": "[\u001b[93m\"Hobson\"\u001b[0m,\u001b[93m\"Hobson\"\u001b[0m,\u001b[93m\"Hobson\"\u001b[0m]",
		"type_": "List String"
	}
]
{% endrepl %}

Il est souvent utile de **mettre à jour** les valeurs d'un _record_ :

{% repl %}
[
	{
		"add-decl": "john",
		"input": "john = { first = \"John\", last = \"Hobson\", age = 81 }",
		"value": "{ \u001b[37mage\u001b[0m = \u001b[95m81\u001b[0m, \u001b[37mfirst\u001b[0m = \u001b[93m\"John\"\u001b[0m, \u001b[37mlast\u001b[0m = \u001b[93m\"Hobson\"\u001b[0m }",
		"type_": "{ age : number, first : String, last : String }"
	},
	{
		"input": "{ john | last = \"Adams\" }",
		"value": "{ \u001b[37mage\u001b[0m = \u001b[95m81\u001b[0m, \u001b[37mfirst\u001b[0m = \u001b[93m\"John\"\u001b[0m, \u001b[37mlast\u001b[0m = \u001b[93m\"Adams\"\u001b[0m }",
		"type_": "{ age : number, first : String, last : String }"
	},
	{
		"input": "{ john | age = 22 }",
		"value": "{ \u001b[37mage\u001b[0m = \u001b[95m22\u001b[0m, \u001b[37mfirst\u001b[0m = \u001b[93m\"John\"\u001b[0m, \u001b[37mlast\u001b[0m = \u001b[93m\"Hobson\"\u001b[0m }",
		"type_": "{ age : number, first : String, last : String }"
	}
]
{% endrepl %}

Si vous vouliez prononcer ces expressions à haute voix, vous diriez quelque chose comme cela : « Je veux une nouvelle version de John pour laquelle son nom est Adams », ou « john dont l'âge est 22 ».

Notez que lorsque nous mettons à jour des champs de `john`, nous créons un tout nouveau _record_ : ça n'écrase pas celui qui existe déjà. Elm rend cette opération efficace en partageant le maximum de contenu possible. Si vous mettez à jour un champs sur dix, le nouveau _record_ va partager les neuf valeurs qui n'ont pas été modifiées.

Une fonction pour mettre à jour d'âge ressemblerait à quelque chose comme cela :

{% repl %}
[
	{
		"add-decl": "celebrateBirthday",
		"input": "celebrateBirthday person =\n  { person | age = person.age + 1 }\n",
		"value": "\u001b[36m<function>\u001b[0m",
		"type_": "{ a | age : number } -> { a | age : number }"
	},
	{
		"add-decl": "john",
		"input": "john = { first = \"John\", last = \"Hobson\", age = 81 }",
		"value": "{ \u001b[37mage\u001b[0m = \u001b[95m81\u001b[0m, \u001b[37mfirst\u001b[0m = \u001b[93m\"John\"\u001b[0m, \u001b[37mlast\u001b[0m = \u001b[93m\"Hobson\"\u001b[0m }",
		"type_": "{ age : number, first : String, last : String }"
	},
	{
		"input": "celebrateBirthday john",
		"value": "{ \u001b[37mage\u001b[0m = \u001b[95m82\u001b[0m, \u001b[37mfirst\u001b[0m = \u001b[93m\"John\"\u001b[0m, \u001b[37mlast\u001b[0m = \u001b[93m\"Hobson\"\u001b[0m }",
		"type_": "{ age : number, first : String, last : String }"
	}
]
{% endrepl %}

Mettre à jour les champs des _records_ de cette manière est très courant, nous verrons donc beaucoup d'autres exemples dans la section suivante !
