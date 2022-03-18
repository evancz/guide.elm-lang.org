# Installer Elm

La page précédente nous a montré comment installer un éditeur de code Elm, maintenant il nous faut obtenir un exécutable `elm`. Voici les liens d'installation :

- **Mac** - [installer](https://github.com/elm/compiler/releases/download/0.19.1/installer-for-mac.pkg)
- **Linux** - <a href="https://github.com/elm/compiler/blob/master/installers/linux/README.md" target="_blank">instructions</a>
- **Windows** - [installer](https://github.com/elm/compiler/releases/download/0.19.1/installer-for-windows.exe)

Une fois l'installation effectuée, ouvrez un terminal sur votre ordinateur. Sur Windows, le programme correspondant s'appelle `cmd.exe` ou `Invite de Commande`.

![terminal](images/terminal.png)

Dans le terminal, commencez par naviguer vers votre Bureau :

```bash
# Mac et Linux
cd ~/Desktop

# Windows (remplacez <username> par votre nom d'utilisateur)
cd C:\Users\<username>\Desktop
```

Ensuite, familiarisons-nous avec la commande `elm`. L'utilisation de la ligne de commande est souvent difficile pour les débutants, aussi nous avons beaucoup travaillé à rendre la commande `elm` confortable à utiliser. Regardons quelques cas d'utilisation courants.


<br>

## <span style="font-family:Consolas,'Liberation Mono',Menlo,Courier,monospace;">elm init</span>

Vous pouvez initialiser une nouveau projet Elm de cette façon :

```bash
elm init
```

Lancez cette commande pour créer un fichier `elm.json` et un dossier `src` :

- [`elm.json`](https://github.com/elm/compiler/blob/master/docs/elm.json/application.md) décrit votre projet ;
- `src/` contient tous vos fichiers Elm.

Maintenant, essayons de créer un fichier `src/Main.elm` dans notre éditeur, et d'y copier le code d'[exemple de boutons](https://elm-lang.org/examples/buttons).


<br>

## <span style="font-family:Consolas,'Liberation Mono',Menlo,Courier,monospace;">elm reactor</span>

`elm reactor` vous aide à construire des projets Elm sans avoir à manipuler le terminal trop fréquemment. Vous pouvez simplement lancer la commande à la racine, comme ceci :

```bash
elm reactor
```

La commande démarre un serveur Web local à l'adresse [`http://localhost:8000`](http://localhost:8000), que vous pouvez ouvrir dans votre navigateur préféré. Vous pouvez naviguer au travers des différents fichiers Elm et regarder à quoi ils ressemblent. Lancez `elm reactor`, suivez le lien `localhost` et essayez de contempler votre fichier `src/Main.elm` !


<br>

## <span style="font-family:Consolas,'Liberation Mono',Menlo,Courier,monospace;">elm make</span>

Vous pouvez compiler votre code Elm en HTML ou en JavaScript avec cette famille de commandes :

```bash
# Crée un fichier index.html que vous pouvez ouvrir dans un navigateur.
elm make src/Main.elm

# Crée un fichier js optimisé pour l'appeler depuis un fichier HTML.
elm make src/Main.elm --optimize --output=elm.js
```

Essayez de lancer ces commandes sur votre fichier `src/Main.elm`.

C'est la façon la plus courante de compiler du code Elm. C'est très pratique une fois que vos projets deviennent trop complexes pour `elm reactor`.

Cette commande produit les mêmes messages que vous avez déjà vu en utilisant l'éditeur en ligne ou `elm reactor`. Des années de travail ont été engloutis dans ces outils, mais n'hésitez pas à remonter les messages difficiles à comprendre [ici](https://github.com/elm/error-message-catalog/issues). Nous sommes convaincus qu'ils sont toujours améliorables !


<br>

## <span style="font-family:Consolas,'Liberation Mono',Menlo,Courier,monospace;">elm install</span>

Les paquets Elm sont tous disponibles sur [`package.elm-lang.org`](https://package.elm-lang.org/).

Imaginons qu'on ait besoin de [`elm/http`][http] et [`elm/json`][json] pour faire quelques requêtes HTTP. Nous pouvons les installer au moyen de ces deux commandes :

```bash
elm install elm/http
elm install elm/json
```

La commande a ajouté ces deux dépendances à notre fichier `elm.json`, les rendant disponibles pour notre projet. Cela nous permet d'écrire `import Http` et d'appeler des fonctions comme `Http.get` dans notre code Elm.

[http]: https://package.elm-lang.org/packages/elm/http/latest
[json]: https://package.elm-lang.org/packages/elm/json/latest


<br>

## Trucs et astuces

**D'abord**, ne vous inquiétez surtout pas si vous ne vous souvenez pas de tout par cœur !

Vous pouvez toujours lancez la commande `elm --help` pour avoir la documentation de tout ce que la commande est capable de faire.

Vous pouvez également lancer des commandes comme `elm make --help` ou `elm repl --help` pour accéder à l'aide d'une commande en particulier. C'est très pratique pour découvrir les options disponibles et ce qu'elles permettent.

**Ensuite**, ne vous inquiétez pas si ça prend un peu de temps pour être à l'aise avec l'utilisation de la ligne de commande et du terminal en général.

Même après des années d'expérience, il est fréquent d'oublier comment on compresse un fichier, comment on trouve tous les fichiers Elm dans un répertoire, etc. Il n'est jamais grave de nous rafraîchir la mémoire !

* * *

Maintenant que nous avons installé et configuré notre éditeur, et que la commande `elm` fonctionne dans notre terminal, on peut continuer notre découverte de Elm !
