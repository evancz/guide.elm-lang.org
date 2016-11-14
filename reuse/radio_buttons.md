# Radio Buttons

Say you have a website that is primarily about reading, like this guide! You may want to have a way to choose between small, medium, and large fonts so your readers can customize it for their preferences. In that case, you will want some HTML like this:

```html
<fieldset>
  <label><input type="radio">Small</label>
  <label><input type="radio">Medium</label>
  <label><input type="radio">Large</label>
</fieldset>
```

Just like in the checkbox example from the previous page, this will let people choose the one they want, and using `<label>` means they get a much bigger area they can click on. Like always, we start with our `Model`. This one is kind of interesting because we can use [union types](../types/union_types.md) to make it very reliable!

```elm
type alias Model =
  { fontSize : FontSize
  , content : String
  }

type FontSize = Small | Medium | Large
```

This means there are exactly three possible font sizes: `Small`, `Medium`, and `Large`. It is impossible to have any other value in our `fontSize` field. If you are coming from JavaScript, you know their alternative is to use strings or numbers and just hope that there is never a typo or mistake. You *could* use values like that in Elm, but why open yourself up to bugs for no reason?!

> **Note:** You should always be looking for opportunities to use union types in your data. The best way to avoid invalid states is to make them impossible to represent in the first place!

Alright, now we need to `update` our model. In this case we just want to switch between font sizes as the user toggles the radio buttons:

```elm
type Msg
  = SwitchTo FontSize

update : Msg -> Model -> Model
update msg model =
  case msg of
    SwitchTo newFontSize ->
      { model | fontSize = newFontSize }
```

Now we need to describe how to show our `Model` on screen. First let&rsquo;s see the one where we put all our code in one function and repeat ourselves a bunch of times:

```elm
view : Model -> Html Msg
view model =
  div []
    [ fieldset []
        [ label []
            [ input [ type_ "radio", onClick (SwitchTo Small) ] []
            , text "Small"
            ]
        , label []
            [ input [ type_ "radio", onClick (SwitchTo Medium) ] []
            , text "Medium"
            ]
        , label []
            [ input [ type_ "radio", onClick (SwitchTo Large) ] []
            , text "Large"
            ]
        ]
    , section [] [ text model.content ]
    ]
```

That is kind of a mess! The best thing to do is to start making helper functions (not components!). We see some repetition in the radio buttons, so we will start there.

```elm
view : Model -> Html Msg
view model =
  div []
    [ fieldset []
        [ radio (SwitchTo Small) "Small"
        , radio (SwitchTo Medium) "Medium"
        , radio (SwitchTo Large) "Large"
        ]
    , section [] [ text model.content ]
    ]

radio : msg -> String -> Html msg
radio msg name =
  label []
    [ input [ type_ "radio", onClick msg ] []
    , text name
    ]
```

Our `view` function is quite a bit easier to read now. Great!

If that is the only chunk of radio buttons on your page, you are done. But perhaps you have a couple sets of radio buttons. For example, this guide not only lets you set font size, but also color scheme and whether you use a serif or sans-serif font. Each of those can be implemented as a set of radio buttons, so we could do a bit more refactoring, like this:

```elm
view : Model -> Html Msg
view model =
  div []
    [ viewPicker
        [ ("Small", SwitchTo Small)
        , ("Medium", SwitchTo Medium)
        , ("Large", SwitchTo Large)
        ]
    , section [] [ text model.content ]
    ]

viewPicker : List (String, msg) -> Html msg
viewPicker options =
  fieldset [] (List.map radio options)

radio : (String, msg) -> Html msg
radio (name, msg) =
  label []
    [ input [ type_ "radio", onClick msg ] []
    , text name
    ]
```

So if we want to let users choose a color scheme or toggle serifs, the `view` can reuse `viewPicker` for each case. If we do that, we may want to add additional arguments to the `viewPicker` function. If we want to be able to set a class on each `<fieldset>`, we could add an argument like this:

```elm
viewPicker : String -> List (String, msg) -> Html msg
viewPicker pickerClass options =
  fieldset [ class pickerClass ] (List.map radio options)
```

Or if we wanted even more flexibility, we could let people pass in whatever attributes they please, like this:

```elm
viewPicker : List (Attribute msg) -> List (String, msg) -> Html msg
viewPicker attributes options =
  fieldset attributes (List.map radio options)
```

And if we wanted even MORE flexibility, we could let people pass in attributes for each radio button too! There is really no end to what can be configured. You just add a bit more information to an argument.


## Too Much Reuse?

In this case, we saw quite a few ways to write the same code. But which way is the *right* way to do it? A good rule to pick an API is **choose the absolute simplest thing that does everything you need**. Here are some scenarios that test this rule:

  1. There is the only radio button thing on your page. In that case, just make them! Do not worry about making a highly configurable and reusable function for radio buttons. Refactoring is easy in Elm, so wait for a legitimate need before doing that work!

  2. There are a couple radio button things on your page, all with the same styling. That is how the options on this guide look. This is a great case for sharing a view function. You may not even need to change any classes or add any custom attributes. If you do not need that, do not design for it! It is easy to add later.

  3. There are a couple radio button things on your page, but they are very different. You could do an extremely flexible picker that lets you configure everything, but at some point, things that *look* similar are not actually similar enough for this to be worth it. So if you ever find yourself with tons of complex arguments configuring a view function, you may have overdone it on the reuse. I personally would prefer to have two chunks of *similar* view code that are both simple and easy to change than one chunk of view code that is complex and hard to understand.

Point is, there is no magic recipe here. The answer will depend on the particulars of your application, and you should always try to find the simplest approach. Sometimes that means sharing code. Sometimes it means writing *similar* code. It takes practice and experience to get good at this, so do not be afraid to experiment to find simpler ways!
