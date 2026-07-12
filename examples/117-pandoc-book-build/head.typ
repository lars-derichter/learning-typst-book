// head.typ — the front of the generated book.
//
// This is the point of Chapter 24: the whole book is typeset with the *same*
// reusable template built in Chapter 22 (examples/115-oreilly-book-template),
// not a throwaway preamble. We import the template and apply it; the build
// script concatenates the Pandoc-converted body of every chapter after this
// file, so that body becomes the `body` argument of `book()` through the
// selector-less show rule.
//
// The imports use absolute paths from the project root, so the build must run
// with `--root` pointing at the repository (which the build scripts do).

#import "/examples/115-oreilly-book-template/template/book.typ": book
#import "/examples/115-oreilly-book-template/template/admonitions.typ": note, tip, important, warning, caution
#import "/examples/117-pandoc-book-build/cover.typ": cover

// Apply the template. The build-specific choices are the book's metadata, the
// cover (an O'Reilly-homage animal cover, see cover.typ), and the page size:
// example 115's sampler uses the template's small default page, but a ~300-page
// book with wide code listings wants the room, so we pass an A4.
#show: book.with(
  title: "Learning Typst",
  subtitle: "A hands-on guide to the Typst typesetting system",
  author: "Lars De Richter, with Claude (Opus 4.8)",
  cover: cover,
  width: 21cm,
  height: 29.7cm,
  margin: (x: 2cm, top: 2.2cm, bottom: 2cm),
)

// The Pandoc-converted body of every chapter is concatenated below this line.
