// A small custom graphic built from a shape function (`circle`) and
// `curve`, the modern path tool. `curve.line` draws the straight tick;
// `curve.cubic` draws the smooth flourish underneath.
// (In Typst 0.15 the old `path` function is gone — `curve` replaces it.)
// See Chapter 21, "Advanced layout".
// Compile with:  typst compile main.typ out.pdf
#set page(width: auto, height: auto, margin: 14pt)

// The disk: a shape-function primitive.
#let disk = circle(radius: 24pt, fill: rgb("#2e9e5b"))

// The tick: a two-segment polyline drawn with `curve`.
#let tick = curve(
  stroke: (paint: white, thickness: 5pt, cap: "round", join: "round"),
  curve.move((-10pt, 1pt)),
  curve.line((-2pt, 9pt)),
  curve.line((11pt, -9pt)),
)

// A smooth flourish: a single cubic Bezier, curve's reason to exist.
#let swoosh = curve(
  stroke: (paint: rgb("#2e9e5b"), thickness: 2.5pt, cap: "round"),
  curve.move((0pt, 0pt)),
  curve.cubic((18pt, 14pt), (42pt, -14pt), (60pt, 0pt)),
)

#stack(
  dir: ttb,
  spacing: 9pt,
  align(center, box(width: 48pt, height: 48pt)[
    #place(center + horizon, disk)
    #place(center + horizon, tick)
  ]),
  align(center, swoosh),
)
