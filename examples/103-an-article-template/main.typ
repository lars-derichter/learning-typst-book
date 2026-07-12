// A realistic article template: configurable title, author, date, and an
// optional abstract; a styled title block; numbered headings; and running set
// rules for the page, fonts, and paragraphs. The document at the bottom is just
// `#show: article.with(...)` plus content. Chapter 19, "Templates".
// Compile with:  typst compile main.typ out.pdf

#let article(
  title: none,
  author: none,
  date: none,
  abstract: none,
  body,
) = {
  // --- Document-wide set rules ---
  set page(
    width: 14cm,
    height: auto,
    margin: (x: 2cm, top: 2cm, bottom: 1.6cm),
  )
  set text(font: "Libertinus Serif", size: 10.5pt)
  set par(justify: true, leading: 0.65em, first-line-indent: 1.2em)
  set heading(numbering: "1.1")
  show heading.where(level: 1): set text(size: 13pt)

  // --- Title block ---
  align(center)[
    #block(text(size: 20pt, weight: "bold")[#title])
    #v(0.2em)
    #if author != none {
      text(size: 11pt)[#author]
    }
    #if date != none {
      linebreak()
      text(size: 9.5pt, fill: luma(40%))[#date]
    }
  ]

  v(1em)

  // --- Optional abstract ---
  if abstract != none {
    block(width: 100%, inset: (x: 1.4em))[
      #align(center)[#text(weight: "bold", size: 9.5pt)[Abstract]]
      #set text(size: 9.5pt)
      #set par(first-line-indent: 0pt)
      #emph(abstract)
    ]
    v(1em)
  }

  // --- Body ---
  body
}

#show: article.with(
  title: "A Field Guide to Templates",
  author: "A. Reader",
  date: "July 2026",
  abstract: [
    Templates package a document's entire look into one function, so a single
    line dresses the whole thing. This note shows the shape of a realistic one.
  ],
)

= Introduction
#lorem(40)

== Background and motivation
#lorem(30)

= Method
#lorem(35)
