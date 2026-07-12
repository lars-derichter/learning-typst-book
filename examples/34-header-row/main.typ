// A styled header and a footer. `table.header` marks the top row (it
// repeats when a table breaks across pages); `table.footer` marks the
// bottom. See Chapter 7, "Tables and grids".
// Compile with:  typst compile main.typ out.pdf
#set page(width: 12cm, height: auto, margin: 1.5cm)
#set text(size: 11pt)

#table(
  columns: (1fr, auto, auto),
  align: (left, right, right),
  fill: (x, y) => if y == 0 { luma(230) },
  table.header(
    [*Region*], [*Q1*], [*Q2*],
  ),
  [North], [120], [138],
  [South], [98], [102],
  [East], [156], [161],
  table.footer(
    [*Total*], [374], [401],
  ),
)
