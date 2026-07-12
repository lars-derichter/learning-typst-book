// A list of figures: #outline(target: figure) collects every figure the way a
// plain #outline() collects headings. Swap the target to figure.where(kind:
// table) for a list of tables instead.
#set page(width: 11cm, height: auto, margin: 1.4cm)
#set heading(numbering: "1.")

#outline(title: [List of figures], target: figure)

= Shapes

#figure(
  rect(width: 3cm, height: 1.2cm, fill: luma(220)),
  caption: [A rectangle.],
) <fig:rect>

#figure(
  circle(radius: 0.8cm, fill: luma(200)),
  caption: [A circle.],
) <fig:circle>

= More shapes

#figure(
  polygon.regular(vertices: 3, size: 1.8cm, fill: luma(180)),
  caption: [A triangle.],
) <fig:tri>

The three shapes are @fig:rect, @fig:circle, and @fig:tri.
