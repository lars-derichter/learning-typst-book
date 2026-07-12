// Alignment as a function of position: center the header row, left-align
// the first column, right-align the numbers. See Chapter 7.
// Compile with:  typst compile main.typ out.pdf
#set page(width: 12cm, height: auto, margin: 1.5cm)
#set text(size: 11pt)

#table(
  columns: (1fr, auto, auto),
  align: (x, y) => if y == 0 { center } else if x == 0 { left } else { right },
  [*Item*], [*Qty*], [*Price*],
  [Notebook], [3], [€4.50],
  [Fountain pen], [1], [€28.00],
  [Ink cartridges], [12], [€6.20],
)
