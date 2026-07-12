// A first table: one `columns` count, then cells flow left to right,
// top to bottom. See Chapter 7, "Tables and grids".
// Compile with:  typst compile main.typ out.pdf
#set page(width: 12cm, height: auto, margin: 1.5cm)
#set text(size: 11pt)

#table(
  columns: 3,
  [*Course*], [*Credits*], [*Exam*],
  [Typesetting], [6], [Project],
  [Statistics], [4], [Written],
  [Pedagogy], [5], [Oral],
)
