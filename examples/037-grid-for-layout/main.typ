// The same engine, no table semantics: `grid` places two blocks of
// content side by side, with a spanning title and gutters between.
// See Chapter 7, "Tables and grids".
// Compile with:  typst compile main.typ out.pdf
#set page(width: 12cm, height: auto, margin: 1.5cm)
#set text(size: 11pt)

#grid(
  columns: (1fr, 1fr),
  column-gutter: 1cm,
  row-gutter: 0.8cm,
  grid.cell(colspan: 2)[
    == Typst, weighed
  ],
  [
    *For* \
    Instant preview, readable
    source, one language for
    content and code.
  ],
  [
    *Against* \
    A younger ecosystem and
    fewer packages than LaTeX's
    forty-year head start.
  ],
)
