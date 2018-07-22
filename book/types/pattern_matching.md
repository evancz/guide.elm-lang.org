# Pattern Matching

On the previous page, we learned how to create [custom types](/types/custom_types.html) with the `type` keyword. Our primary example was a `User` in a chat room:

```elm
type User
  = Regular String
  | Visitor String
```

So we have our custom type, but how do we actually use it?


## `case`

Say we want a `toName` function that decides on a name to show for each `User`. We need to use a `case` expression:

```elm
toName : User -> String
toName user =
  case user of
    Regular name ->
      name

    Visitor name ->
      name
```

The incoming `User` value can come in two different variants. The `case` expression allows us to branch based on which variant we happen to see. Here are some example uses:

```elm
toName (Regular "Thomas") == "Thomas"
toName (Visitor "kate95") == "kate95"
```

And if we try invalid arguments like `toName (Visitar "kate95")` or `toName Anonymous`, the compiler tells us about it immediately. This means many “silly mistakes” can be fixed in seconds, rather than making it to users and costing a lot more time overall.


## Refactoring Support

Say we want to track the age of `Regular` users so we can try to encourage cross-generational discussions in our chat room. We first add that to our custom type:

```elm
type User
  = Regular String Int
  | Visitor String
```

At this point, the compiler will tell us about every single `case` expression that needs to be updated as a result. So for `toName` we might update to:

```elm
toName : User -> String
toName user =
  case user of
    Regular name age ->
      name ++ " (" ++ String.fromInt age ++ ")"

    Visitor name ->
      name
```

I decided that I want to show the age as part of the display name, but maybe it should be displayed some other way. The important point is just that the compiler actively asks you to consider this question!

This is especially helpful when you start refactoring in large codebases. Say you have 20 `case` expressions that handle `User` values. They are scattered throughout a bunch of different files. The files are written and maintained by different people. And say someone adds a `Anonymous` variant to `User`:

```elm
type User
  = Regular String Int
  | Visitor String
  | Anonymous
```

The compiler will inform you about all 20 `case` expressions that need to be updated. You can hop around deciding exactly how to handle `Anonymous` users in each situation.

I feel like this sounds pretty boring, but experientially, it is one of my favorite things about languages like Elm. You change a type and then the compiler helps you methodically make the necessary updates. I find it strangely relaxing. Maybe because I get to focus on the fun programming puzzles, but without the anxiety about forgetting something and spending hours trying to figure out what it was. Unclear!


> **Note:** When refactoring is easy, it changes the dynamics of large projects quite significantly.
>
> Refactors like this are so risky in JavaScript that many people do not even try. Will the tests cover all 20 cases? Probably not. Will you notice all the cases that are not covered? Probably not. What about the cases in code written by your colleagues? Wait, they worked on this code too?! This leads to a (justifiable) preoccupation with getting file structure right from the first day in JavaScript projects.
>
> But when refactoring is easy, it actually works better to make changes as you learn more about the problem. Do not worry about it so much. If you get something wrong, just fix it when you find out. I describe this change in mindset in more detail in [The Life of a File](https://youtu.be/XpDsk374LDE).
