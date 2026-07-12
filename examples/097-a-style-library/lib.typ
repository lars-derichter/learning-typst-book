// lib.typ — a small personal style library: theme constants at the top, a few
// components below. Import it from any document to get a consistent look
// without copying code around. See Chapter 18, "Your own functions".

// ---- Theme constants -------------------------------------------------------
// One place to change the palette and sizes for everything downstream.
#let brand = rgb("#2b6cb0") // headings, rules, accents
#let muted = luma(110) // captions, secondary text
#let gap = 0.9em // standard vertical breathing room

// ---- Components ------------------------------------------------------------

// callout(body, title:, color:) — a titled note box.
#let callout(body, title: "Note", color: brand) = block(
  fill: color.lighten(85%),
  stroke: (left: 3pt + color),
  inset: 10pt,
  radius: (right: 4pt),
  width: 100%,
)[
  #text(fill: color, weight: "bold")[#title] \
  #body
]

// kbd(key) — a keyboard keycap, e.g. #kbd("Ctrl").
#let kbd(key) = box(
  fill: luma(245),
  stroke: 0.5pt + luma(160),
  inset: (x: 4pt, y: 1pt),
  radius: 3pt,
  baseline: 2pt,
)[#text(font: "DejaVu Sans Mono", size: 8pt)[#key]]

// framed(body, caption:) — a labeled figure: content in a light frame with a
// caption set in the muted colour underneath.
#let framed(body, caption: none) = figure(
  block(
    stroke: 0.5pt + muted,
    inset: 10pt,
    radius: 4pt,
    width: 100%,
  )[#body],
  caption: caption,
)
