#!/bin/bash

set -e


## DOWNLOAD ELM AND UGLIFYJS

if ! [ -x elm ]; then
  curl -L -o elm.gz https://github.com/elm/compiler/releases/download/0.19.1/binary-for-linux-64-bit.gz
  gunzip elm.gz
  chmod +x elm
fi
if ! [ -x node_modules/.bin/uglifyjs ]; then
  npm install uglify-js
fi


## GENERATE JAVASCRIPT

./elm make src/Repl.elm --optimize --output=elm.js

./node_modules/.bin/uglifyjs elm.js --compress "pure_funcs=[F2,F3,F4,F5,F6,F7,F8,F9,A2,A3,A4,A5,A6,A7,A8,A9],pure_getters,keep_fargs=false,unsafe_comps,unsafe" \
  | ./node_modules/.bin/uglifyjs --mangle --output assets/repl.js

echo "Initial size: $(cat elm.js | wc -c) bytes"
echo "Minified size:$(cat assets/repl.js | wc -c) bytes"
echo "Gzipped size: $(cat assets/repl.js | gzip -c | wc -c) bytes"

rm elm.js


## ADD WRAPPER (SET UP PORTS)

cat <<EOF >> assets/repl.js
;require(["gitbook"], function(gitbook) {

    gitbook.events.bind("page.change", function()
    {
        var nodes = gitbook.state.\$book[0].getElementsByClassName("elm-repl");
        // must go through backwards because the nodes array is modified
        // if any nodes no longer have that class name. It is pretty nuts!
        for (var i = nodes.length; i--; )
        {
            init(i, nodes[i]);
        }
    });

    function init(id, node)
    {
        var repl = Elm.Repl.init({
            node: node,
            flags: {
                id: id,
                types: node.className.indexOf('show-types') !== -1,
                entries: JSON.parse(node.textContent)
            }
        });

        repl.ports.evaluate.subscribe(evaluate);

        function evaluate(javascript)
        {
            var url = URL.createObjectURL(new Blob([javascript], { mime: "application/javascript" }));
            var worker = new Worker(url);

            worker.onmessage = function(e) { report(e.data) };
            worker.onerror = function(e) { report(e.message) };

            function report(value)
            {
                repl.ports.outcomes.send(value);
                URL.revokeObjectURL(url);
                worker.terminate();
            }
        }
    }

});
EOF
