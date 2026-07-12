// Zebra striping: a `fill` function paints every odd row light gray.
// Vertical lines off, roomy inset. See Chapter 7, "Tables and grids".
// Compile with:  typst compile main.typ out.pdf
#set page(width: 12cm, height: auto, margin: 1.5cm)
#set text(size: 11pt)

#table(
  columns: (1fr, auto, auto),
  stroke: none,
  inset: 8pt,
  align: (x, y) => if y == 0 { left } else if x == 0 { left } else { right },
  fill: (x, y) => if calc.odd(y) { luma(240) },
  [*Region*], [*Q1*], [*Q2*],
  [North], [120], [138],
  [South], [98], [102],
  [East], [156], [161],
  [West], [143], [149],
)
