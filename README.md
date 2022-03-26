# Une introduction à Elm

Ce dépôt contient une traduction du guide officiel Elm que vous trouverez en anglais [ici](https://guide.elm-lang.org).

La traduction est encore en cours, les contributions sont les bienvenues !

## Installation

### Installer le plugin pour le repl

    cd repl
    sudo npm link
    bash build.sh

### Installer Honkit

Placez-vous à la racine du projet, puis :

    npm install
    npm link gitbook-plugin-elm-repl

## Générer le livre

    npm run build

## Lancer le serveur web

    npm run serve

## Publier sur Github Pages

    npm run deploy

Le site est publié sur [elm-france.github.io/guide.elm-lang.org](https://elm-france.github.io/guide.elm-lang.org/).

Vous pouvez ensuite consulter le livre sur [http://localhost:4000](http://localhost:4000/).
