// Two-column pages. `columns: 2` on the page flows the whole document into
// two balanced columns; text fills the left column, then the right, then the
// next page. The gap between columns is the column gutter.
// Compile with:  typst compile main.typ out.pdf
#set page(
  width: 9cm,
  height: 12cm,
  margin: 1cm,
  columns: 2,
)
#set par(justify: true)

= Two columns

Newspaper-style flow: the text pours down the left column and continues at the
top of the right one. Headings that should span both columns can, but body
text stays in its lane.

#lorem(90)
