# JSON

On the next page we are going to ask `api.giphy.com` for some random GIFs. The endpoint [here](https://api.giphy.com/v1/gifs/random?api_key=dc6zaTOxFJmzC&tag=cat) is going to give us JSON like this:

```json
{
  "data": {
    "type": "gif",
    "id": "l2JhxfHWMBWuDMIpi",
    "title": "cat love GIF by The Secret Life Of Pets",
    "image_url": "https://media1.giphy.com/media/l2JhxfHWMBWuDMIpi/giphy.gif",
    "caption": "",
    ...
  },
  "meta": {
    "status": 200,
    "msg": "OK",
    "response_id": "5b105e44316d3571456c18b3"
  }
}
```

But how do we deal with data like this in Elm?

In JavaScript you can run `JSON.parse` and get a JavaScript object. You then start accessing fields like `response.data.image_url` to get the random GIF. One would expect JavaScript Object Notation (JSON) to integrate easily with JavaScript! But what happens if `api.giphy.com` makes a change to the JSON? We crash! What happens if we have a typo in a field access? We crash! What happens if the endpoint is managed by your backend team and it produces different results in different scenarios? We crash!

So turning JSON directly into JavaScript values is easy _at first_, but you pay for it later. Is this `null`? Is this an integer or a string containing an integer? Does this field exist? Etc. You end up with complicated logic, unpredictable behavior, and a bunch of tests to prove to yourself that it cannot be otherwise.

In Elm, we validate JSON _before_ it gets into our code. Let&rsquo;s see how!


## JSON Decoders

Say we have some JSON:

```json
{
	"name": "Tom",
	"age": 42
}
```

We need to run it through a `Decoder` to to access specific information. So if we wanted to get the `"age"`, we would run the JSON through a `Decoder Int` that describes exactly how to access that information:

![](diagrams/int.svg)

If all goes well, we get an `Int` on the other side! And if we wanted the `"name"` we would run the JSON through a `Decoder String` that describes exactly how to access it:

![](diagrams/string.svg)

If all goes well, we get a `String` on the other side!

How do we create decoders like this though?


## Building Blocks

The [`elm/json`][json] package gives us the [`Json.Decode`][decode] module. It is filled with tiny decoders that we can snap together.

[json]: https://package.elm-lang.org/packages/elm/json/latest/
[decode]: https://package.elm-lang.org/packages/elm/json/latest/Json-Decode

So to get `"age"` from `{ "name": "Tom", "age": 42 }` we would create a decoder like this:

```elm
import Json.Decode exposing (Decoder, field, int)

ageDecoder : Decoder Int
ageDecoder =
  field "age" int

 -- int : Decoder Int
 -- field : String -> Decoder a -> Decoder a
```

The [`field`][field] function takes two arguments:

1. `String` &mdash; a field name. So we are demanding an object with an `"age"` field.
2. `Decoder a` &mdash; a decoder to try next. So if the `"age"` field exists, we will try this decoder on the value there.

So putting it together, `field "age" int` is asking for an `"age"` field, and if it exists, it runs the `Decoder Int` to try to extract an integer.

We do pretty much exactly the same thing to extract the `"name"` field:

```elm
import Json.Decode exposing (Decoder, field, string)

nameDecoder : Decoder String
nameDecoder =
  field "name" string

-- string : Decoder String
```

In this case we demand an object with a `"name"` field, and if it exists, we want the value there to be a `String`.

[field]: https://package.elm-lang.org/packages/elm/json/latest/Json-Decode#field


## Nesting Decoders

Remember the `api.giphy.com` data?

```json
{
  "data": {
    "type": "gif",
    "id": "l2JhxfHWMBWuDMIpi",
    "title": "cat love GIF by The Secret Life Of Pets",
    "image_url": "https://media1.giphy.com/media/l2JhxfHWMBWuDMIpi/giphy.gif",
    "caption": "",
    ...
  },
  "meta": {
    "status": 200,
    "msg": "OK",
    "response_id": "5b105e44316d3571456c18b3"
  }
}
```

We wanted to access `response.data.image_url` to show a random GIF. Well, we have the tools now!

```elm
import Json.Decode exposing (Decoder, field, string)

gifDecoder : Decoder String
gifDecoder =
  field "data" (field "image_url" string)
```

Is there a `"data"` field? If so, does that value have an `"image_url"` field? If so, is value there a string?

So we are essentially building up a _contract_ of what we expect. &ldquo;If you give me JSON like this, I will turn them into Elm values.&rdquo;


## Combining Decoders

So far we have only been accessing one field at a time, but what if we want _two_ fields? We snap decoders together with [`map2`](https://package.elm-lang.org/packages/elm/json/latest/Json-Decode#map2):

```elm
map2 : (a -> b -> value) -> Decoder a -> Decoder b -> Decoder value
```

This function takes in two decoders. It tries them both and combines their results. So now we can put together two different decoders:

```elm
import Json.Decode exposing (Decoder, map2, field, string, int)

type alias Person =
  { name : Int
  , age : Int
  }

personDecoder : Decoder Person
personDecoder =
  map2 Person
  	(field "name" string)
  	(field "age" int)
```

So if we used `personDecoder` on `{ "name": "Tom", "age": 42 }` we would get out an Elm value like `Person "Tom" 42`.

If we really wanted to get into the spirit of decoders, we would define `personDecoder` as `map2 Person nameDecoder ageDecoder` using our previous definitions. You always want to be building your decoders up from smaller building blocks!


## Next Steps

There are a bunch of important functions in `Json.Decode` that we did not cover here:

- [`bool`](https://package.elm-lang.org/packages/elm/json/latest/Json-Decode#bool) : `Decoder Bool`
- [`list`](https://package.elm-lang.org/packages/elm/json/latest/Json-Decode#list) : `Decoder a -> Decoder (List a)`
- [`dict`](https://package.elm-lang.org/packages/elm/json/latest/Json-Decode#dict) : `Decoder a -> Decoder (Dict String a)`
- [`oneOf`](https://package.elm-lang.org/packages/elm/json/latest/Json-Decode#oneOf) : `List (Decoder a) -> Decoder a`

So there are ways to extract all sorts of data structures. The `oneOf` function is particularly helpful for messy JSON. (e.g. sometimes you get an `Int` and other times you get a `String` containing digits. So annoying!)

There are also [`map3`](https://package.elm-lang.org/packages/elm/json/latest/Json-Decode#map3), [`map4`](https://package.elm-lang.org/packages/elm/json/latest/Json-Decode#map4), and others for handling objects with more than two fields. But as you start working with larger JSON objects, it is worth checking out [`NoRedInk/elm-json-decode-pipeline`](https://package.elm-lang.org/packages/NoRedInk/elm-json-decode-pipeline/latest). The types there are a bit fancier, but some folks find them much easier to read and work with.


> **Fun Fact:** I have heard a bunch of stories of folks finding bugs in their _server_ code as they switched from JS to Elm. The decoders people write end up working as a validation phase, catching weird stuff in JSON values. So when NoRedInk switched from React to Elm, it revealed a couple bugs in Ruby code!
