// code.typ — theming for `raw` (code).
//
// One function, `code-rules`, that installs a couple of show rules on `raw`
// and hands the body back wearing them (the whole-document `show:` shape from
// Chapter 10). `book()` applies it with `show: code-rules`.

#import "theme.typ": *

#let code-rules(body) = {
  // Every code span, inline or block, is set in the mono font.
  show raw: set text(font: font-mono)

  // Inline code — `like this` — gets a subtle tinted chip so it stands out
  // from the surrounding prose without shouting.
  show raw.where(block: false): box.with(
    fill: code-bg,
    inset: (x: 3pt),
    outset: (y: 3pt),
    radius: 2pt,
  )

  // Block code gets its own slab: a light background, generous padding, and a
  // coloured rule down the left edge, the O'Reilly listing look.
  show raw.where(block: true): it => block(
    fill: code-bg,
    stroke: (left: 2pt + accent),
    inset: (x: 9pt, y: 8pt),
    radius: (right: 3pt),
    width: 100%,
    above: 1em,
    below: 1em,
    text(size: size-code, it),
  )

  body
}
