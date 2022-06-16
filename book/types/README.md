# Types

One of Elm's major benefits is that **users do not see runtime errors in practice**. This is possible because the Elm compiler can analyze your source code very quickly to see how values flow through your program. If a value can ever be used in an invalid way, the compiler tells you about it with a friendly error message. This is called *type inference*. The compiler figures out what *type* of values flow in and out of all your functions.

## An Example of Type Inference

The following code defines a `toFullName` function which extracts a person’s full name as a string:

```elm
toFullName person =
  person.firstName ++ " " ++ person.lastName

fullName =
  toFullName { fistName = "Hermann", lastName = "Hesse" }
```

Like in JavaScript or Python, we just write the code with no extra clutter. Do you see the bug though?

In JavaScript, the equivalent code spits out `"undefined Hesse"`. Not even an error! Hopefully one of your users will tell you about it when they see it in the wild. In contrast, the Elm compiler just looks at the source code and tells you:

```
-- TYPE MISMATCH ---------------------------------------------------------------
The 1st argument to `toFullName` is not what I expect:

4|   toFullName { fistName = "Hermann", lastName = "Hesse" }
                ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
This argument is a record of type:

    { fistName : String, lastName : String }

But `toFullName` needs the 1st argument to be:

    { a | firstName : String, lastName : String }

Hint: Seems like a record field typo. Maybe firstName should be fistName?

Hint: Can more type annotations be added? Type annotations always help me give
more specific messages, and I think they could help a lot in this case!
```

It sees that `toFullName` is getting the wrong *type* of argument. Like the hint in the error message says, someone accidentally wrote `fist` instead of `first`.

It is great to have an assistant for simple mistakes like this, but it is even more valuable when you have hundreds of files and a bunch of collaborators making changes. No matter how big and complex things get, the Elm compiler checks that *everything* fits together properly just based on the source code.

The better you understand types, the more the compiler feels like a friendly assistant. So let's start learning more!
