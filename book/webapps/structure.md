# Structuring Web Apps

Like I was saying on the previous page, **all modules should be built around a central type.** So if I was making a web app for blog posts, I would start with modules like this:

- `Main`
- `Page.Home`
- `Page.Search`
- `Page.Author`

I would have a module for each page, centered around the `Model` type. Those modules follow The Elm Architecture with the typical `Model`, `init`, `update`, `view`, and whatever helper functions you need. From there, I would just keep growing those modules longer and longer. Keep adding the types and functions you need. If I ever notice that I created a custom type with a couple helper functions, I _might_ move that out into its own module.

Before we see some examples, I want to emphasize an important strategy.


## Do Not Plan Ahead

Notice that my `Page` modules do not make any guesses about the future. I do not try to define modules that can be used in multiple places. I do not try to share any functions. This is on purpose!

Early in my projects, I always have these grand schemes of how everything will fit together. “The pages for editing and viewing posts both care about posts, so I will have a `Post` module!” But as I write my application, I find that only the viewing page should have a publication date. And I actually need to track editing differently to cache data when tabs are closed. And they actually need to be stored a bit differently on servers as a result. Etc. I end up turning `Post` into a big mess to handle all these competing concerns, and it ends up being worse for both pages.

By just starting with pages, it becomes much easier to see when things are **similar**, but not **the same**. The norm in user interfaces! So with editing and viewing posts, it seems plausible that we could end up with an `EditablePost` type and a `ViewablePost` type, each with different structure, helper functions, and JSON decoders. Maybe those types are complex enough to warrant their own module. Maybe not! I would just write the code and see what happens.

This works because the compiler makes it really easy to do huge refactors. If I realize I got something majorly wrong across 20 files, I just fix it.


## Examples

You can see examples of this structure in the following open-source projects:

- [`elm-spa-example`](https://github.com/rtfeldman/elm-spa-example)
- [`package.elm-lang.org`](https://github.com/elm/package.elm-lang.org)


> ## Aside: Culture Shock
>
> Folks coming from JavaScript tend to bring habits, expectations, and anxieties that are specific to JavaScript. They are legitimately important in that context, but they can cause some pretty severe troubles when transferred to Elm.
>
>
> ### Defensive Instincts
>
> In [The Life of a File](https://youtu.be/XpDsk374LDE) I point out some JavaScript Folk Knowledge that leads you astray in Elm:
>
> - ~~**“Prefer shorter files.”**~~ In JavaScript, the longer your file is, the more likely you have some sneaky mutation that will cause a really difficult bug. But in Elm, that is not possible! Your file can be 2000 lines long and that still cannot happen.
> - ~~**“Get architecture right from the beginning.”**~~ In JavaScript, refactoring is extremely risky. In many cases, it is cheaper just to rewrite it from scratch. But in Elm, refactoring is cheap and reliable! You can make changes in 20 different files with confidence.
>
> These defensive instincts are protecting you from problems that do not exist in Elm. Knowing this in your mind is different than knowing it in your gut though, and I have observed that JS folks often feel deeply uncomfortable when they see files pass the 400 or 600 or 800 line mark. **So I encourage you to push your limit on number of lines!** See how far you can go. Try using comment headers, try making helper functions, but keep it all in one file. Having this experience yourself is extremely valuable!
>
>
> ### MVC
>
> Some folks see The Elm Architecture and have the intuition to divide their code into separate modules for `Model`, `Update`, and `View`. Do not do this!
>
> It leads to unclear and debatable boundaries. What happens when `Post.estimatedReadTime` is used in both the `update` and `view` functions? Totally reasonable, but it does not clearly _belong_ to one or the other. Maybe you need a `Utils` module? Maybe it actually is a controller kind of thing? The resulting code tends to be hard to navigate because placing each function is now an [ontological](https://en.wikipedia.org/wiki/Ontology) question, and all of your colleagues have different theories. What is an `estimatedReadTime` really? What is its essence? Estimation? What would Richard think is its essence? Time?
>
> **If you build each module around a type, you rarely run into these kinds of questions.** You have a `Page.Home` module that contains your `Model`, `update`, and `view`. You write helper functions. You add a `Post` type eventually. You add an `estimatedReadTime` function. Maybe someday there are a bunch of helpers about that `Post` type, and maybe it is worth splitting into its own module. With this convention, you end up spending a lot less time considering and reconsidering module boundaries. I find that the code also comes out much clearer.
>
>
> ### Components
>
> Folks coming from React expect everything to be components. **Actively trying to make components is a recipe for disaster in Elm.** The root issue is that components are objects:
>
> - components = local state + methods
> - local state + methods = objects
>
> It would be odd to start using Elm and wonder "how do I structure my application with objects?" There are no objects in Elm! Folks in the community would recommend using custom types and functions instead.
>
> Thinking in terms of components encourages you create modules based on the visual design of your application. “There is a sidebar, so I need a `Sidebar` module.” It would be way easier to just make a `viewSidebar` function and pass it whatever arguments it needs. It probably does not even have any state. Maybe one or two fields? Just put it in the `Model` you already have. If it really is worth splitting out into its own module, you will know because you will have a custom type with a bunch of relevant helper functions!
>
> Point is, writing a `viewSidebar` function **does not** mean you need to create a corresponding `update` and `Model` to go with it. Resist this instinct. **Just write the helper functions you need.**
