// index.typ — a real, working back-of-book index.
//
// The idea, in two halves:
//   1. `#idx("term")` drops an invisible marker (a `metadata` element carrying
//      the term, tagged with a label) at the spot where the term is discussed,
//      and prints the term in the text.
//   2. `make-index()` runs at the back of the book: inside `context`, it
//      queries every marker, reads each one's page number off its location,
//      groups the pages under each term, and lays the whole thing out sorted.
// The query machinery is Chapter 21; the counter-at-a-location trick is
// Chapter 17.

#import "theme.typ": *

// Mark a term AND print it in the running text.
#let idx(term) = [#metadata(term)<index-entry>#term]

// Mark a term WITHOUT printing anything — for when the prose phrases the idea
// in words that don't match the index term you want.
#let idx-silent(term) = [#metadata(term)<index-entry>]

// Build the index page. Call this once, at the very end of the book.
#let make-index() = {
  // A chapter-style opener for the index, but not a real heading (so it neither
  // steps the chapter counter nor gets the big chapter number).
  pagebreak(weak: true)
  block(above: 0pt, below: 1.2em)[
    #text(font: font-head, size: 22pt, weight: "bold", fill: ink)[Index]
    #v(2pt)
    #line(length: 100%, stroke: 0.6pt + accent)
  ]

  context {
    // Every marker in the finished document.
    let entries = query(<index-entry>)

    // Group page numbers under each term, de-duplicated.
    let pages = (:)
    for e in entries {
      let term = e.value
      let p = counter(page).at(e.location()).first()
      let seen = pages.at(term, default: ())
      if p not in seen { seen.push(p) }
      pages.insert(term, seen)
    }

    // Two columns, alphabetical, with a small letter heading before each run.
    set text(size: size-small)
    columns(2, gutter: 1.2em)[
      #let last-letter = none
      #for term in pages.keys().sorted() {
        let letter = upper(term.first())
        if letter != last-letter {
          last-letter = letter
          v(0.5em, weak: true)
          text(font: font-head, weight: "bold", fill: accent)[#letter]
          v(0.2em, weak: true)
        }
        let nums = pages.at(term).sorted().map(str).join(", ")
        block(below: 0.35em, breakable: false)[
          #term #box(width: 1fr, repeat[.#h(3pt)]) #nums
        ]
      }
    ]
  }
}
