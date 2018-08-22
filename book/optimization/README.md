# Optimization

There are two major types of optimization in Elm. Optimizing performance and optimizing asset size:

- **Performance** &mdash; The slowest thing in browsers is the DOM. By a huge margin. I have done a lot of profiling to speed up Elm applications, and most things have no noticable impact. Using better data structures? Negligible. Caching the results of computations in my model? Negligible _and_ my code is worse now. The only thing that makes a big difference is using `Html.Lazy` and `Html.Keyed` to do fewer DOM operations.

- **Asset Size** &mdash; Running in browsers means we have to care about download times. The smaller we can get our assets, the faster they load on mobile devices and slow internet connections. This is probably more important than any of the performance optimizations you will do! Fortunately, the Elm compiler does a really good job of making your code as small as possible, so you do not need to do a bunch of work making your code confusing to get decent outcomes here.

Both are important though, so this chapter will go through how this all works!

