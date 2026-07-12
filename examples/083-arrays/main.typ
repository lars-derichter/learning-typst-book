// Arrays are ordered lists of values, written with parentheses and commas.
// This example builds one and reaches into it: indexing (including from the
// end), slicing, membership, push/pop, and sorting with a key.
// See Chapter 16, "Arrays, dictionaries, and strings".
// Compile with:  typst compile main.typ out.pdf
#set page(width: 12cm, height: auto, margin: 1.5cm)
#set text(font: "Libertinus Serif", size: 11pt)

#let days = ("Mon", "Tue", "Wed", "Thu", "Fri")

There are #days.len() days. The first is #days.first() and the last is
#days.last(). Counting from the end, #days.at(-2) sits just before
#days.at(-1).

The midweek stretch is #days.slice(1, 4).join(", "). Is Wednesday in the
week? #("Wed" in days). Reversed, it reads #days.rev().join(" ").

A one-item array needs the trailing comma: `("x",)` holds
#(("x",).len()) item, while `("x")` is just a string of
#(("x").len()) letter.

#{
  let stack = ("wash", "rinse")
  stack.push("dry")
  let done = stack.pop()
  ["#done" came off the end; #stack.join(" and ") remain on the stack.]
}

Sorted by length, `("kiwi", "fig", "cherry")` becomes
#(("kiwi", "fig", "cherry").sorted(key: w => w.len()).join(", ")).
