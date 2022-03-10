#!/bin/bash

set -e


## BUILD REPL

(cd repl ; npm link ; bash build.sh)


## BUILD BOOK

npm install
npm link gitbook-plugin-elm-repl
npm run build


## OVERRIDE FAVICON

cp favicon.ico _book/gitbook/images/favicon.ico
