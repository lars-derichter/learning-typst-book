// OpenType figures: lining vs old-style, tabular vs proportional.
// Compile with:  typst compile main.typ out.pdf
#set page(width: 12cm, height: auto, margin: 1.5cm)
#set text(font: "Libertinus Serif", size: 12pt)

Lining figures (the default) sit on the baseline at a uniform height:
0123456789.

#text(number-type: "old-style")[Old-style figures rise and fall like
lowercase letters: 0123456789.]

Old-style suits running prose --- the year
#text(number-type: "old-style")[1789] blends into the words around it.

Tabular figures share one width, so a right-aligned column lines up
digit-for-digit; proportional figures are individually spaced:

#table(
  columns: 2,
  align: right,
  inset: 6pt,
  table.header([*Tabular*], [*Proportional*]),
  text(number-width: "tabular")[1,111],
  text(number-width: "proportional")[1,111],
  text(number-width: "tabular")[8,080],
  text(number-width: "proportional")[8,080],
  text(number-width: "tabular")[9,999],
  text(number-width: "proportional")[9,999],
)
