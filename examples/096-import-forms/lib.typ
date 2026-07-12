// lib.typ — a tiny library with two public names, imported three different
// ways by main.typ. See Chapter 18, "Your own functions".

#let accent = rgb("#2b6cb0")

// A keycap: a key name in a small bordered box.
#let kbd(key) = box(
  fill: luma(245),
  stroke: 0.5pt + luma(160),
  inset: (x: 4pt, y: 1pt),
  radius: 3pt,
  baseline: 2pt,
)[#text(font: "DejaVu Sans Mono", size: 8pt)[#key]]
