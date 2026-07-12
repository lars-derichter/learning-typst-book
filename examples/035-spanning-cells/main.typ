// Spanning cells: `colspan` widens a cell across columns, `rowspan`
// stretches it down rows. The other cells flow around the gap.
// See Chapter 7, "Tables and grids".
// Compile with:  typst compile main.typ out.pdf
#set page(width: 12cm, height: auto, margin: 1.5cm)
#set text(size: 11pt)

#table(
  columns: 3,
  align: (x, y) => if x == 0 { left } else { center },
  table.cell(colspan: 3, align: center)[*Autumn timetable*],
  [Time], [Mon], [Tue],
  table.cell(rowspan: 2)[Morning], [Maths], [Biology],
  [English], [Chemistry],
  table.cell(rowspan: 2)[Afternoon], [Art], [Music],
  [History], [Drama],
)
