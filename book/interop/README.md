# JavaScript Interop

We have seen quite a bit of Elm so far! We learned **The Elm Architecture**. We learned about **types**. We learned how to interact with the outside world through **commands** and **subscriptions**. Things are going well!

But what happens when you need to do something in JavaScript? Maybe there is a JavaScript library you absolutely need? Maybe you want to embed Elm in an existing JavaScript application? Etc. This chapter will outline all the available options: flags, ports, and custom elements.

Whichever one you use, the first step is to initialize your Elm program.


## Initializing Elm Programs

Running `elm make` produces HTML files by default. So if you say:

```bash
elm make src/Main.elm
```

It produces an `index.html` file that you can just open and start playing with. If you are getting into JavaScript interop, you want to produce JavaScript files instead:

```bash
elm make src/Main.elm --output=main.js
```

This produces a JavaScript file that exposes an `Elm.Main.init` function. So once you have `main.js` you can write your own HTML file that does whatever you want! For example:

```html
<!DOCTYPE HTML>
<html>
<head>
  <meta charset="UTF-8">
  <title>Main</title>
  <link rel="stylesheet" href="whatever-you-want.css">
  <script src="main.js"></script>
</head>

<body>
  <div id="elm"></div>
  <script>
  var app = Elm.Main.init({
    node: document.getElementById('elm')
  });
  </script>
</body>
</html>
```

I want to call attention to a couple important lines here.

**First**, in the `<head>` of the document, you can load whatever you want! In our little example we  loaded a CSS file called `whatever-you-want.css`:

```html
<link rel="stylesheet" href="whatever-you-want.css">
```

Maybe you write CSS by hand. Maybe you generate it somehow. Whatever the case, you can load it and use it in Elm. (There are some great options for specifying your CSS all _within_ Elm as well, but that is a whole other topic!)

**Second**, we have a line to load our compiled Elm code:

```html
<script src="main.js"></script>
```

This will make an object called `Elm` available in global scope. So if you compile an Elm module called `Main`, you will have `Elm.Main` in JavaScript. If you compile an Elm module named `Home`, you will have `Elm.Home` in JavaScript. Etc.

**Third**, in the `<body>` of the document, we run a little bit of JavaScript code to initialize our Elm program:

```html
<div id="elm"></div>
<script>
var app = Elm.Main.init({
  node: document.getElementById('elm')
});
</script>
```

We create an empty `<div>`. We want our Elm program to take over that node entirely. Maybe it is within a larger application, surrounded by tons of other stuff? That is fine!

The `<script>` tag then initializes our Elm program. We grab the `node` we want to take over, and give it to `Elm.Main.init` which starts our program.

Now that we can embed Elm programs in an HTML document, it is time to start exploring the three interop options: flags, ports, and web components!
