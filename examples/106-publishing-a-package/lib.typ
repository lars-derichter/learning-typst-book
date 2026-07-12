// lib.typ — the package entrypoint named in typst.toml. Whatever a user
// writes `#import "@preview/callout-box:0.1.0": ...` to get lives in this file.
// A package is just an ordinary .typ file with a manifest sitting beside it.
#let callout(title: none, body) = block(
  fill: luma(240),
  stroke: (left: 2pt + rgb("#3b6ea5")),
  inset: 10pt,
  radius: 2pt,
  width: 100%,
  {
    if title != none [ #strong(title) \ ]
    body
  },
)
