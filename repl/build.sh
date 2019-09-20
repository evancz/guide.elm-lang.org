#!/bin/bash

set -e


## DOWNLOAD ELM

if ! [ -x ./elm ]; then
  curl -L -o elm.gz https://github.com/elm/compiler/releases/download/0.19.0/binary-for-linux-64-bit.gz
  gunzip elm.gz
  chmod +x elm
fi


## GENERATE JAVASCRIPT

./elm make src/Repl.elm --output=assets/repl.js


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
            flags: { id: id, entries: JSON.parse(node.textContent) }
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
