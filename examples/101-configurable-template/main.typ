// A configurable template. `report` now takes named configuration arguments
// (title, author) in front of the body, builds a title block from them, then
// lays out the body. Apply it with `#show: report.with(...)`: `.with` pre-fills
// the config and leaves `body`, which the show rule supplies. Chapter 19.
// Compile with:  typst compile main.typ out.pdf

#let report(title: none, author: none, body) = {
  set page(width: 12cm, height: auto, margin: 1.6cm)
  set text(font: "Libertinus Serif", size: 11pt)
  set par(justify: true)
  set heading(numbering: "1.")

  // A title block, built from the configuration arguments.
  align(center)[
    #text(size: 18pt, weight: "bold")[#title] \
    #text(style: "italic")[#author]
  ]
  v(1.2em)

  body
}

#show: report.with(
  title: "Weeknotes",
  author: "A. Reader",
)

= Monday
#lorem(28)

= Tuesday
#lorem(20)
