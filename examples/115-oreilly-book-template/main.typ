// main.typ — the entry point.
//
// Nothing but metadata, structure, and content. All the design lives in
// template/. The book applies itself with a single `#show:` line (Chapter 19),
// then we lay out its parts, include the chapter files (Chapter 18), and build
// the index at the back.

#import "template/book.typ": book, part
#import "template/index.typ": make-index

#show: book.with(
  title: "Learning Typst",
  subtitle: "A field guide, in miniature",
  author: "Typeset with the Chapter 22 template",
)

#part[Getting started]

#include "chapters/01-getting-started.typ"
#include "chapters/02-first-document.typ"

#part[Going further]

#include "chapters/03-automating.typ"

#make-index()
