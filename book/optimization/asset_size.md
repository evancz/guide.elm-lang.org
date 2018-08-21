# Asset Size

The only thing that is slower than touching the DOM is talking to servers. Especially for folks on mobile phones with slow internet. So you can optimize your code all day with `Html.Lazy` and `Html.Keyed`, but your application will still feel slow if it loads slowly!

A great way to improve is to send fewer bits. For example, if a 122kb asset can become a 9kb asset, it will load faster! We get results like that by using the following techniques:

- **Compilation.** The Elm compiler can perform optimizations like dead code elimination and record field renaming. So it can cut unused code and shorten record field names like `userStatus` in the generated code.
- **Minification.** In the JavaScript world, there are tools called “minifiers” that do a bunch of transformations. They shorten variables. They inline. They convert `if` statements to ternary operators. They turn `'\u0041'` to `'A'`. Anything to save a few bits!
- **Compression.** Once you have gotten the code as small as possible, you can use a compression algorithm like gzip to shrink it even further. It does particularly well with keywords like `function` and `return` that you just cannot get rid of in the code itself.

Elm makes it pretty easy to get all this set up for your project. No need for some complex build system. It is just two terminal commands!


## Instructions

Step one is to compile with the `--optimize` flag. This does things like shortening record field names.

Step two is to minify the resulting JavaScript code. I use a minifier called `uglifyjs`, but you can use a different one if you want. The neat thing about `uglifyjs` is all its special flags. These flags unlock optimizations that are unreliable in normal JS code, but thanks to the design of Elm, they are totally safe for us!

Putting those together, we can optimize `src/Main.elm` with two terminal commands:

```bash
elm make src/Main.elm --optimize --output=elm.js
uglifyjs elm.js --compress 'pure_funcs="F2,F3,F4,F5,F6,F7,F8,F9,A2,A3,A4,A5,A6,A7,A8,A9",pure_getters,keep_fargs=false,unsafe_comps,unsafe' | uglifyjs --mangle --output=elm.min.js
```

After this you will have an `elm.js` and a smaller `elm.min.js` file!

> **Note 1:** `uglifyjs` is called twice there. First to `--compress` and second to `--mangle`. This is necessary! Otherwise `uglifyjs` will ignore our `pure_funcs` flag.
>
> **Note 2:** If the `uglifyjs` command is not available in your terminal, you can run the command `npm install uglify-js --global` to download it. If you do not have `npm` either, you can get it with [nodejs](https://nodejs.org/).


## Scripts

It is hard to remember all those flags for `uglifyjs`, so it is probably better to write a script that does this.

Say we want a bash script that produces `elm.js` and `elm.min.js` files. On Mac or Linux, we can define `optimize.sh` like this:

```bash
#!/bin/sh

set -e

js="elm.js"
min="elm.min.js"

elm make --optimize --output=$js $@

uglifyjs $js --compress 'pure_funcs="F2,F3,F4,F5,F6,F7,F8,F9,A2,A3,A4,A5,A6,A7,A8,A9",pure_getters,keep_fargs=false,unsafe_comps,unsafe' | uglifyjs --mangle --output=$min

echo "Compiled size:$(cat $js | wc -c) bytes  ($js)"
echo "Minified size:$(cat $min | wc -c) bytes  ($min)"
echo "Gzipped size: $(cat $min | gzip -c | wc -c) bytes"
```

Now if I run `./optimize.sh src/Main.elm` on my [TodoMVC](https://github.com/evancz/elm-todomvc) code, I see something like this in the terminal:

```
Compiled size:  122297 bytes  (elm.js)
Minified size:   24123 bytes  (elm.min.js)
Gzipped size:     9148 bytes
```

Pretty neat! We only need to send about 9kb to get this program to people!

The important commands here are `elm` and `uglifyjs` which work on any platform, so it should not be too tough to do something similar on Windows.


## Advice

I recommend writing a `Browser.application` and compiling to a single JavaScript file as we have seen here. It will get downloaded (and cached) when people first visit. Elm creates quite small files compared to the popular competitors, as you can see [here](https://elm-lang.org/blog/small-assets-without-the-headache), so this strategy can take you quite far.

> **Note:** In theory, it is possible to get even smaller assets with Elm. It is not possible right now, but if you are working on 50k lines of Elm or more, we would like to learn about your situation as part of a user study. More details [here](https://gist.github.com/evancz/fc6ff4995395a1643155593a182e2de7)!