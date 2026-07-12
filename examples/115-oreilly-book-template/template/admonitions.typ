// admonitions.typ — the O'Reilly boxes.
//
// One general `admonition` component (the content-argument pattern from
// Chapter 14: `body` first, options named-with-defaults) and five named
// variants stamped out of it with `.with` (Chapter 14's partial application).

#import "theme.typ": *

// admonition(body, kind:, color:) — a tinted block with a coloured label and
// a coloured rule down its left edge.
#let admonition(body, kind: "Note", color: note-color) = block(
  fill: color.lighten(90%),
  stroke: (left: 3pt + color),
  inset: (x: 10pt, y: 8pt),
  radius: (right: 3pt),
  width: 100%,
  above: 1em,
  below: 1em,
)[
  #text(
    font: font-head,
    fill: color,
    weight: "bold",
    size: size-small,
    tracking: 0.6pt,
  )[#upper(kind)]
  #v(-0.35em)
  #set par(first-line-indent: 0pt)
  #body
]

// The five variants. A caller writes `#note[...]`, `#warning[...]`, and so on.
#let note = admonition.with(kind: "Note", color: note-color)
#let tip = admonition.with(kind: "Tip", color: tip-color)
#let important = admonition.with(kind: "Important", color: important-color)
#let warning = admonition.with(kind: "Warning", color: warning-color)
#let caution = admonition.with(kind: "Caution", color: caution-color)
