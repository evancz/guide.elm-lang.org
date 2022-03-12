# Interopérabilité avec JavaScript

À ce stade, nous avons étudié **l'Architecture Elm**, les **types**, les **commandes**, les **souscriptions** et installé Elm sur notre machine.

Mais que se passe t-il quand on essaye de s'interfacer avec JavaScript ? Peut-être avons nous besoin d'exploiter une API du navigateur qui n'est pas encore supportée par un paquet Elm ? Ou peut-être désirez-vous embarquer un composant JavaScript dans votre application Elm ? Ce chapitre va mettre en lumière les différents mécanismes d'interopérabilité avec JavaScript :

- Les *[Flags](/interop/flags.html)*
- Les *[Ports](/interop/ports.html)*
- Les *[Custom Elements](/interop/custom_elements.html)*

Avant de plonger dans les détails, nous avons besoin de savoir comment compiler les programmes Elm en JavaScript !

> **Note :** Si vous évaluez Elm dans un cadre professionnel, nous vous invitons à vous assurer que ces trois mécanismes sont à même de couvrir l'ensemble de vos cas d'usage. Vous pouvez étudier ces [exemples](https://github.com/elm-community/js-integration-examples/) qui les mettent en œuvre et demander conseil à [la communauté](https://discourse.elm-lang.org/) en cas de doute.

## Compiler en JavaScript

Par défaut, la commande `elm make` génère un fichier HTML. Si vous lancez :

```bash
elm make src/Main.elm
```

La commande produit un fichier `index.html` que vous pouvez ouvrir dans votre navigateur préféré et utiliser tel quel. En revanche, si vous souhaitez utiliser les capacités d'interopérabilité avec JavaScript, vous aurez besoin de générer un fichier JavaScript :

```bash
elm make src/Main.elm --output=main.js
```

Le fichier `main.js` résultant expose une fonction `Elm.Main.init()`, ce qui vous permet d'écrire votre propre fichier HTML pouvant l'exploiter.

## Intégration dans HTML

Voici le code HTML nécessaire pour charger notre fichier `main.js` dans un navigateur:

```html
<html>
<head>
  <meta charset="UTF-8">
  <title>Main</title>
  <script src="main.js"></script>
</head>

<body>
  <div id="myapp"></div>
  <script>
  var app = Elm.Main.init({
    node: document.getElementById('myapp')
  });
  </script>
</body>
</html>
```

Arrêtons-nous quelques instants sur quelques éléments importants :

- `<head>` - Une ligne charge notre fichier `main.js` compilé. Si vous compilez un module Elm appelé `Main`, vous obtenez une fonction JavaScript `Elm.Main.init()`. Si vous compilez un module Elm appelé `Home`, vous obtiendrez une fonction JavaScript `Elm.Home.init()`, etc.

- `<body>` - Nous avons besoin de procéder à deux opérations ici ; d'abord, nous définissons une balise `<div>` que nous associons à notre programme Elm et qui sera par conséquent notre conteneur applicatif. Peut-être qu'elle est incluse au milieu d'une page HTML beaucoup plus grande, au milieu de plein d'autres éléments ? Pas de problème ! Ensuite, nous avons une balise `<script>` qui initialise notre programme Elm en appelant la fonction `Elm.Main.init()` et en lui passant une référence au conteneur.

Maintenant que nous savons comment intégrer un programme Elm à une page HTML, il est temps d'explorer nos trois mécanismes d'interopérabilité : les *flags*, les *ports* et les *custom elements* !

> **Note :** Notre fichier HTML est tout à fait standard, vous pouvez donc y ajouter tout ce que vous voulez ! Beaucoup de développeurs chargent des ressources JS ou CSS supplémentaires dans la balise `<head>`. Cela signifie qu'il est totalement possible d'écrire vos feuilles de styles CSS à la main, ou de les générer par d'autres biais. Ajoutez `<link rel="stylesheet" href="ma-feuille-de-style.css">` dans la balise `<head>` pour la charger. (Il y a même moyen d'écrire des styles CSS _directement en Elm_, mais c'est un tout autre sujet !)
