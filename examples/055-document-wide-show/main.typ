// A selector-less show rule wraps the whole rest of the document. `#show: report`
// hands everything below to the `report` function, which sets fonts, spacing,
// and heading color, then returns the styled body. This is the mechanism every
// template uses (Chapter 19). See Chapter 10, "Show rules".
// Compile with:  typst compile main.typ out.pdf

#let report(body) = {
  set page(width: 12cm, height: auto, margin: 1.5cm)
  set text(font: "New Computer Modern", size: 11pt, fill: rgb("#222222"))
  set par(justify: true)
  show heading: set text(fill: navy)
  body
}

#show: report

= A tiny template
#lorem(28)

= Second heading
#lorem(20)
