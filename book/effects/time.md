# Time

---
#### [Clone the code](https://github.com/evancz/elm-architecture-tutorial/) or follow along in the [online editor](https://elm-lang.org/examples/time).
---

Now we are going to make a digital clock. (Analog will be an exercise!)

So far we have focused on commands. With the HTTP and randomness examples, we commanded Elm to do specific work immediately, but that is sort of a weird pattern for a clock. We _always_ want to know the current time. This is where **subscriptions** come in!

After you read through the code, we will talk about how we are using the [`elm/time`][time] package here:

[time]: https://package.elm-lang.org/packages/elm/time/latest/

```elm
import Browser
import Html exposing (..)
import Task
import Time



-- MAIN


main =
  Browser.element
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }



-- MODEL


type alias Model =
  { zone : Time.Zone
  , time : Time.Posix
  }


init : () -> (Model, Cmd Msg)
init _ =
  ( Model Time.utc (Time.millisToPosix 0)
  , Task.perform AdjustTimeZone Time.here
  )



-- UPDATE


type Msg
  = Tick Time.Posix
  | AdjustTimeZone Time.Zone



update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Tick newTime ->
      ( { model | time = newTime }
      , Cmd.none
      )

    AdjustTimeZone newZone ->
      ( { model | zone = newZone }
      , Cmd.none
      )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
  Time.every 1000 Tick



-- VIEW


view : Model -> Html Msg
view model =
  let
    hour   = String.fromInt (Time.toHour   model.zone model.time)
    minute = String.fromInt (Time.toMinute model.zone model.time)
    second = String.fromInt (Time.toSecond model.zone model.time)
  in
  h1 [] [ text (hour ++ ":" ++ minute ++ ":" ++ second) ]
```

Let&rsquo;s go through the new stuff.


## `Time.Posix` and `Time.Zone`

To work with time successfully in programming, we need three different concepts:

- **Human Time** &mdash; This is what you see on clocks (8am) or on calendars (May 3rd). Great! But if my phone call is at 8am in Boston, what time is it for my friend in Vancouver? If it is at 8am in Tokyo, is that even the same day in New York? (No!) So between [time zones][tz] based on ever-changing political boundaries and inconsistent use of [daylight saving time][dst], human time should basically never be stored in your `Model` or database! It is only for display!

- **POSIX Time** &mdash; With POSIX time, it does not matter where you live or what time of year it is. It is just the number of seconds elapsed since some arbitrary moment (in 1970). Everywhere you go on Earth, POSIX time is the same.

- **Time Zones** &mdash; A “time zone” is a bunch of data that allows you to turn POSIX time into human time. This is _not_ just `UTC-7` or `UTC+3` though! Time zones are way more complicated than a simple offset! Every time [Florida switches to DST forever][florida] or [Samoa switches from UTC-11 to UTC+13][samoa], some poor soul adds a note to the [IANA time zone database][iana]. That database is loaded onto every computer, and between POSIX time and all the corner cases in the database, we can figure out human times!

So to show a human being a time, you must always know `Time.Posix` and `Time.Zone`. That is it! So all that “human time” stuff is for the `view` function, not the `Model`. In fact, you can see that in our `view`:

```elm
view : Model -> Html Msg
view model =
  let
    hour   = String.fromInt (Time.toHour   model.zone model.time)
    minute = String.fromInt (Time.toMinute model.zone model.time)
    second = String.fromInt (Time.toSecond model.zone model.time)
  in
  h1 [] [ text (hour ++ ":" ++ minute ++ ":" ++ second) ]
```

The [`Time.toHour`][toHour] function takes `Time.Zone` and `Time.Posix` gives us back an `Int` from `0` to `23` indicating what hour it is in _your_ time zone.

There is a lot more info about handling times in the README of [`elm/time`][time]. Definitely read it before doing more with time! Especially if you are working with scheduling, calendars, etc.

[tz]: https://en.wikipedia.org/wiki/Time_zone
[dst]: https://en.wikipedia.org/wiki/Daylight_saving_time
[iana]: https://en.wikipedia.org/wiki/IANA_time_zone_database
[samoa]: https://en.wikipedia.org/wiki/Time_in_Samoa
[florida]: https://www.npr.org/sections/thetwo-way/2018/03/08/591925587/
[toHour]: https://package.elm-lang.org/packages/elm/time/latest/Time#toHour


## `subscriptions`

Okay, well how should we get our `Time.Posix` though? With a **subscription**!

```elm
subscriptions : Model -> Sub Msg
subscriptions model =
  Time.every 1000 Tick
```

We are using the [`Time.every`][every] function:

[every]: https://package.elm-lang.org/packages/elm/time/latest/Time#every

```elm
every : Float -> (Time.Posix -> msg) -> Sub msg
```

It takes two arguments:

1. A time interval in milliseconds. We said `1000` which means every second. But we could also say `60 * 1000` for every minute, or `5 * 60 * 1000` for every five minutes.
2. A function that turns the current time into a `Msg`. So every second, the current time is going to turn into a `Tick <time>` for our `update` function.

That is the basic pattern of any subscription. You give some configuration, and you describe how to produce `Msg` values. Not too bad!


## `Task.perform`

Getting `Time.Zone` is a bit trickier. Our program created a **command** with:

```elm
Task.perform AdjustTimeZone Time.here
```

Reading through the [`Task`][task] docs is the best way to understand that line. The docs are written to actually explain the new concepts, and I think it would be too much of a digression to include a worse version of that info here. The point is just that we command the runtime to give us the `Time.Zone` wherever the code is running.

[utc]: https://package.elm-lang.org/packages/elm/time/latest/Time#utc
[task]: https://package.elm-lang.org/packages/elm/core/latest/Task


> **Exercises:**
>
> - Add a button to pause the clock, turning the `Time.every` subscription off.
> - Make the digital clock look nicer. Maybe add some [`style`][style] attributes.
> - Use [`elm/svg`][svg] to make an analog clock with a red second hand!

[style]: https://package.elm-lang.org/packages/elm/html/latest/Html-Attributes#style
[svg]: https://package.elm-lang.org/packages/elm/svg/latest/
