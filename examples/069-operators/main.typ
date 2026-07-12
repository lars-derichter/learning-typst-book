// Operators: arithmetic with precedence, comparisons that return a
// boolean, logical and/or/not, and + as a joiner for strings, arrays,
// and content.  Compile with:  typst compile main.typ out.pdf
#set page(width: 12cm, height: auto, margin: 1.5cm)
#set text(size: 11pt)

= Operators

Arithmetic follows the usual precedence:

- #(3 + 4 * 2) --- times binds tighter than plus
- #((3 + 4) * 2) --- parentheses override it
- #repr(6 / 2) --- division always gives a float, even here

Comparisons return a boolean:

- #(3 < 5), #(3 == 3.0), #(4 != 4)

Logical operators combine booleans with words, not symbols:

- #(true and false), #(true or false), #(not true)

And #raw("+") joins as much as it adds. It glues strings, arrays, and
even content:

- #("Lear" + "ning")
- #repr((1, 2) + (3, 4))
- #([Hello ] + [world])
