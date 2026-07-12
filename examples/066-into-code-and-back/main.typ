// Into code and back: a hash (#) drops from markup into a single code
// expression; square brackets [...] inside code drop back into markup.
// Compile with:  typst compile main.typ out.pdf
#set page(width: 12cm, height: auto, margin: 1.5cm)
#set text(size: 12pt)

= Into code and back

This sentence is markup, the mode you have written all book. Type a
hash and Typst reads what follows as one code expression: two plus two
is #(2 + 2), and #upper("shouting") comes back in capitals.

The trip runs the other way too. Inside a code block, square brackets
open a patch of markup called a content block:

#{
  let mood = "sunny"
  [The forecast is *#mood* today.]
}

The `let` line is code; the bracketed line is markup again, with the
code value spliced back in by one more hash. Markup, code, markup ---
you can cross the border as often as you like.
