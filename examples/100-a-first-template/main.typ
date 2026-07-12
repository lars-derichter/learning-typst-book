// A minimal template. `report` is an ordinary function that takes the document
// `body`, applies a stack of set rules, and hands the styled body back. The
// selector-less `#show: report` feeds the whole rest of the document in as
// `body`. Chapter 19, "Templates".
// Compile with:  typst compile main.typ out.pdf

#let report(body) = {
  set page(width: 12cm, height: auto, margin: 1.6cm)
  set text(font: "Libertinus Serif", size: 11pt)
  set par(justify: true, leading: 0.7em)
  set heading(numbering: "1.")
  body
}

#show: report

= Field notes
#lorem(30)

= Observations
#lorem(24)
