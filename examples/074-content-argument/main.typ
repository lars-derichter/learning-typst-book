// A reusable component that takes a content block plus named options. The sugar
// `#callout[...]` is exactly `#callout([...])`, and `#callout(title: "Tip")[...]`
// passes the bracketed content as the last positional argument. This is why
// `#figure[...]` and `#text(...)[...]` work. See Chapter 14.
// Compile with:  typst compile main.typ out.pdf
#set page(width: 12cm, height: auto, margin: 1.5cm)
#set text(font: "Libertinus Serif", size: 11pt)

#let callout(body, title: "Note", color: blue) = block(
  fill: color.lighten(85%),
  stroke: (left: 3pt + color),
  inset: 10pt,
  radius: (right: 4pt),
  width: 100%,
)[
  #text(fill: color, weight: "bold")[#title] \
  #body
]

#callout[
  An ordinary note. The whole bracketed block became the `body` argument.
]

#callout(title: "Tip", color: green)[
  Give the callout a different title and colour with named arguments.
]

#callout(title: "Warning", color: red)[
  Named options come first; the positional content still lands last.
]
