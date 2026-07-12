// `box` is inline (it sits in a line of text); `block` is block-level
// (it takes its own vertical slab). Both share fill/stroke/radius/inset.
// See Chapter 21, "Advanced layout".
// Compile with:  typst compile main.typ out.pdf
#set page(width: 12cm, height: auto, margin: 1.5cm)
#set text(size: 11pt)

Here is an inline #box(fill: rgb("#fff2b0"), inset: (x: 3pt),
outset: (y: 3pt), radius: 2pt)[highlight] that lives inside the line of
text, so the words keep flowing on either side of it and the line does
not break around it.

#block(
  fill: rgb("#eef4ff"),
  stroke: 1pt + rgb("#3b6fb0"),
  radius: 6pt,
  inset: 10pt,
  width: 100%,
)[
  A block, by contrast, takes its own horizontal band of the page. This
  one carries a fill, a stroke, rounded corners, and inner padding — the
  same knobs a box has, just stacked vertically instead of inline.
]

#block(
  width: 4.5cm,
  height: 1.8cm,
  clip: true,
  stroke: 1pt + gray,
  radius: 4pt,
  inset: 6pt,
)[
  With a fixed height and `clip: true`, anything that overruns the box is
  cut off at the edge instead of spilling past it. #lorem(30)
]
