// main.typ — assembling a whole book from the Chapter 22 template.
//
// This is the book seen from orbit: import the template, then list the content
// in reading order — front matter, body, back matter. Every design decision
// was made once, in ../115-oreilly-book-template/. Here we only assemble.

#import "../115-oreilly-book-template/template/book.typ": book, part
#import "../115-oreilly-book-template/template/index.typ": make-index

// Apply the template. This draws the title page and the table of contents,
// then restarts the page counter and switches on the running head and footer
// for the body that follows.
#show: book.with(
  title: "The Weather Almanac",
  subtitle: "A very small book, assembled from parts",
  author: "M. Cumulus",
)

// ===== FRONT MATTER ========================================================
// Lowercase roman numerals, on their own pages, no running head. Our template
// installed an explicit arabic footer for the body; here we hand the front
// matter its own automatic footer (`footer: auto`) so the roman number shows.
// The whole thing is scoped in a `#[...]` block, so the template's body header
// and footer return untouched the moment the block closes.
#[
  #set page(header: none, footer: auto, numbering: "i")
  #counter(page).update(1)
  #include "front/copyright.typ"
  #include "front/preface.typ"
]

// ===== BODY ================================================================
// Restart the page counter at 1 and set arabic numbering (the outline reads
// this to format its page references). The part divider is unnumbered; the
// counter reset just before Chapter 1 makes the first chapter page read "1".
#set page(numbering: "1")

#part[Fair weather]
#counter(page).update(1)
#include "chapters/01-a-clear-morning.typ"
#include "chapters/02-the-noon-sun.typ"

#part[Rough weather]
#include "chapters/03-the-gathering-storm.typ"

// ===== BACK MATTER =========================================================
#include "appendix/a-cloud-table.typ"
#make-index()
