// Two `.where` show rules target heading levels separately: level 1 gets a big
// navy show-set, level 2 gets a function-form rebuild with a marker and color.
// One document, two looks, selected by field. See Chapter 10, "Show rules".
// Compile with:  typst compile main.typ out.pdf
#set page(width: 12cm, height: auto, margin: 1.5cm)
#set text(font: "Libertinus Serif", size: 11pt)
#set heading(numbering: none)

#show heading.where(level: 1): set text(size: 18pt, fill: navy)
#show heading.where(level: 2): it => block(above: 1em, below: 0.6em)[
  #text(fill: maroon, weight: "bold")[» #it.body]
]

= Part one
#lorem(16)

== First section
#lorem(12)

== Second section
#lorem(12)

= Part two
#lorem(14)
