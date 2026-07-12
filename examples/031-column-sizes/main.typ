// Column track sizes: `auto` fits the content, `1fr` soaks up the
// leftover width (and wraps), a length like `2.5cm` is fixed.
// See Chapter 7, "Tables and grids".
// Compile with:  typst compile main.typ out.pdf
#set page(width: 12cm, height: auto, margin: 1.5cm)
#set text(size: 11pt)

#table(
  columns: (auto, 1fr, 2.5cm),
  [*Feature*], [*What it does*], [*Since*],
  [Preview], [Recompiles as you type, usually faster than you can notice.], [v0.1],
  [Packages], [A central registry you pull templates and tools from.], [v0.6],
  [HTML export], [An experimental second output format beside PDF.], [v0.11],
)
