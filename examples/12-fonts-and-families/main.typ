// The same sentence in three of Typst's bundled typefaces, labeled,
// plus a fallback font list.
// Compile with:  typst compile main.typ out.pdf
#set page(width: 12cm, height: auto, margin: 1.5cm)
#set text(size: 12pt)

#let sample = [Sphinx of black quartz, judge my vow --- 1234567890.]

/ Libertinus Serif: #text(font: "Libertinus Serif")[#sample]
/ New Computer Modern: #text(font: "New Computer Modern")[#sample]
/ DejaVu Sans Mono: #text(font: "DejaVu Sans Mono")[#sample]

A fallback list is tried left to right: Typst uses the first family
that has the glyph it needs, and only moves on when one is missing.

#set text(font: ("Libertinus Serif", "DejaVu Sans Mono"))
Here Latin letters come from Libertinus Serif; a glyph it lacked
would be fetched from DejaVu Sans Mono instead.
