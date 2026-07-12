// back-matter.typ — the pages that close the book.
//
// The build script concatenates this file *after* the Pandoc-converted body,
// so it becomes the tail end of the same document the Chapter 22 template
// styles. These pages give the standalone PDF what a distributed book needs and
// the Markdown chapters don't carry: an "About the authors" note, a colophon
// with the licence, and a back-cover blurb.
//
// "About the authors" and "Colophon" are real *unnumbered* headings — like the
// Preface and the appendices — so the template styles them as front/back-matter
// openers and, crucially, lists them in the table of contents. The back cover
// is a bare `#page` with no heading, so it stays out of the outline. Paths are
// absolute from the repo root because the build compiles with `--root` at the
// repository.

#import "/examples/115-oreilly-book-template/template/theme.typ": *

// A small helper: one Creative Commons badge, sized to sit in a row.
#let _cc-badge(name) = image(
  "/examples/117-pandoc-book-build/assets/cc/" + name + ".svg",
  height: 11mm,
)

// A name label above each bio / block.
#let _byline(name) = text(font: font-head, size: 12pt, weight: "bold", fill: accent)[#name]

// The back matter reads as flowing prose under its openers, not indented like
// running body paragraphs.
#set par(first-line-indent: 0pt, justify: true, leading: 0.62em)

// === About the authors =====================================================
// An unnumbered level-1 heading: the template gives it a front-matter opener
// (title + rule, no "CHAPTER n") and an outline entry.
#heading(level: 1, numbering: none)[About the authors]

#_byline[Lars De Richter]
#parbreak()
Lars De Richter is a lecturer at Thomas More Hogeschool in Flanders and, at the
time of writing, a master's student in educational sciences — a formal way of
saying he is professionally curious and has the transcripts to prove it. He
learns things by building them, a habit that explains how someone who had known
Typst for all of a few weeks came to commission, direct, and quality-control an
entire book about it. He wrote none of these chapters and is answerable for
every one of them: the brief, the standard, the pointed feedback, and the
refusal to ship anything that didn't actually compile. He works in Flemish
Dutch, thinks in diagrams, and holds that the fastest way to understand a tool
is to make it do something real. This book was that something.

#v(1.1em)
#_byline[Claude (Opus 4.8)]
#parbreak()
Claude is a large language model made by Anthropic, and the closest thing this
book has to a ghostwriter who works for electricity. It produced most of the
words you just read, none of which it can remember writing, and it has never
once seen a page it typeset — it cannot see, and it has firm opinions about
kerning regardless. Its relationship with the truth is enthusiastic but wants
supervision: left to itself it will write ninety-odd thousand confident words
and a handful of links that lead nowhere, which is precisely what happened until
a human noticed. What it is genuinely good at is turning a clear standard into a
great deal of careful, consistent prose very quickly — and then re-compiling
every example to check its own homework, because the one editor it could not
talk its way past was the Typst compiler, which either builds the file or does
not. Every example in this book builds. That part, at least, it can promise.

// === Colophon ==============================================================
#heading(level: 1, numbering: none)[Colophon]

This book was written in Markdown, converted to Typst with Pandoc, and typeset
by Typst 0.15.0 — using the very book template it builds by hand in Chapter 22.
There was no separate design step: the pipeline that produced this PDF is the
one the book teaches, run on the book's own source. Every code example was
compiled against a real Typst binary before it earned its place; nothing here
is a snippet that merely looks as though it would work.

#parbreak()
It is set in Libertinus Serif, with New Computer Modern for titles and headings
and DejaVu Sans Mono for code — three faces that ship with Typst, so the book
renders the same on any machine. The whole process, from the first prompt to
the managing-editor-and-sub-agents workflow that ran it, is documented openly
at #link("https://github.com/lars-derichter/learning-typst-book")[github.com/lars-derichter/learning-typst-book].

#v(1.4em)
#line(length: 100%, stroke: 0.5pt + hairline)
#v(1.1em)

#_byline[Licence]
#parbreak()
#grid(
  columns: (auto, 1fr),
  column-gutter: 14pt,
  align: (left + horizon, left + horizon),
  box(stack(dir: ltr, spacing: 7pt,
    _cc-badge("cc"), _cc-badge("by"), _cc-badge("nc"), _cc-badge("sa"),
  )),
  [
    #text(font: font-body, size: size-body)[
      _Learning Typst_ — its text and its example code — is released under a
      Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International
      licence. Share it, remix it, teach from it; just credit the source, don't
      sell it, and pass on the same freedoms. Full terms:
      #link("https://creativecommons.org/licenses/by-nc-sa/4.0/")[creativecommons.org/licenses/by-nc-sa/4.0].
    ]
  ],
)

// === Back cover ============================================================
// A bare page with no heading, so it never enters the outline.
#page(header: none, footer: none)[
  #set par(first-line-indent: 0pt, justify: false, leading: 0.7em)
  #set align(center)
  #v(1fr)
  #text(font: font-head, size: 20pt, weight: "bold", fill: accent)[
    Typesetting that gets out of your way
  ]
  #v(1.4em)

  #set align(left)
  #block(width: 88%, inset: (x: 0pt))[
    #set text(font: font-body, size: 11pt, fill: ink)
    Typst is what you get if you cross the readability of Markdown with the power
    of LaTeX and hand the result to people who like fast feedback and error
    messages that make sense. _Learning Typst_ teaches it from `= Hello` to
    writing your own packages — and then does the thing few programming books
    dare: it turns around and typesets *itself* with the very tools it just
    taught you.

    #v(0.6em)
    You don't need to know LaTeX. You don't need to be a programmer. You need a
    plain-text editor, a little curiosity, and the willingness to run a few
    examples — every one of which, in this book, genuinely compiles.

    #v(0.8em)
    #text(font: font-head, weight: "bold", fill: ink)[By the end you can:]
    #v(0.2em)
    #list(
      spacing: 0.6em,
      [set clean documents, tables, and math that behaves;],
      [bend the defaults with set and show rules;],
      [write real Typst code — functions, data, and state;],
      [build a reusable book template and hand it to other people;],
      [turn a folder of Markdown into a finished PDF.],
    )
  ]
  #v(1.2fr)

  #line(length: 40%, stroke: 0.6pt + hairline)
  #v(0.8em)
  #text(font: font-head, size: size-small, fill: muted)[
    Written by a human directing an AI, under human quality control — and honest
    about it. Free to share under CC BY-NC-SA 4.0.
  ]
  #v(1fr)
]
