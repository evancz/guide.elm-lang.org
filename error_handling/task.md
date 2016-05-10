# Tasks

**Work in Progress** - Full docs coming in the next few weeks! Until then, the [docs](http://package.elm-lang.org/packages/elm-lang/core/4.0.0/Task) will give a partial overview.

Tasks make it easy to describe asynchronous operations that may fail, like
HTTP requests or writing to a database. Tons of browser APIs are described as
tasks in Elm:

  * [elm-http][] &mdash; talk to servers
  * [elm-history][] &mdash; navigate browser history
  * [elm-storage][] &mdash; save info in the users browser

[elm-http]: http://package.elm-lang.org/packages/evancz/elm-http/latest/
[elm-history]: https://github.com/TheSeamau5/elm-history/
[elm-storage]: https://github.com/TheSeamau5/elm-storage/

Tasks also work like light-weight threads in Elm, so you can have a bunch of
tasks running at the same time and the [runtime][rts] will hop between them if
they are blocked.

[rts]: https://en.wikipedia.org/wiki/Runtime_system
