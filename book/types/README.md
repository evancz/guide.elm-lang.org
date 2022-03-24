# Types

L’un des points forts de Elm est que **les utilisateurs ne voient pas d’erreurs à l’exécution en pratique**. Cela est rendu possible par le fait que le compilateur Elm analyse votre code source très rapidement afin d’étudier comment les valeurs circulent dans votre programme. Si une valeur peut être utilisée d’une manière invalide, le compilateur vous en informe via un message d’erreur cordial. Cela s’appelle l’*inférence de types*. Le compilateur devine quels *types* de valeurs passent par vos fonctions.

## Un exemple d’inférence de types

Le code suivant définit une fonction `toFullName` qui extrait le nom complet d’une personne sous la forme d’une chaîne de caractères :

```elm
toFullName person =
    person.firstName ++ " " ++ person.lastName

fullName =
    toFullName { fistName = "Hermann", lastName = "Hesse" }
```

Comme en JavaScript ou Python, nous écrivons ici le code sans fioritures. Mais voyez-vous le bug ?

En JavaScript, le code équivalent retourne `"undefined Hesse"`. Il n’y a même pas d’erreur ! Espérons que l’un de vos utilisateurs vous en informera quand il ou elle rencontrera ce bug dans la nature. À l’opposé, le compilateur Elm regarde simplement le code source et vous dit :


```
-- TYPE MISMATCH ---------------------------------------------------------- REPL

The 1st argument to `toFullName` is not what I expect:

3|     toFullName { fistName = "Hermann", lastName = "Hesse" }
                  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
This argument is a record of type:

    { fistName : String, lastName : String }

But `toFullName` needs the 1st argument to be:

    { a | firstName : String, lastName : String }

Hint: Seems like a record field typo. Maybe firstName should be fistName?
elm-france
```

Il constate que `toFullName` reçoit un argument du mauvais *type*. Comme le dit le message d’erreur, quelqu’un a par erreur tapé `fist` au lieu de `first`.

C’est déjà très bien d’avoir un assistant pour de simples erreurs comme celle-ci, mais c’est encore plus précieux quand vous avez des centaines de fichiers et un ensemble de collaborateurs qui travaillent dessus. Quelle que soit la taille et la complexité du projet, le compilateur Elm vérifie que **tout** est correct en se basant simplement sur le code source.

Mieux vous comprendrez les types, plus le compilateur vous assistera efficacement. Continuons à apprendre !
