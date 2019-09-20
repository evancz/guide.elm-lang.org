#!/bin/bash

set -e


## OVERRIDE FAVICON

cp favicon.ico _book/gitbook/images/favicon.ico


## BUILD REPL

(cd repl ; npm link ; bash build.sh)


## BUILD BOOK

npm install gitbook-cli@2.3.2
./node_modules/.bin/gitbook install
npm link gitbook-plugin-elm-repl
sed -i 's/"youtube"/"youtube","elm-repl"/' package.json
./node_modules/.bin/gitbook build


