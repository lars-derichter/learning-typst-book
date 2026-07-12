// `stack` lays content out in one direction with a single spacing value.
// `dir: ttb` stacks a column; `dir: ltr` stacks a row.
// See Chapter 21, "Advanced layout".
// Compile with:  typst compile main.typ out.pdf
#set page(width: 12cm, height: auto, margin: 1.5cm)
#set text(size: 11pt)

// A column: top to bottom, 8pt between each item.
#stack(
  dir: ttb,
  spacing: 8pt,
  rect(width: 100%, fill: rgb("#f2d5d5"), inset: 6pt)[first],
  rect(width: 100%, fill: rgb("#d5e8f2"), inset: 6pt)[second],
  rect(width: 100%, fill: rgb("#d9f2d5"), inset: 6pt)[third],
)

#v(10pt)

// A row: left to right, 12pt between each item.
#stack(
  dir: ltr,
  spacing: 12pt,
  circle(radius: 14pt, fill: rgb("#e23b3b")),
  circle(radius: 14pt, fill: rgb("#2e9e5b")),
  circle(radius: 14pt, fill: rgb("#3b6fb0")),
)
