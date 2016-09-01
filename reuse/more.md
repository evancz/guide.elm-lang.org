# More

Right now this section gives a brief introduction to **reusable views**. Instead of thinking about components, you create simple functions and configure them by passing in arguments. You can see the most extreme versions of this by checking out the following projects:

  - [`evancz/elm-sortable-table`](https://github.com/evancz/elm-sortable-table)
  - [`thebritican/elm-autocomplete`](https://github.com/thebritican/elm-autocomplete)

The [README]() of `elm-sortable-table` has some nice guidance on how to use APIs like these and why they are designed as they are. You can also watch the API design session where Greg and I figured out an API for `elm-autocomplete` here:

{% youtube %}https://www.youtube.com/watch?v=KSuCYUqY058{% endyoutube %}

We talk through a lot of the design considerations that go into APIs like these. One big takeaway is that you should not expect to do something as elaborate as this for every single thing in your app! As of this writing, NoRedInk has more than 30k lines of Elm and one or two instances where they felt it made sense to design something as elaborate as this.

Hopefully those resources help guide you as you make larger and larger programs!

> **Note:** I plan to fill this section in with more examples of growing your `Model` and `update` functions. It is roughly the same ideas though. If you find yourself repeating yourself, maybe break things out. If a function gets too big, make a helper function. If you see related things, maybe move them to a module. But at the end of the day, it is not a huge deal if you let things get big. Elm is great at finding problems and making refactors easy, so it is not actually a huge deal if you have a bunch of entries in your `Model` because it does not seem better to break them out in some way. I will be writing more about this!