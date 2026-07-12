// A reusable article template, kept in its own file so any document can import
// it with `#import "template.typ": article`. All the styling lives here; a
// document that uses it stays clean. Chapter 19, "Templates".

#let article(title: none, author: none, body) = {
  set page(width: 12cm, height: auto, margin: 1.6cm)
  set text(font: "Libertinus Serif", size: 11pt)
  set par(justify: true)
  set heading(numbering: "1.")

  align(center)[
    #text(size: 18pt, weight: "bold")[#title] \
    #text(style: "italic")[#author]
  ]
  v(1em)

  body
}
