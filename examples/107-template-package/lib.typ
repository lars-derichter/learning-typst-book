// lib.typ — the template package's entrypoint. It exports one show-rule
// function, `report`, of exactly the shape Chapter 19 built by hand: it takes
// the document body, sets the page and text, drops in a title block, and
// returns the styled document.
#let report(title: none, author: none, body) = {
  set page(width: 12cm, height: auto, margin: 1.4cm)
  set text(font: "Libertinus Serif", size: 11pt)
  set par(justify: true)
  if title != none {
    align(center, text(size: 17pt, weight: "bold", title))
    if author != none { align(center, author) }
    v(0.6em)
  }
  body
}
