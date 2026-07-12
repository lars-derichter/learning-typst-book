// Figures aren't just images: a table figure (auto-detected kind) and a
// custom-kind diagram figure with its own counter and supplement.
// Compile with:  typst compile main.typ out.pdf
#set page(width: 12cm, height: auto, margin: 1.5cm)

Wrap a table in a figure and Typst notices: it labels it "Table", not
"Figure", and counts tables separately (@tbl:sales).

#figure(
  table(
    columns: 2,
    align: (left, right),
    [*Quarter*], [*Sales*],
    [Q1], [120],
    [Q2], [148],
    [Q3], [165],
  ),
  caption: [Quarterly sales, in thousands.],
) <tbl:sales>

For anything Typst can't guess, set the `kind` and `supplement` yourself. These
two get their own "Diagram" counter, independent of figures and tables
(@dia:flow, @dia:node).

#figure(
  polygon(fill: teal, (0cm, 0cm), (3cm, 0cm), (1.5cm, 2cm)),
  caption: [A triangular flow marker.],
  kind: "diagram",
  supplement: [Diagram],
) <dia:flow>

#figure(
  rect(width: 3cm, height: 1.5cm, fill: lime, radius: 3pt),
  caption: [A single node.],
  kind: "diagram",
  supplement: [Diagram],
) <dia:node>
