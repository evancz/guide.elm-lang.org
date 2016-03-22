# JSON

You will sending lots of JSON in your programs. You use the `Json.Decode` library to convert wild and crazy JSON into nicely structured Elm values.

> **Note:** This conversion doubles as a validation phase. In fact, it has revealed bugs in NoRedInk's *backend* code! If your server is producing unexpected values for JavaScript, the client just gradually crashes as you run into missing fields. In contrast, Elm recognizes JSON values with unexpected structure, so NoRedInk gives a nice explanation to the user and logs the unexpected value. This has actually led to some patches in Ruby code!

