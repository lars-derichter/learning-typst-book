// Markup meets code: a five-line loop that writes its own content.
// Compile with:  typst compile main.typ out.pdf
#set page(width: 12cm, height: auto, margin: 1.5cm)
#set text(size: 12pt)

= Powers of two

Typst is also a small programming language. This list wasn't typed out by
hand — a loop generated it:

#for n in range(1, 11) [
  / $2^#n$: #calc.pow(2, n)
]

Change the `11` to `101` and you'd get a hundred rows without touching the
list itself. That is the whole idea of the book: content and computation in
the same file.
