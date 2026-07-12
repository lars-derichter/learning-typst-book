// The payoff: turn an array of dictionaries into a formatted table. `.map()`
// builds each record into a row of cells, the spread `..` drops all those
// cells into the table's argument list, and a show rule bolds the header.
// See Chapter 16, "Arrays, dictionaries, and strings".
// Compile with:  typst compile main.typ out.pdf
#set page(width: 12cm, height: auto, margin: 1.5cm)
#set text(font: "Libertinus Serif", size: 11pt)

#let pioneers = (
  (name: "Ada Lovelace", born: 1815, field: "computing"),
  (name: "Grace Hopper", born: 1906, field: "computing"),
  (name: "Alan Turing",  born: 1912, field: "logic"),
  (name: "Emmy Noether", born: 1882, field: "algebra"),
)

#show table.cell.where(y: 0): strong

#table(
  columns: 4,
  align: (left, right, left, right),
  stroke: 0.5pt + gray,
  inset: 7pt,
  table.header([Name], [Born], [Field], [Century]),
  ..pioneers
    .sorted(key: p => p.born)
    .map(p => (
      p.name,
      [#p.born],
      p.field,
      [#(calc.floor(p.born / 100) + 1)th],
    ))
    .flatten()
)
