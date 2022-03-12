# Custom Elements

Au cours des précédentes pages, nous avons vu :

1. Comment démarrer une application Elm depuis Javascript ;
1. Comment passer des *flags* à l'initialisation de l'application Elm ;
1. Comment gérer la communication entre Elm et JavaScript avec les *ports*.

Mais devinez quoi ? Il existe un autre moyen de faire communiquer ces deux environnements !

Les navigateurs Web supportent de mieux en mieux les [custom elements](https://developer.mozilla.org/fr/docs/Web/Web_Components/Using_custom_elements) (composants Web personnalisés), qui vont s'avérer très utile pour intégrer du JavaScript à nos applications Elm.

Voici un [exemple minimaliste](https://github.com/elm-community/js-integration-examples/tree/master/internationalization) illustrant la façon dont on peut exploiter ces custom elements pour gérer l'internationalisation et la localisation.

## Créer des Custom Elements

Imaginons vouloir traduire des dates mais que cette fonctionnalité n'est pas encore disponible dans un paquet Elm. Peut-être pourrions-nous écrire une fonction JavaScript permettant de le faire :

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

Mais comment utiliser notre fonction en Elm ?! Les navigateurs modernes vous permettent de créer des nouveaux éléments HTML comme ceci :

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

Les éléments remarquables ici sont les fonctions `attributeChangedCallback` et `observedAttributes`, qui sont nécessaires pur intercepter les changements d'attributs intéressants.

En vous assurant de charger ce code JavaScript avant d'initialiser votre application Elm, vous serez capables d'écrire du code Elm de ce type :

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

Maintenant, vous pouvez appeler la fonction `viewDate` dès que vous désirez afficher des dates internationalisées dans vos vues.

Vous pouvez accéder à la version complète de cet exemple [ici](https://github.com/elm-community/js-integration-examples/tree/master/internationalization).


## Plus d'information

Luke a beaucoup plus d'expérience avec les custom elements, et cette [conférence à Elm Europe](https://www.youtube.com/watch?v=tyFe9Pw6TVE) est une excellente introduction !

La documentation autour des custom elements peut être un peu indigeste, mais nous espérons qu'elle restera utile si vous souhaitez commencer à internationaliser très simplement vos applications ou d'embarquer de gros composants React si vous estimez cela nécessaire à votre projet.
