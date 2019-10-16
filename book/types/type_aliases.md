# Type Aliases

Type annotations can start to get long. This might be a real problem if you have records with many fields! This is the core motivation for type aliases. A **type alias** is a shorter name for a type. For example, you could create a `User` alias like this:

```elm
type alias User =
  { name : String
  , age : Int
  }
```

Rather than writing the whole record type all the time, we can just say `User` instead. This helps us write type annotations that are easier to read:

```elm
-- WITH ALIAS

isOldEnoughToVote : User -> Bool
isOldEnoughToVote user =
  user.age >= 18


-- WITHOUT ALIAS

isOldEnoughToVote : { name : String, age : Int } -> Bool
isOldEnoughToVote user =
  user.age >= 18
```

These two definitions are equivalent, but the one with a type alias is shorter and easier to read. So all we are doing is making an **alias** for a long type.


## Models

It is extremely common to use type aliases when designing a model. When we were learning about The Elm Architecture, we saw a model like this:

```
type alias Model =
  { name : String
  , password : String
  , passwordAgain : String
  }
```

The main benefit of using a type alias for this is when we write the type annotations for the `update` and `view` functions. Writing `Msg -> Model -> Model` is so much nicer than the fully expanded version! It has the added benefit that we can add fields to our model without needing to change any type annotations.


## Record Constructors

When you create a type alias specifically for a record, it also generates a **record constructor**. So if we define a `User` type alias, we can start building records like this:

{% replWithTypes %}
[
	{
		"add-type": "User",
		"input": "type alias User = { name : String, age : Int }"
	},
	{
		"input": "User",
		"value": "\u001b[36m<function>\u001b[0m",
		"type_": "String -> Int -> User"
	},
	{
		"input": "User \"Sue\" 58",
		"value": "{ \u001b[37mname\u001b[0m = \u001b[93m\"Sue\"\u001b[0m, \u001b[37mage\u001b[0m = \u001b[95m58\u001b[0m }",
		"type_": "User"
	},
	{
		"input": "User \"Tom\" 31",
		"value": "{ \u001b[37mname\u001b[0m = \u001b[93m\"Tom\"\u001b[0m, \u001b[37mage\u001b[0m = \u001b[95m31\u001b[0m }",
		"type_": "User"
	}
]
{% endreplWithTypes %}

Try creating another user or creating a type alias of your own ⬆️

Note that the order of arguments in the record constructor match the order of fields in the type alias!

And again, **this is only for records.** Making type aliases for other types will not result in a constructor.
