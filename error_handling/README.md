# Error Handling

One of the guarantees of Elm is that you will not see runtime errors in practice. NoRedInk has been using Elm in production for about a year now, and they still have not had one! Like all guarantees in Elm, this comes down to fundamental language design choices. In this case, we are helped by the fact that **Elm treats errors as data.** (Have you noticed we make things data a lot here?)


## Some Historical Context

There are two popular language features that consistently cause unexpected problems. If you have used Java or C or JavaScript or Python or Ruby, you have almost certainly had your code crash because of `null` values or surprise exceptions from someone else's code.

Now these things are extremely familiar to folks, but that does not mean they are good!


### Null

Any time you think you have a `String` you just might have a `null` instead. Should you check? Did the person giving you the value check? Maybe it will be fine? Maybe it will crash your servers? I guess we will find out later!

The inventor, Tony Hoare, has this to say about it:

> I call it my billion-dollar mistake. It was the invention of the null reference in 1965. At that time, I was designing the first comprehensive type system for references in an object oriented language (ALGOL W). My goal was to ensure that all use of references should be absolutely safe, with checking performed automatically by the compiler. But I couldn't resist the temptation to put in a null reference, simply because it was so easy to implement. This has led to innumerable errors, vulnerabilities, and system crashes, which have probably caused a billion dollars of pain and damage in the last forty years.

As we will see soon, the point of `Maybe` is to avoid this problem in a pleasant way.


### Exceptions

Joel Spolsky outlined the issues with exceptions pretty nicely [in the year 2003](http://www.joelonsoftware.com/items/2003/10/13.html). Essentially, code that *looks* fine may actually crash at runtime. Surprise!

The point of `Result` is to make the possibility of failure clear and make sure it is handled appropriately.
