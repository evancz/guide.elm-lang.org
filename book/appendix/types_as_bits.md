# Les types sous formes de bits

Il y a plein de sortes de types en Elm :

- `Bool`
- `Int`
- `String`
- `(Int, Int)`
- `Maybe Int`
- ...

Nous en avons une compréhension conceptuelle à présent, mais comment sont-ils compris par un ordinateur ? Comment est-ce que `Maybe Int` est stocké sur le disque dur ?

## Bits

Un **bit** est une petite boite qui a deux états. Zéro ou un. Allumé ou éteint. La mémoire d'un ordinateur est une séquence de bits super longue.

Ok, donc nous avons un gros tas de bits. Maintenant il nous faut _tout_ représenter avec ça !


## `Bool`

Une valeur `Bool` peut être soit `True` ou `False`. Ça correspond exactement à un bit !


## `Int`

Une valeur `Int` est un nombre entier comme `0`, `1`, `2`, etc. On ne peut pas stocker ça dans un seul bit, donc la seule autre solution est d'utiliser plusieurs bits. Donc, normalement, un `Int` serait une séquence de bits, comme ceux-ci :

```
00000000
00000001
00000010
00000011
...
```

Nous pouvons attribuer arbitrairement un sens à chacune de ces séquences. Alors peut-être que `00000000` est zéro et `00000001` est un. Génial ! Nous pouvons simplement commencer à attribuer des numéros aux séquences de bits dans l'ordre croissant. Mais nous finirons par manquer de bits...

Avec un rapide calcul, huit bits n'autorisent que (2^8 = 256) nombres. Qu'en est-il des nombres totalement acceptables comme 9000 et 8004 ?

La réponse est simplement d'ajouter plus de bits. Pendant longtemps, les gens ont utilisé 32 bits. Cela a permis (2^32 = 4 294 967 296) nombres qui couvrent les types de nombres auxquels les humains pensent généralement. De nos jours, les ordinateurs prennent en charge les nombres entiers 64 bits, permettant (2^64 = 18 446 744 073 709 551 616) nombres. C'est beaucoup !

> **Remarque :** Si vous êtes curieux de savoir comment fonctionne l'addition, consultez [le complément à deux](https://fr.wikipedia.org/wiki/Compl%C3%A9ment_%C3%A0_deux). Il explique que les numéros ne sont pas attribués arbitrairement aux séquences de bits. Afin de rendre l'addition aussi rapide que possible, cette façon particulière d'attribuer des nombres fonctionne très bien.

## `String`

La chaîne `"abc"` est la séquence de caractères `a` `b` `c`, nous allons donc commencer par essayer de représenter les caractères sous forme de bits.

L'une des premières méthodes d'encodage des caractères s'appelle [ASCII](https://fr.wikipedia.org/wiki/American_Standard_Code_for_Information_Interchange). Tout comme avec les nombres entiers, ils ont décidé de lister un tas de séquences de bits et de commencer à attribuer des valeurs arbitrairement :


```
00000000
00000001
00000010
00000011
...
```

Ainsi, chaque caractère devait tenir sur huit bits, ce qui signifie que seuls 256 caractères pouvaient être représentés ! Mais si vous ne vous souciez que de l'anglais, cela fonctionne plutôt bien. Vous devez couvrir 26 lettres minuscules, 26 lettres majuscules et 10 chiffres. Ça fait 62. Il reste beaucoup de place pour les symboles et autres trucs bizarres. Vous pouvez voir ce qu'ils ont obtenu [ici](https://ascii.cl/).

On s'est fait une bonne idée pour les caractères, mais comment l'ordinateur saura-t-il où se termine la `String` et où commence la donnée suivante ? Ce ne sont que des bits. Les caractères ressemblent vraiment à des valeurs `Int` ! Nous avons donc besoin d'un moyen de marquer la fin.

De nos jours, les langages ont tendance à le faire en stockant la **longueur** de la chaîne. Ainsi, une chaîne comme `"hello"` pourrait ressembler à `5` `h` `e` `l` `l` `o` en mémoire. Vous savez donc qu'une `String` commence toujours par 32 bits représentant la longueur. Et que la longueur soit 0 ou 9000, vous savez exactement où s'arrêtent les caractères.

> **Remarque :** À un moment donné, les gens ont voulu d'autres langues que l'anglais. Cet effort a finalement abouti au codage [UTF-8](https://fr.wikipedia.org/wiki/UTF-8). C'est vraiment génial en fait, et je vous encourage à en apprendre davantage. Il s'avère que « obtenir le 5e caractère » est plus difficile qu'il n'y paraît !


## `(Int, Int)`

Qu'en est-il des tuples ? Eh bien, `(Int, Int)` correspond à deux valeurs `Int`, et chacune est une séquence de bits. Mettons simplement ces deux séquences l'une à côté de l'autre en mémoire restons-en là !


## Types personnalisés

Un type personnalisé consiste à combiner différents types. Ces différents types peuvent avoir toutes sortes de formes différentes. Nous allons commencer par le type `Couleur` :

```elm
type Couleur = Rouge | Jaune | Vert
```

Nous pouvons attribuer un numéro à chaque cas : `Rouge = 0`, `Jaune = 1` et `Vert = 2`. Nous pouvons maintenant utiliser la représentation `Int`. Ici, nous n'avons besoin que de deux bits pour couvrir tous les cas possibles, donc '00' est rouge, '01' est jaune, '10' est vert et '11' est inutilisé.

Mais qu'en est-il des types personnalisés contenant des données supplémentaires ? Comme `Maybe Int` ? L'approche typique consiste à mettre de côté quelques bits pour "étiqueter" les données, afin que nous puissions décider que "Nothing = 0" et "Just = 1". Voici quelques exemples:


- `Nothing` = `0`
- `Just 12` = `1` `00001100`
- `Just 16` = `1` `00010000`

Une expression `case` regarde toujours cette "étiquette" avant de décider quoi faire ensuite. Si elle voit un `0`, elle sait qu'il n'y a plus de données. Si elle voit un `1`, elle sait qu'il est suivi d'une séquence de bits représentant les données.

Cette idée d'"étiquette" revient à placer la longueur au début des valeurs `String`. Les valeurs peuvent être de tailles différentes, mais le code peut toujours déterminer où elles commencent et se terminent.



## Résumé

Au bout du compte, toutes les valeurs doivent être représentées en bits. Cette page donne un aperçu approximatif de la façon dont cela fonctionne réellement.

Normalement, il n'y a pas vraiment de raison d'y penser, mais j'ai trouvé cela utile pour approfondir ma compréhension des types personnalisés et des expressions `case`. J'espère que cela vous sera également utile !

> **Remarque :** Si vous pensez que cela est intéressant, il peut être amusant d'en savoir plus sur le processus de ["rammasse-miette"](https://fr.wikipedia.org/wiki/Ramasse-miettes_(informatique)). J'ai trouvé que [The Garbage Collection Handbook](http://gchandbook.org/) (en anglais) est une excellente mine d'informations sur le sujet !
