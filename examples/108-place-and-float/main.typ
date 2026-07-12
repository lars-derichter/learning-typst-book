// `place` takes content out of the normal flow and pins it to a spot on
// the page. `float: true` sends a block to the top or bottom instead.
// See Chapter 21, "Advanced layout".
// Compile with:  typst compile main.typ out.pdf
#set page(width: 12cm, height: 17cm, margin: 1.6cm)
#set text(size: 10pt)

// Pinned to the top-right corner of the text area, nudged inward with
// dx (leftward, so negative) and dy (downward, so positive).
#place(top + right, dx: -0.2cm, dy: 0.2cm,
  box(fill: rgb("#ffd23f"), inset: 6pt, radius: 3pt)[*DRAFT*])

// A little rotated marker, pinned bottom-left.
#place(bottom + left, dy: -0.1cm,
  text(fill: gray, size: 8pt)[shelf 12-B])

// A floating callout: it leaves the flow and drops to the foot of the
// page, while the paragraphs above go on filling from the top.
#place(bottom, float: true, clearance: 10pt,
  block(fill: rgb("#eef4ff"), stroke: 0.5pt + rgb("#3b6fb0"),
    inset: 8pt, radius: 4pt, width: 100%)[
    *Floated.* This block asked to float to the bottom. The body text
    flowed as though it were never in the way.
  ])

= Placing things by hand
None of the three items above sits in the text flow. The paragraph you
are reading started at the very top of the text area, right under the
yellow tag, because `place` reserves no space for what it positions.

#lorem(70)
