// book-preamble.typ — the Typst book design that the Markdown-converted body
// is appended to.
//
// This is plain Typst, start to finish: page setup, heading and code styling,
// the admonition() function the Lua filter calls, a title page, and a table of
// contents. The build script converts every chapter to a Typst body with
// Pandoc, then concatenates this file in front of it. Keeping the preamble
// free of Pandoc's own template syntax (no dollar-variables) means Typst code
// and Pandoc templating never step on each other.

#set document(title: "Learning Typst")

#set page(
  width: 16cm,
  height: 24cm,
  margin: (inside: 2cm, outside: 1.8cm, top: 2cm, bottom: 2cm),
  numbering: "1",
  number-align: center,
)

#set text(font: "Libertinus Serif", size: 10.5pt, lang: "en")
#set par(justify: true, leading: 0.62em)
#set heading(numbering: "1.1")

// Each top-level heading (a chapter) opens a fresh page, book-style.
#show heading.where(level: 1): it => {
  pagebreak(weak: true)
  block(above: 0pt, below: 1.1em)[
    #if it.numbering != none [
      #text(fill: rgb("#a03018"), size: 14pt, weight: "bold")[
        #counter(heading).display()
      ]
      #v(1pt)
    ]
    #text(size: 21pt, weight: "bold")[#it.body]
  ]
}
#show heading.where(level: 2): set text(size: 13pt, fill: rgb("#7a2410"))
#show heading.where(level: 3): set text(size: 11pt, fill: rgb("#7a2410"))

// Fenced code becomes a tinted panel; inline code a light chip.
#show raw.where(block: true): it => block(
  fill: rgb("#f5f2ee"),
  stroke: (left: 2pt + rgb("#c8b8a8")),
  inset: 8pt,
  width: 100%,
  radius: 2pt,
  text(size: 8.5pt, it),
)
#show raw.where(block: false): it => box(
  fill: rgb("#efeae3"),
  inset: (x: 2pt),
  outset: (y: 2pt),
  radius: 1pt,
  text(size: 9pt, it),
)

#show link: set text(fill: rgb("#1a5276"))

// The O'Reilly-style boxes the github-alerts.lua filter emits as
//   #admonition("note")[ ... ]
#let admonition(kind, body) = {
  let styles = (
    note: (rgb("#1a5276"), "Note"),
    tip: (rgb("#1e8449"), "Tip"),
    important: (rgb("#6c3483"), "Important"),
    warning: (rgb("#b9770e"), "Warning"),
    caution: (rgb("#a93226"), "Caution"),
  )
  let (color, label) = styles.at(kind, default: styles.note)
  block(
    width: 100%,
    fill: color.lighten(90%),
    stroke: (left: 3pt + color),
    inset: 9pt,
    radius: (right: 3pt),
    above: 1em,
    below: 1em,
  )[
    #text(fill: color, weight: "bold", size: 8.5pt)[#upper(label)]
    #v(2pt, weak: true)
    #body
  ]
}

// --- Title page (its own unnumbered page). -----------------------------------
#page(numbering: none, margin: 3cm, {
  set align(center + horizon)
  block[
    #text(size: 34pt, weight: "bold")[Learning Typst]
    #v(8pt)
    #text(size: 14pt, fill: luma(90))[
      A hands-on guide to the Typst typesetting system
    ]
    #v(20pt)
    #line(length: 40%, stroke: 0.6pt + rgb("#a03018"))
    #v(16pt)
    #text(size: 11pt)[Written with AI, under human direction]
  ]
})

// --- Table of contents. ------------------------------------------------------
#page(numbering: none)[
  #text(size: 20pt, weight: "bold")[Contents]
  #v(12pt)
  #outline(title: none, depth: 2, indent: 1.2em)
]

// Restart page numbering at 1 for the body.
#counter(page).update(1)

// The Pandoc-converted body of every chapter is appended below this line.
