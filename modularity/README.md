# Big Code

No matter what language you are using, front-end code will face the following problems as it grows:

  - **Namespacing** &mdash; Sometimes files just get too big. It makes sense to move functions into multiple files for organization and to avoid name clashes.

  - **Reusing code** &mdash; Sometimes you notice a pattern in two or three places in your code. In *some* of those cases, it may be worthwhile to write a helper that can be configured for each case. Sometimes the complexity introduced by such a move is not worth it though.

  - **Reusing view code** &mdash; Sometimes you want to display data the same way in multiple places. Maybe users should be displayed exactly the same from page to page. This works just like reusing code in Elm!

  - **Reusing *stateful* view code** &mdash; Sometimes you want to display data the same way in multiple places *and* you want the display to be interactive. When designing custom interfaces, this is actually not terribly common for most companies.

With each scenario, there are strategies and patterns that work best. **There is no one-size fits all solution here.** Instead, Elm provides a simple *module system* to help you make the right choice for your particular scenario. We will start digging into that soon!


## Mindset

Elm is different than many languages, especially JavaScript, in that it makes it quite easy to do serious refactors. **When refactoring is easy and low-risk, you need a new mindset for managing large codebases.** My general advice is:

  - **Solve problems as they arise** &mdash; Same as you can start optimizing code to early, you can start modularizing code too early. Since refactoring is easy and reliable in Elm, it makes sense to wait and see how your code grows organically. You may *think* there will be a problem, but it comes out fine. Or you may find a pattern you did not expect. Let your code guide you. The whole point of Elm is that you can organically grow a codebase and have it come out nice!

  - **Prefer the simpler approach** &mdash; When you see a pattern in two or thee places, prefer the solution that is easiest to read and understand. Sometimes a helper function obviously improves things. Other times, the code may be *similar* but not actually the same. Now the helper needs a bunch of configuration arguments. At some point, the code is different *enough* that it is just best to leave them as is because the &ldquo;less redundant&rdquo; version is also harder to understand.

Elm is designed to work well *when you follow this advice*. When you are feeling resistence from the language, it is probably a good sign you are trying to modularize things too early.
