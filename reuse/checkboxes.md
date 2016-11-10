# Labeled Checkboxes

Your app will probably have some options people can mess with. If something happens, should you send them an email notification? If they come across a video, should it start playing by itself? That kind of thing. So you will need to create some HTML like this:

```html
<fieldset>
  <label><input type="checkbox" checked>Email Notifications</label>
  <label><input type="checkbox">Video Autoplay</label>
  <label><input type="checkbox">Use Location</label>
</fieldset>
```

That will let people toggle the checkboxes, and using `<label>` means they get a much bigger area they can click on. Let&rsquo;s write an Elm program that manages all this interaction! As always, we will take a guess at our `Model`. We know we need to track the user&rsquo;s settings so we will put them in our model:

```elm
type alias Model =
  { notifications : Bool
  , autoplay : Bool
  , location : Bool
  }
```

From there, we will want to figure out our messages and update function. Maybe something like this:

```elm
type Msg
  = ToggleNotifications
  | ToggleAutoplay
  | ToggleLocation

update : Msg -> Model -> Model
update msg model =
  case msg of
    ToggleNotifications ->
      { model | notifications = not model.notifications }

    ToggleAutoplay ->
      { model | autoplay = not model.autoplay }

    ToggleLocation ->
      { model | location = not model.location }
```

That seems fine. Now to create our view!

```elm
view : Model -> Html Msg
view model =
  fieldset []
    [ label []
        [ input [ type' "checkbox", onClick ToggleNotifications, checked model.notifications ] []
        , text "Email Notifications"
        ]
    , label []
        [ input [ type' "checkbox", onClick ToggleAutoplay, checked model.autoplay ] []
        , text "Video Autoplay"
        ]
    , label []
        [ input [ type' "checkbox", onClick ToggleLocation, checked model.location ] []
        , text "Use Location"
        ]
    ]
```

This is not too crazy, but we are repeating ourselves quite a bit. How can we make our `view` function nicer? If you are coming from JavaScript, your first instinct is probably that we should make a &ldquo;labeled checkbox component&rdquo; but your first instinct is wrong! Instead, we will create a helper function!

```elm
view : Model -> Html Msg
view model =
  fieldset []
    [ checkbox ToggleNotifications "Email Notifications" model.notifications
    , checkbox ToggleAutoplay "Video Autoplay" model.autoplay
    , checkbox ToggleLocation "Use Location" model.location
    ]

checkbox : msg -> String -> Html msg
checkbox msg name value =
  label []
    [ input [ type' "checkbox", onClick msg, checked value ] []
    , text name
    ]
```

Now we have a highly configurable `checkbox` function. It takes three arguments to configure how it works: the message it produces on clicks, some text to show next to the checkbox and the value to determine whether it is checked or not. Now if we decide we want all checkboxes to have a certain `class`, we just add it in the `checkbox` function and it shows up everywhere! This is the essense of **reusable views** in Elm. Create helper functions!


## Comparing Reusable Views to Reusable Components

We now have enough information to do a simple comparison of these approaches. Reusable views have a few major advantages over components:

  - **It is just functions.** We are not doing anything special here. Functions have all the power we need, and they are very simple to create. It is the most basic building block of Elm!

  - **No parent-child communication.** If we had made a &ldquo;checkbox component&rdquo; we would have to figure out how to synchronize the state in the checkbox component with our overall model. &ldquo;That checkbox says notifications are on, but the model says they are off!&rdquo; Maybe we need a Flux store now? By using functions instead, we are able to have reuse in our view *without* disrupting our `Model` or `update`. They work exactly the same as before, no need to touch them!

This means we can always create reusable `view` code without changing our overall architecture or introducing any fancy ideas. Just write smaller functions. That sounds nice, but let&rsquo;s see some more examples to make sure it is true!
