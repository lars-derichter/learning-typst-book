// look.typ — a whole document look bundled into one function. It sets page and
// text defaults and installs a couple of show rules, then hands the body back.
// Apply it with `#show: report` and one line restyles the entire document.
// This is a template in miniature (Chapter 19). See Chapter 18.

#let brand = rgb("#7c3aed")

#let report(body) = {
  // Page and text defaults.
  set page(width: 13cm, height: auto, margin: 1.6cm)
  set text(font: "Libertinus Serif", size: 11pt)
  set par(justify: true)

  // Numbered, brand-coloured headings.
  set heading(numbering: "1.1")
  show heading.where(level: 1): set text(fill: brand, size: 17pt)
  show heading.where(level: 2): set text(fill: brand)

  // Hand the rest of the document back so it inherits everything above.
  body
}
