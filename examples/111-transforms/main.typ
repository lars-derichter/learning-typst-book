// rotate, scale, and move transform content visually. By default they do
// not disturb the surrounding layout; `reflow: true` makes the layout
// account for the transformed shape.
// See Chapter 21, "Advanced layout".
// Compile with:  typst compile main.typ out.pdf
#set page(width: 12cm, height: auto, margin: 1.5cm)
#set text(size: 11pt)

#let tag(body) = box(fill: rgb("#ffd23f"), inset: 6pt, radius: 3pt, body)

#stack(
  dir: ltr,
  spacing: 1.4cm,
  tag[plain],
  rotate(-20deg, tag[rotated]),
  scale(x: 140%, y: 70%, tag[scaled]),
  move(dy: -8pt, tag[moved]),
)

#v(14pt)

// reflow decides whether neighbours notice the transform.
Default: before #rotate(30deg)[#tag[X]] after — the line keeps its
original height, so the rotated tag pokes out.

#v(6pt)

reflow: before #rotate(30deg, reflow: true)[#tag[X]] after — the line
grows to fit the rotated tag.
