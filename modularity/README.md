# Modularity

Some of the hardest problems in programming are social:

  - How do two people work independently on a single project?
  - How do *teams* of people work on projects that interact?

Elm cannot sort out your interpersonal issues, but it at least helps you draw clear boundaries between *my* work and *your* work.

This is done with Elm&rsquo;s module system. Let&rsquo;s see a couple definitions of the term **module** to get a feel for what this means:

  1. **A module corresponds to an Elm file.** The name of file determines the name of the module, so `src/Feed/Story.elm` would be a module named `Feed.Story`.

  2. **A module is a way of assigning responsibility.** You work on the search box over there and I&rsquo;ll work on displaying profiles over here.

  3. **A module creates a contract between author and user.** For example, the `Dict` library promises you a bunch of dictionary functions, but never leaks any details that pin down the implementation. If I ever find a faster implementation, I can switch and everyone&rsquo;s code just keeps working!

Definitions 1 and 2 are true, but they are ultimately distractions. Splitting your code into different files is worthless if you have not *conceptually* separated things. I have seen many many projects with &ldquo;clear boundaries&rdquo;, but implementation details cross those boundaries so easily that you cannot write anything without looking inside.

In other words, definition 3 is the truly important sense. When you have a great contract, the author and the user can proceed without tripping over each other. The user codes against the contract, while the author provides the implementation. Code can evolve independently. Perhaps most importantly, programmers can get things done without loading the whole project into their brain!

Here is the trouble. **It is very hard to design great contracts.** You must understand what your user needs *and* how to provide that in a way that is simple and nice to use. You must foresee many plausible futures *and* design such that things work well in all of them. This chapter will try to share the outlook and strategies that have helped me get better at this!
