# Custom Elements

On the last few pages, we have seen (1) how to start Elm programs from JavaScript, (2) how to pass data in as flags on initialization, and (3) how to send messages between Elm and JS with ports. But guess what people? There is another way to do interop!

Browsers seem to be supporting [custom elements](https://developer.mozilla.org/en-US/docs/Web/Web_Components/Using_custom_elements) more and more, and that turns out to be quite helpful for embedding JS into Elm programs.

Here is a [minimal example](https://github.com/elm-community/js-integration-examples/tree/master/internationalization) of how to use custom elements to do some localization and internationalization.


## Creating Custom Elements

Say we want to localize dates, but that is not accessible in Elm core packages yet. Maybe you want to write a function that localizes dates:

```javascript
//
//   localizeDate('sr-RS', 12, 5) === "петак, 1. јун 2012."
//   localizeDate('en-GB', 12, 5) === "Friday, 1 June 2012"
//   localizeDate('en-US', 12, 5) === "Friday, June 1, 2012"
//
function localizeDate(lang, year, month)
{
	const dateTimeFormat = new Intl.DateTimeFormat(lang, {
		weekday: 'long',
		year: 'numeric',
		month: 'long',
		day: 'numeric'
	});

	return dateTimeFormat.format(new Date(year, month));
}
```

But how do we use that in Elm?! Newer browsers allow you to create new types of DOM nodes like this:

```javascript
//
//   <intl-date lang="sr-RS" year="2012" month="5">
//   <intl-date lang="en-GB" year="2012" month="5">
//   <intl-date lang="en-US" year="2012" month="5">
//
customElements.define('intl-date',
	class extends HTMLElement {
		// things required by Custom Elements
		constructor() { super(); }
		connectedCallback() { this.setTextContent(); }
		attributeChangedCallback() { this.setTextContent(); }
		static get observedAttributes() { return ['lang','year','month']; }

		// Our function to set the textContent based on attributes.
		setTextContent()
		{
			const lang = this.getAttribute('lang');
			const year = this.getAttribute('year');
			const month = this.getAttribute('month');
			this.textContent = localizeDate(lang, year, month);
		}
	}
);
```

The most important parts here are `attributeChangedCallback` and `observedAttributes`. You need some logic like that to detect changes to the attributes you care about.

Load that before you initialize your Elm code, and you will be able to write code like this in Elm:

```elm
import Html exposing (Html, node)
import Html.Attributes (attribute)

viewDate : String -> Int -> Int -> Html msg
viewDate lang year month =
  node "intl-date"
    [ attribute "lang" lang
    , attribute "year" (String.fromInt year)
    , attribute "month" (String.fromInt month)
    ]
    []
```

Now you can call `viewDate` when you want access to that kind of localized information in your `view`.

You can check out the full version of this example [here](https://github.com/elm-community/js-integration-examples/tree/master/internationalization).


## More Info

Luke has a lot more experience with custom elements, and I think his Elm Europe talk is an excellent introduction!

{% youtube %} https://www.youtube.com/watch?v=tyFe9Pw6TVE {% endyoutube %}

Docs on custom elements can be kind of confusing, but I hope this is enough for people to get started embedding simple logic for `Intl` or even large React widgets if that seems like the right choice for your project.
