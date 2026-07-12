// book.typ — the template itself.
//
// `book(...)` is one big function of the kind Chapter 19 built: it takes the
// whole document as `body` (last, as the show-rule idiom requires), installs
// the page setup, running heads, and heading styling, lays down the title page
// and table of contents, and hands the styled body back. `part(...)` renders a
// full-page part divider. Both are exported for `main.typ` to use.

#import "theme.typ": *
#import "code.typ": code-rules

// --- Front matter: the title page ------------------------------------------
// An isolated `#page` (Chapter 21) with no running head or footer, so the
// cover stands alone. `v(..fr)` springs (Chapter 5) float the block vertically.
#let _title-page(title, subtitle, author) = page(header: none, footer: none)[
  #set align(center)
  #v(3fr)
  #text(font: font-head, size: 30pt, weight: "bold", fill: ink)[#title]
  #if subtitle != none {
    v(0.7em)
    text(font: font-head, size: 14pt, fill: accent, style: "italic")[#subtitle]
  }
  #v(1.2em)
  #line(length: 35%, stroke: 1pt + accent)
  #v(1fr)
  #if author != none {
    text(font: font-head, size: 13pt, fill: ink)[#author]
  }
  #v(2fr)
]

// --- Front matter: the table of contents -----------------------------------
// The heading over the list is drawn by hand (plain text, not a `heading`) so
// it doesn't trip the chapter-opener show rule below. `#outline` (Chapter 11)
// does the real work; a show rule bolds the chapter-level entries.
#let _contents-page() = {
  block(above: 0pt, below: 1em)[
    #text(font: font-head, size: 22pt, weight: "bold", fill: ink)[Contents]
    #v(2pt)
    #line(length: 100%, stroke: 0.6pt + accent)
  ]
  show outline.entry.where(level: 1): set text(font: font-head, weight: "bold")
  outline(title: none, depth: 2, indent: 1.2em)
}

// --- A part divider --------------------------------------------------------
// Not a heading (so it stays out of the chapter counter and the outline); a
// custom `counter("part")` gives it a roman numeral. Its own isolated page.
#let part(title) = {
  counter("part").step()
  page(header: none, footer: none)[
    #set align(center + horizon)
    #text(font: font-head, size: 11pt, fill: muted, weight: "bold", tracking: 3pt)[
      #upper[Part] #context counter("part").display("I")
    ]
    #v(0.5em)
    #line(length: 22%, stroke: 1pt + accent)
    #v(0.7em)
    #text(font: font-head, size: 26pt, weight: "bold", fill: ink)[#title]
  ]
}

// --- The template ----------------------------------------------------------
#let book(
  title: none,
  subtitle: none,
  author: none,
  // An optional cover: any content (typically a full-bleed `#page`) laid down
  // before the title page. `none` keeps the plain sampler unchanged; the Pandoc
  // build (Chapter 24) passes a full O'Reilly-homage cover here.
  cover: none,
  // Page geometry is a parameter so the same template serves both this small
  // sampler and a full-size book. The defaults keep the multipage preview
  // legible; a real book (see the Pandoc pipeline in Chapter 24) passes an A4.
  width: 13cm,
  height: 19cm,
  margin: (x: 1.8cm, top: 2cm, bottom: 1.8cm),
  body,
) = {
  set page(
    width: width,
    height: height,
    margin: margin,
    header: none,   // front matter is bare; the body sets these below
    footer: none,
  )
  set text(font: font-body, size: size-body, fill: ink, lang: "en")
  set par(
    justify: true,
    leading: 0.62em,
    spacing: 0.72em,
    first-line-indent: (amount: 1.2em, all: false),
  )
  set heading(numbering: "1.1")

  // Component styling: code blocks, then the three heading levels.
  show: code-rules

  // Level 1 = a chapter. Rebuilt (Chapter 10) into a full opener: a page break,
  // a "CHAPTER n" kicker, the big title, and a rule. The number is read live
  // from the heading counter (Chapter 17).
  show heading.where(level: 1): it => {
    pagebreak(weak: true)
    v(1.4cm)
    block(spacing: 0pt)[
      // The "CHAPTER n" kicker only for numbered chapters. Front and back matter
      // (a Preface, an Appendix) are unnumbered headings, and just get the title.
      #if it.numbering != none [
        #text(font: font-head, fill: muted, weight: "bold", size: 10pt, tracking: 2pt)[
          #upper[Chapter] #context counter(heading).display("1")
        ]
        #v(0.35em)
      ]
      #text(font: font-head, fill: ink, weight: "bold", size: 23pt)[#it.body]
      #v(0.45em)
      #line(length: 100%, stroke: 0.8pt + accent)
    ]
    v(0.9em)
  }
  // Levels 2 and 3 = sections. A show-set (Chapter 10) recolours them and keeps
  // their automatic numbering.
  show heading.where(level: 2): set text(font: font-head, fill: accent, size: 12.5pt)
  show heading.where(level: 3): set text(font: font-head, fill: ink, size: 10.5pt)

  // Captions a touch smaller and muted.
  show figure.caption: set text(size: size-small, fill: muted)

  // === Front matter ===
  // The cover (if any) comes first, then the title page and the contents.
  if cover != none { cover }
  _title-page(title, subtitle, author)
  _contents-page()

  // === Body ===
  // Restart page numbering, then switch on the running head and footer. Because
  // set rules apply from here on (Chapter 9), the front matter above stays bare.
  counter(page).update(1)

  set page(
    header: context {
      let n = here().page()
      let openers = query(heading.where(level: 1)).map(h => h.location().page())
      // No running head on a chapter's opening page — the book convention.
      if n not in openers {
        // The current chapter is the last one that began on or before this page.
        let current = none
        for h in query(heading.where(level: 1)) {
          if h.location().page() <= n { current = h }
        }
        let label = if current == none {
          []
        } else if current.numbering != none {
          [#numbering("1", ..counter(heading).at(current.location())) — #current.body]
        } else {
          // An unnumbered chapter (Preface, Appendix): just its title.
          current.body
        }
        grid(
          columns: (1fr, auto),
          text(font: font-head, size: size-small, fill: muted, style: "italic")[#title],
          text(font: font-head, size: size-small, fill: muted)[#label],
        )
        v(3pt)
        line(length: 100%, stroke: 0.5pt + hairline)
      }
    },
    footer: context {
      set align(center)
      text(font: font-head, size: size-small, fill: muted)[
        #counter(page).display("1")
      ]
    },
  )

  body
}
