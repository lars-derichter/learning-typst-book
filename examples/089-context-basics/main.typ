// Context basics. Some values depend on WHERE they sit in the document — the
// current page number, the position on the page. Typst can only give them to
// you inside a `context` expression, once it knows where "here" is. Outside
// `context`, `#counter(page).display()` or `#here()` is an error:
// "can only be used when context is known".
// Compile with:  typst compile main.typ out.pdf
#set page(width: 9cm, height: 6cm, margin: 1cm)

This line reads the same on every page — it depends on nothing.

#context [
  But *this* is page #counter(page).display(), sitting
  #here().position().y from the top edge.
]

#pagebreak()

#context [
  Same source line, new answer: page #counter(page).display(). The `context`
  keyword defers the read until Typst knows which page it is laying out.
]
