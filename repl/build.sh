#!/bin/bash

set -e


## DOWNLOAD ELM

if ! [ -x ./elm ]; then
  curl -L -o elm.gz https://github.com/elm/compiler/releases/download/0.19.0/binary-for-mac-64-bit.gz
  gunzip elm.gz
  chmod +x elm
fi


## GENERATE JAVASCRIPT

./elm make src/Repl.elm --output=index.js


## ADD WRAPPER (SET UP PORTS)

cat <<EOF >> index.js
;(function(init) {
	var id = 0;

	Elm.Repl.init = function(entries)
	{
		var repl = init({ node: document.currentScript, flags: { id: id++, entries: entries } });

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
})(Elm.Repl.init);
EOF
