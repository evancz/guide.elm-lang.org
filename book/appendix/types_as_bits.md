# Types as Bits

There are all sorts of types in Elm:

- `Bool`
- `Int`
- `String`
- `(Int, Int)`
- `Maybe Int`
- ...

We have a conceptual understanding of them by now, but how are they understood by a computer? How is `Maybe Int` stored on a hard disk?


## Bits

A **bit** is little box that has two states. Zero or a one. On or off. Computer memory is one super long sequence of bits.

Okay, so all we have is a bunch of bits. Now we need to represent _everything_ with that!


## `Bool`

A `Bool` value can be either `True` or `False`. This corresponds exactly to a bit!


## `Int`

An `Int` value is some whole number like `0`, `1`, `2`, etc. You cannot fit that in a single bit, so the only other option is to use multiple bits. So normally, an `Int` would be a sequence of bits, like these:

```
00000000
00000001
00000010
00000011
...
```

We can arbitrarily assign meaning to each of these sequences. So maybe `00000000` is zero and `00000001` is one. Great! We can just start assigning numbers to bit sequences in ascending order. But eventually we will run out of bits...

By some quick math, eight bits only allow (2^8 = 256) numbers. What about perfectly reasonable numbers like 9000 and 8004?

The answer is to just add more bits. For a long time, people used 32 bits. That allowed for (2^32 = 4,294,967,296) numbers which covers the kinds of numbers humans typically think about. Computers these days support 64-bit integers, allowing for (2^64 = 18,446,744,073,709,551,616) numbers. That is a lot!

> **Note:** If you are curious how addition works, learn about [two’s complement](https://en.wikipedia.org/wiki/Two%27s_complement). It reveals that numbers are not assigned to bit sequences arbitrarily. For the sake of making addition as fast as possible, this particular way of assigning numbers works really well.


## `String`

The string `"abc"` is the sequence of characters `a` `b` `c`, so we will start by trying to represent characters as bits.

One of the early ways of encoding characters is called [ASCII](https://en.wikipedia.org/wiki/ASCII). Just like with integers, they decided to list out a bunch of bit sequences and start assigning values arbitrarily:

```
00000000
00000001
00000010
00000011
...
```

So every character needed to fit in eight bits, meaning only 256 characters could be represented! But if you only care about English, this actually works out pretty well. You need to cover 26 lower-case letters, 26 upper-case letters, and 10 numbers. That is 62. There is a bunch of room left for symbols and other weird stuff. You can see what they ended up with [here](https://ascii.cl/).

We have an idea for characters now, but how will the computer know where the `String` ends and the next piece of data begins? It is all just bits. Characters look just like `Int` values really! So we need some way to mark the end.

These days, languages tend to do this by storing the **length** of the string. So a string like `"hello"` might look something like `5` `h` `e` `l` `l` `o` in memory. So you know a `String` always starts with 32-bits representing the length. And whether the length is 0 or 9000, you know exactly where the characters end.

> **Note:** At some point, folks wanted to cover languages besides English. This effort eventually resulted in the [UTF-8](https://en.wikipedia.org/wiki/UTF-8) encoding. It is quite brilliant really, and I encourage you to learn about it. It turns out that “get the 5th character” is harder than it sounds!


## `(Int, Int)`

What about tuples? Well, `(Int, Int)` is two `Int` values, and each one is a sequence of bits. Let’s just put those two sequences next to each other in memory and call it a day!


## Custom Types

A custom type is all about combining different types. Those different types may have all sorts of different shapes. We will start with the `Color` type:

```elm
type Color = Red | Yellow | Green
```

We can assign each case a number: `Red = 0`, `Yellow = 1`, and `Green = 2`. Now we can use the `Int` representation. Here we only need two bits to cover all the possible cases, so `00` is red, `01` is yellow, `10` is green, and `11` is unused.

But what about custom types that hold additional data? Like `Maybe Int`? The typical approach is to set aside some bits to “tag” the data, so we can decide that `Nothing = 0` and `Just = 1`. Here are some examples:

- `Nothing` = `0`
- `Just 12` = `1` `00001100`
- `Just 16` = `1` `00010000`

A `case` expression always looks at that “tag” before deciding what to do next. If it sees a `0` it knows there is no more data. If it sees a `1` it knows it is followed by a sequence of bits representing the data.

This “tag” idea is similar to putting the length at the beginning of `String` values. The values may be different sizes, but the code can always figure out where they start and end.


## Summary

Eventually, all values need to be represented in bits. This page gives a rough overview of how that actually works.

Normally there is no real reason to think about this, but I found it to be helpful in deepening my understanding of custom types and `case` expressions. I hope it is helpful to you as well!

> **Note:** If you think this is interesting, it may be fun to learn more about garbage collection. I have found [The Garbage Collection Handbook](http://gchandbook.org/) to be an excellent resource on the topic!