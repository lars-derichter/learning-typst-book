// A page background and a watermark.
//   fill        - paints the whole page a color (here a faint paper tint)
//   background  - content drawn behind everything, filling the page box
// The watermark is centered and rotated, in a very light gray so the body
// text still reads on top of it.
// Compile with:  typst compile main.typ out.pdf
#set page(
  width: 9cm,
  height: 12cm,
  margin: 1.2cm,
  fill: rgb("#faf6ec"),
  background: align(center + horizon,
    rotate(-30deg, text(52pt, fill: luma(80%))[*DRAFT*])),
)

= Quarterly report

#lorem(55)
