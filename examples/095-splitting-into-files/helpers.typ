// helpers.typ — a home for machinery you want to reuse across documents.
// Nothing here prints on its own; it only defines things for other files to
// import. See Chapter 18, "Your own functions".

// A callout box, the same component built in Chapter 14, now living where any
// document can borrow it.
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
