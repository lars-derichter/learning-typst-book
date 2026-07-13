// previews.typ — the rendered output shown beneath a code listing.
//
// A book about typesetting should let you see what the code produces, not just
// read it. Every example in examples/NNN-slug/ ships a small, tightly-cropped
// render (out.png); when the whole-book build meets a code listing that a
// sentence introduced with "(`examples/NNN-slug/`):", it drops that render in
// right below the code, via `#preview("/examples/NNN-slug/out.png")`.
//
// Deliberately NOT a #figure: a preview carries no number and never enters the
// list of figures — it is the code's output, standing where the output belongs,
// not a numbered exhibit. `keep()` is the stickiness helper the build uses to
// hold an intro line, its code, and this preview together across a page break.

#import "theme.typ": *

// Hold a block with whatever follows it, so a code-intro line does not strand at
// a page foot from its listing (and a listing from its preview). Spacing is set
// to the body paragraph spacing so wrapping a paragraph does not change its gaps.
#let keep(body) = block(sticky: true, spacing: 0.72em, body)

// The rendered output of an example, framed and centered under its code. `width`
// is a share of the text block; tuned modest so a preview reads as a result, not
// a figure. Non-breakable so a render never tears across two pages.
#let preview(path, width: 58%) = block(
  breakable: false,
  width: 100%,
  above: 0.9em,
  below: 1.1em,
  {
    set align(center)
    box(
      fill: white,
      stroke: 0.5pt + hairline,
      inset: 5pt,
      radius: 2pt,
      image(path, width: width),
    )
    v(0.35em, weak: true)
    text(font: font-head, fill: muted, size: size-small - 1pt, tracking: 1.5pt)[
      #upper[Output]
    ]
  },
)
