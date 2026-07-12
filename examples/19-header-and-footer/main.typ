// A running header and a footer that carries the page number.
// `#h(1fr)` is a stretchy space that pushes what follows to the right edge;
// two of them center the middle piece.
// Compile with:  typst compile main.typ out.pdf
#set page(
  width: 9cm,
  height: 12cm,
  margin: 1.4cm,
  header: [
    _Field notes_ #h(1fr) Chapter 5
  ],
  footer: context [
    #h(1fr) #counter(page).display() #h(1fr)
  ],
)

= Headers that repeat

The header and footer are content that Typst reprints on every page. Inside
them, `#h(1fr)` eats the leftover horizontal space, so text before it sits
left and text after it sits right.

#lorem(40)

#pagebreak()

#lorem(50)
