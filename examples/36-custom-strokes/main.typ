// A clean, booktabs-style look: no cell borders, just three horizontal
// rules placed by hand with `table.hline`. See Chapter 7.
// Compile with:  typst compile main.typ out.pdf
#set page(width: 12cm, height: auto, margin: 1.5cm)
#set text(size: 11pt)

#table(
  columns: 3,
  stroke: none,
  inset: (x: 10pt, y: 6pt),
  align: (left, right, right),
  table.hline(stroke: 1pt),
  table.header([*Element*], [*Symbol*], [*Z*]),
  table.hline(stroke: 0.6pt),
  [Hydrogen], [H], [1],
  [Helium], [He], [2],
  [Lithium], [Li], [3],
  [Beryllium], [Be], [4],
  table.hline(stroke: 1pt),
)
