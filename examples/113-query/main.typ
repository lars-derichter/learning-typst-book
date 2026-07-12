// `query` reaches into the document and hands back the elements that
// match a selector. Here it finds every heading and builds a contents
// list by hand, reading each heading's page number from the page counter.
// See Chapter 21, "Advanced layout".
// Compile with:  typst compile main.typ out.pdf
#set page(width: 12cm, height: 9cm, margin: 1.5cm, numbering: "1")
#set heading(numbering: "1.")

#align(center)[*Contents*]

#context {
  for h in query(heading) {
    let page-no = counter(page).at(h.location()).first()
    block(above: 5pt, below: 5pt,
      pad(left: (h.level - 1) * 1em)[
        #h.body #box(width: 1fr, repeat[.]) #page-no
      ])
  }
}

#pagebreak()

= Getting started
#lorem(45)

== Installing
#lorem(55)

#pagebreak()

= Everyday use
#lorem(35)
