# Designing a book template

You have three chapters. Each lives in its own file, each is full of headings
and code and the occasional boxed aside, and each compiles on its own into a
perfectly nice little PDF. What you do not have is a *book*. A book is the thing
that wraps those three files in a shared design — a title page, a table of
contents, running heads that name the current chapter, part dividers, page
numbers that agree with the contents, an index at the back — so that the three
files stop being three documents and become Chapter 1, Chapter 2, and Chapter 3
of one.

That wrapper is a template. You built a small one in Chapter 19: a function that
takes the document `body`, dresses it in set and show rules, and hands it back,
applied with a single `#show: article.with(...)`. Everything in this chapter is
that same function, grown until it can typeset a book — this book, in fact. We
are going to design a real, reusable, O'Reilly-style book template, walk through
it a file at a time, and by the end you will understand how every book-length
document is assembled from parts.

The whole thing lives in `examples/115-oreilly-book-template/`. It compiles to
an eleven-page book with a cover, a contents page, two part dividers, three
short chapters, and a working index. Open it alongside this chapter; we will
read it piece by piece, and it is worth having the finished PDF in view while we
do.

## The shape of the project

A book is too big to live in one file, so the first design decision is how to
split it up. Here is the whole project:

```text
main.typ                 the entry point: metadata + content
template/
  theme.typ              colors, fonts, sizes — the knobs
  book.typ               the book() template and part() divider
  admonitions.typ        the note / tip / warning boxes
  code.typ               show rules that theme code blocks
  index.typ              idx() and make-index()
chapters/
  01-getting-started.typ
  02-first-document.typ
  03-automating.typ
```

The split is not arbitrary. Everything under `template/` is *machinery* — the
design, written once, that you would reuse for the next book without changing a
line. Everything under `chapters/` is *content* — the actual writing, which
changes with every book. And `main.typ` is the thin seam between them: it names
the book, applies the template, and lists the chapters. This is the same
division you drew in Chapter 18 between a library and the document that imports
it, and the same one Chapter 19 drew between a template file and the document
that applies it. A book is just where the division finally earns its keep,
because there is enough of both kinds of thing that keeping them apart actually
matters.

We will build it from the inside out: constants first, then the template that
uses them, then the components, then the index, and finally the `main.typ` that
ties it all together.

## The theme: every knob in one place

Open `template/theme.typ` and there is not a single function in it — only
values:

```typ
#let font-body = "Libertinus Serif"     // body text
#let font-head = "New Computer Modern"  // titles, headings, labels
#let font-mono = "DejaVu Sans Mono"     // code

#let ink = luma(25)             // body text
#let accent = rgb("#0b7285")    // headings, rules, the house colour
#let muted = luma(120)          // page numbers, captions
#let hairline = luma(205)       // thin rules

#let size-body = 10pt
#let size-code = 8.5pt
```

This is the "constants at the top" habit from Chapter 18, pulled out into a file
of its own. Every other file in the template imports these names and refers to
`accent` and `font-head` rather than hard-coding `rgb("#0b7285")` and
`"New Computer Modern"` in fifteen places. The payoff is the one Chapter 18
promised: to reskin the entire book — a green house colour, a different heading
font — you edit `theme.typ` and nothing else. The rest of the template does not
know or care what the values are, only what they are *called*.

All three fonts are ones Typst bundles, so the book compiles to the same pages
on anyone's machine. That is not a small thing for a template you intend to
share; a template that depends on a font the recipient does not have is a
template that greets them with a warning.

## The template function

Now `template/book.typ`, the heart of it. Strip away the details and `book()`
has exactly the shape Chapter 19 taught:

```typ
#let book(title: none, subtitle: none, author: none, body) = {
  set page(width: 13cm, height: 19cm, margin: (x: 1.8cm, top: 2cm, bottom: 1.8cm),
           header: none, footer: none)
  set text(font: font-body, size: size-body, fill: ink, lang: "en")
  set par(justify: true, leading: 0.62em,
          first-line-indent: (amount: 1.2em, all: false))
  set heading(numbering: "1.1")

  // ... show rules for code and headings ...
  // ... front matter: title page and contents ...

  body
}
```

Configuration parameters first — `title`, `subtitle`, `author` — then `body`
last, because the selector-less show rule always feeds the document in as the
final positional argument. That is the one hard rule from Chapter 19, and it
does not relax just because the function got bigger. The set rules establish the
page (a deliberately small one, 13 by 19 centimetres, so the multipage preview
stays legible), the body font, justified paragraphs, and numbered headings.

The one new touch is `first-line-indent: (amount: 1.2em, all: false)`. Passing a
dictionary instead of a bare length turns on the book convention: indent the
first line of every paragraph *except* the one right after a heading. It is the
kind of detail you never notice when it is right and cannot stop noticing when
it is wrong.

You apply `book()` exactly the way you applied the article template, from the
top of `main.typ`:

```typ
#import "template/book.typ": book, part

#show: book.with(
  title: "Learning Typst",
  subtitle: "A field guide, in miniature",
  author: "Typeset with the Chapter 22 template",
)
```

`book.with(...)` pre-fills the three configuration arguments and leaves `body`
open (that is Chapter 14's partial application); the selector-less `#show:` then
drops the entire rest of the document into that opening (that is Chapter 10's
document-wide show rule). The two halves meet in the middle, precisely as they
did for the small template. Nothing about the idiom changed. What changed is how
much the function does once it has the body.

### Front matter, drawn once

Before the body appears, `book()` lays down the front matter — the title page
and the contents — by calling two small helpers. The title page is an isolated
`#page`, the manual-layout trick from Chapter 21:

```typ
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
  #if author != none { text(font: font-head, size: 13pt)[#author] }
  #v(2fr)
]
```

Calling the `page` function (rather than the `set page` rule) produces a single
self-contained page with its own settings — no running head, no footer — and
whatever comes after it resumes on a new page under the outer settings. Inside,
the `v(3fr)`, `v(1fr)`, `v(2fr)` springs are the fractional spacing from
Chapter 5: they divide the leftover vertical space in a 3:1:2 ratio, floating
the title into the lower-middle of the page and the author toward the foot,
without a single hand-measured margin. And the `if subtitle != none` guards are
the `none`-default habit from Chapter 19 — leave out a subtitle and the line
simply does not appear, rather than leaving a gap.

## Chapters and parts

In this template a chapter is a level-1 heading. You write `= Installing the
tools` at the top of a chapter file and the template turns it into a full
chapter opener — a page break, a small "CHAPTER 1" kicker, the big title, and a
rule beneath. That transformation is a show rule on `heading.where(level: 1)`,
the function form from Chapter 10:

```typ
show heading.where(level: 1): it => {
  pagebreak(weak: true)
  v(1.4cm)
  block(spacing: 0pt)[
    #text(font: font-head, fill: muted, weight: "bold", size: 10pt, tracking: 2pt)[
      #upper[Chapter] #context counter(heading).display("1")
    ]
    #v(0.35em)
    #text(font: font-head, fill: ink, weight: "bold", size: 23pt)[#it.body]
    #v(0.45em)
    #line(length: 100%, stroke: 0.8pt + accent)
  ]
  v(0.9em)
}
```

The heading arrives as `it`, we read its text off `it.body`, and we rebuild it
into whatever we like — here, a two-line masthead. The chapter number comes from
`counter(heading).display("1")`, read inside a `#context` because, as Chapter 17
drilled in, a counter's value depends on where you are and can only be read once
Typst knows. The `pagebreak(weak: true)` starts each chapter on a fresh page;
`weak` means it collapses to nothing if we are already at the top of one, so no
blank pages pile up. The two deeper levels get the gentler show-set treatment —
recoloured and set in the heading font, keeping their automatic `1.1` numbering:

```typ
show heading.where(level: 2): set text(font: font-head, fill: accent, size: 12.5pt)
show heading.where(level: 3): set text(font: font-head, fill: ink, size: 10.5pt)
```

Parts are the level above chapters, and they need a different mechanism.
Chapters number continuously through the whole book — Chapter 1, 2, 3, across
every part — so a part cannot simply be a higher heading level, because the
heading counter would reset the chapter number in each part. Instead, `part()`
is a plain function with a counter of its own:

```typ
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
```

`counter("part")` is a named counter you invent — the custom-counter idea from
Chapter 17 — untouched by anything Typst counts on its own. Each call steps it
and prints the value as a roman numeral with `.display("I")`, on its own
vertically centred page (`align(center + horizon)` inside an isolated `#page`).
Because parts live outside the heading counter, they stay out of the chapter
numbering entirely, which is exactly what we want.

> [!NOTE]
> The trade-off of keeping parts out of the heading system is that `#outline`
> does not list them, since it collects headings. Adding the parts to the
> contents page is a genuinely instructive exercise — you would query the part
> markers and merge them with the headings by page order — and it is waiting for
> you at the end of the chapter.

## The running head, from `query`

Flip to any body page and the top shows the book title on the left and the
current chapter on the right, over a hairline rule. Getting the *current
chapter* onto every page is the problem Chapter 17 warned you about and
Chapter 21 solved. A running head drawn from `state` reads the state as of the
top of its page, which fails for a chapter that starts halfway down. The fix is
`query`, which sees the whole finished document at once:

```typ
set page(header: context {
  let n = here().page()
  let openers = query(heading.where(level: 1)).map(h => h.location().page())
  if n not in openers {
    let current = none
    for h in query(heading.where(level: 1)) {
      if h.location().page() <= n { current = h }
    }
    let label = if current != none {
      [#numbering("1", ..counter(heading).at(current.location())) — #current.body]
    } else { [] }
    grid(columns: (1fr, auto),
      text(font: font-head, size: size-small, fill: muted, style: "italic")[#title],
      text(font: font-head, size: size-small, fill: muted)[#label])
    v(3pt)
    line(length: 100%, stroke: 0.5pt + hairline)
  }
})
```

Read it from the top. `here().page()` is the number of the page we are drawing
the header for. `query(heading.where(level: 1))` returns every chapter heading
in the book; we walk them and keep the last one whose page is at or before this
one — that is the chapter this page belongs to. From that heading we read its
number with `counter(heading).at(current.location())` (a counter read at *some
other* location, Chapter 17 again) and its title from `current.body`, and set
them at the outer edge. The book title on the other side is just `title`, the
template's own parameter, which the header closure can see because it was
defined inside `book()`.

The little flourish: if the current page is itself a chapter opener — `if n not
in openers` — we draw no header at all, because a running head on a chapter's
first page is a thing careful books do not do. That check is only possible
because `query` already told us which pages the chapter openers landed on.

The footer is the easy sibling, a centred page number read with the same
counter you met in "Page X of Y":

```typ
set page(footer: context {
  set align(center)
  text(font: font-head, size: size-small, fill: muted)[#counter(page).display("1")]
})
```

> **Coming from LaTeX.** This is `\pagestyle{headings}` and the `fancyhdr`
> package, minus the package and minus the incantations (`\leftmark`,
> `\rightmark`, `\markboth`, and the mystery of which one is which). You do not
> configure a mark-passing mechanism; you ask the finished document what chapter
> a page is in and print the answer. And there is no second compile to get it
> right — Typst iterates until the numbers settle, as Chapter 17 explained, so
> the head is correct the first time.

## The contents page

The table of contents is the one place the template does *less* than you might
expect, because Typst does most of it. The whole contents helper is:

```typ
#let _contents-page() = {
  block(above: 0pt, below: 1em)[
    #text(font: font-head, size: 22pt, weight: "bold", fill: ink)[Contents]
    #v(2pt)
    #line(length: 100%, stroke: 0.6pt + accent)
  ]
  show outline.entry.where(level: 1): set text(font: font-head, weight: "bold")
  outline(title: none, depth: 2, indent: 1.2em)
}
```

`#outline()` from Chapter 11 walks the headings, reads each one's page number,
and draws the list with dotted leaders — and because it reads the same heading
structure the running head does, the numbers in the contents and the numbers in
the text can never disagree. We pass `title: none` and draw the "Contents"
heading by hand, so that the outline's title does not get caught by the
chapter-opener show rule and grow a giant "CHAPTER" masthead of its own. The
`show outline.entry.where(level: 1)` rule bolds the chapter lines so they stand
out from their subsections — the same `.where` selector logic, now aimed at
outline entries. `depth: 2` keeps the contents to chapters and their sections;
deeper subsections stay out.

## The admonition boxes

`template/admonitions.typ` is a component library in the Chapter 18 sense: a
handful of related functions built on the shared theme. There is one general
box and five named variants. The general one is the content-argument pattern
from Chapter 14 — `body` first, options named with defaults:

```typ
#let admonition(body, kind: "Note", color: note-color) = block(
  fill: color.lighten(90%),
  stroke: (left: 3pt + color),
  inset: (x: 10pt, y: 8pt),
  radius: (right: 3pt),
  width: 100%,
)[
  #text(font: font-head, fill: color, weight: "bold", size: size-small,
        tracking: 0.6pt)[#upper(kind)]
  #v(-0.35em)
  #set par(first-line-indent: 0pt)
  #body
]
```

A block, tinted with a very light version of the box's colour
(`color.lighten(90%)`), a solid rule of that colour down the left edge, a bold
uppercase label, and then the body. Because `body` is the last parameter, the
trailing-content sugar works and you call it `#note[...]` with the text in
brackets, exactly like a built-in — that is the whole reason Chapter 14 told you
to put `body` last.

The five variants are not five more functions. They are one function with its
arguments pre-filled, using `.with` from Chapter 14:

```typ
#let note = admonition.with(kind: "Note", color: note-color)
#let tip = admonition.with(kind: "Tip", color: tip-color)
#let important = admonition.with(kind: "Important", color: important-color)
#let warning = admonition.with(kind: "Warning", color: warning-color)
#let caution = admonition.with(kind: "Caution", color: caution-color)
```

Each is `admonition` with its label and colour baked in and the `body` still
open. A chapter file imports the lot with `#import
"../template/admonitions.typ": *` and writes `#warning[...]`; you get an orange
box with a "WARNING" label. Improve the box once — more padding, a rounder
corner — and all five improve together, because there is only ever one box.

## Theming the code blocks

`template/code.typ` is a single function that installs show rules on `raw` — the
code element — and returns the body wearing them, the whole-document `show:`
shape from Chapter 10:

```typ
#let code-rules(body) = {
  show raw: set text(font: font-mono)
  show raw.where(block: false): box.with(
    fill: code-bg, inset: (x: 3pt), outset: (y: 3pt), radius: 2pt,
  )
  show raw.where(block: true): it => block(
    fill: code-bg, stroke: (left: 2pt + accent),
    inset: (x: 9pt, y: 8pt), radius: (right: 3pt), width: 100%,
    text(size: size-code, it),
  )
  body
}
```

Three rules, each aimed with the `.where` selectors from Chapter 10. Every code
span, inline or block, gets the mono font. Inline code — `raw.where(block:
false)` — is wrapped in a small tinted `box.with(...)` so a term like `main.typ`
reads as a chip in the middle of a sentence. Block code — `raw.where(block:
true)` — gets the full O'Reilly listing: a light fill, a coloured rule down
the left, generous padding. Notice `box.with(...)` on the right of a show rule:
the matched element becomes the box's final argument, so the rule wraps each
inline snippet in a configured box. `book()` switches the whole thing on with
one line, `show: code-rules`, and Typst's own syntax highlighter colours the
keywords inside for free.

## The index

The index is the piece that shows off the most machinery, because a
back-of-the-book index is exactly the kind of thing you cannot type by hand and
keep correct. It comes in two halves, in `template/index.typ`.

The first half is a marker you scatter through the prose. `#idx("compiler")`
prints the word *and* records it:

```typ
#let idx(term) = [#metadata(term)<index-entry>#term]
```

`metadata` places an invisible value into the document — the term string — and
the `<index-entry>` label tags it so we can find it again. The `#term` after it
prints the word in the running text. That is all a marker is: a labelled,
invisible note that says "the topic *compiler* is discussed right here."

The second half runs at the back of the book and builds the page:

```typ
#let make-index() = {
  pagebreak(weak: true)
  // ... draw the "Index" title by hand ...
  context {
    let entries = query(<index-entry>)
    let pages = (:)
    for e in entries {
      let term = e.value
      let p = counter(page).at(e.location()).first()
      let seen = pages.at(term, default: ())
      if p not in seen { seen.push(p) }
      pages.insert(term, seen)
    }
    // ... lay out sorted terms with their page lists ...
  }
}
```

This is Chapter 21's `query` doing the thing Chapter 21 said it could do that
`#outline` cannot. `query(<index-entry>)` returns every marker in the finished
book. For each one, `e.value` is the term we stored and `counter(page).at(e.
location())` is the page it landed on — a counter read at another element's
location, one more time (Chapter 17). We group the pages under each term in a
dictionary, dropping duplicates, then sort the terms alphabetically and lay them
out in two columns with dotted leaders. The result, on the last page of the
example, reads `compiler ... 3, 4` and `template ... 6, 9`, and every one of
those numbers was discovered, not typed. Move a chapter and they all move with
it.

## Tying it together in `main.typ`

Everything above is machinery. `main.typ` is the book, and it is short:

```typ
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
```

Read it and the whole architecture is visible at a glance. The `#import` lines
pull in the template's functions (Chapter 18). The `#show: book.with(...)`
applies the entire design (Chapter 19). Each `#part[...]` drops a divider;
each `#include` splices in a chapter file's rendered content — `include` for
content, not `import` for definitions, the distinction Chapter 18 drew a sharp
line under. And `#make-index()` at the end builds the index from the markers the
chapters left behind. The design is in one place, the writing in another, and
`main.typ` is the table of contents of the project itself.

The chapter files, in turn, are almost pure content. Each opens with a couple of
imports for the components it uses and then just writes:

```typ
#import "../template/admonitions.typ": *
#import "../template/index.typ": idx

= Installing the tools
Before you can typeset a single page you need the #idx("compiler") ...
#note[ You do not have to install anything at all to try Typst. ... ]
```

That is the point of the whole exercise. The person writing Chapter 1 thinks
about Chapter 1. They write `= Installing the tools` and `#note[...]` and
`#idx("compiler")`, and the template turns those into a chapter opener, an
O'Reilly note box, and an index entry — without the author touching a colour, a
font, or a page number. The design was decided once, in `template/`, and now it
just happens.

> **Coming from LaTeX.** You have just written a document class and its packages
> — a `.cls` and a clutch of `.sty` files — except every one of them is a plain
> Typst file in the same language as the book, readable top to bottom, with no
> `\makeatletter`, no `\RequirePackage`, and no separate class-writing dialect.
> The book's `main.typ` is your `\documentclass{book}` plus `\begin{document}`,
> and it is about as long.

## What you've got

You have built a real book template, and in doing so you have seen every major
idea in the book working at once:

- **A layered project** — constants in `theme.typ`, the template in `book.typ`,
  components in their own files, content in `chapters/`, all wired together by a
  short `main.typ`. Machinery and writing, kept apart (Chapters 18, 19).
- **A template that does front matter** — `book()` takes configuration first and
  `body` last, applied with `#show: book.with(...)`, and lays down a title page
  and a `#outline` table of contents before the body (Chapters 19, 11).
- **Chapter and part openers** — a function-form show rule rebuilds level-1
  headings into chapter openers reading their number from the heading counter;
  a custom `counter("part")` numbers full-page part dividers (Chapters 10, 17).
- **A running head that never lies** — built with `context` and `query`, it
  names the chapter a page belongs to even when the chapter began mid-page, and
  it stays off the opener pages (Chapters 17, 21).
- **Reusable components** — admonition boxes from the content-argument pattern
  and `.with` variants, and code blocks themed by `raw` show rules (Chapters 14,
  10).
- **A generated index** — `idx()` records terms with `metadata` and a label;
  `make-index()` queries them, reads each page with `counter(page).at(...)`, and
  builds the page by hand (Chapters 21, 17).

This is the payoff the whole book was building toward. Set rules, show rules,
functions, closures, `.with`, imports, includes, context, counters, state,
query, `#place`, `#outline` — none of them were the point on their own. The
point was this: enough of them, arranged well, and you can bottle the entire
design of a book and pour it over any content you like.

In Chapter 23 we take this template and assemble a fuller book with it — more
chapters, real front and back matter, the works — and shake out the problems
that only appear at length. Then in Chapter 24 we close the loop the preface
promised: a pipeline that runs Markdown through Pandoc into Typst, feeds it to a
template like this one, and lets a book — this book — typeset itself.

## Exercises

*Solutions are in [Appendix A](25-appendix-a-solutions.md).*

22.1. Reskin the whole book by editing one file. In `theme.typ`, change `accent`
to a colour of your choosing and `font-head` to `"Libertinus Serif"`. Recompile
and confirm that the headings, rules, part and chapter openers, admonition
labels, and index letters all follow — from two edits, in one place.

22.2. Add a sixth admonition. In `admonitions.typ`, define `#let example =
admonition.with(kind: "Example", color: accent)`, export it, and use it in a
chapter file. Confirm it comes out styled like the others with no new box code
written — the whole box already exists, you are only pre-filling it.

22.3. Give the running footer a "page X of Y" instead of a bare number, using
`counter(page).final()` from Chapter 17 (remember `.first()` to pull the integer
out of the array). Check that the total is correct on every page, including the
first and last.

22.4. Add a `date` parameter to `book()` (defaulting to `none`) and print it in
small muted text under the author on the title page — but only when a date is
supplied, guarded with `if date != none`. Apply the template once with a date
and once without, and confirm the dateless cover leaves no empty line.

22.5. *(Stretch.)* Put the parts into the contents page. Have `part()` record
each divider with a `metadata` marker and a label (the way `idx` does), then
build a custom contents page with `context`: `query` both the part markers and
the level-1 headings, sort the combined list by page location, and lay it out so
each part heading sits above the chapters below it. Compare it to the plain
`#outline` version and notice that you have just built something `#outline`
could not — which is the entire reason `query` exists.

<!--
SOLUTIONS (notes for the appendix author):

22.1 - Edit theme.typ only: `#let accent = rgb("#a12f5a")` (any colour) and
       `#let font-head = "Libertinus Serif"`. Everything that references accent
       (headings via the show-set rules, the opener/part/toc rules, admonition
       side-rules and labels through their *-color constants? NO — admonition
       colours are their own constants, so only the accent-driven pieces move:
       heading colour, all the rules, chapter/part kickers, index letters, code
       block left-rule, title-page rule). font-head moves every heading, label,
       kicker, and title to the new font. Point: one file is the single source
       of truth; the rest of the template only ever names the constants. (If a
       student also wants the admonitions to follow accent, they'd point the
       *-color constants at accent too — good extension.)

22.2 - In admonitions.typ:  #let example = admonition.with(kind: "Example",
       color: accent)  and it's already exportable via `*`. In a chapter:
       #example[ ... ]. Output: a tinted block with an "EXAMPLE" label and a
       side rule in accent. Point: .with gives a new configured function with
       zero new box code — the content-argument box is written once.

22.3 - Replace the footer body with:
         Page #counter(page).display("1") of #counter(page).final().first()
       (or the .display("1 of 1", both: true) shorthand). Still inside the
       `context` footer. .final() returns an array; .first() pulls the integer.
       Correct on every page because Typst iterates until the total settles
       (Ch 17). Note the total counts from wherever the page counter was last
       reset — here from the counter(page).update(1) at body start, so "of N"
       reflects the numbered body pages.

22.4 - Signature: #let book(title: none, subtitle: none, author: none,
       date: none, body) = { ... } (date before body). In _title-page, add a
       date param and, after the author line:
         #if date != none { v(0.3em); text(size: 8.5pt, fill: muted)[#date] }
       Pass date from book() into _title-page(title, subtitle, author, date).
       Apply once with date: "July 2026" and once without. Point: none-default +
       if-guard = optional line with no blank when omitted (Ch 19 habit).

22.5 - part() becomes:
         #let part(title) = {
           counter("part").step()
           [#metadata(title)<part-entry>]
           page(...)[ ... existing divider ... ]
         }
       Custom contents page:
         #context {
           let parts = query(<part-entry>).map(e => (kind: "part",
             loc: e.location(), body: e.value))
           let chaps = query(heading.where(level: 1)).map(h => (kind: "chapter",
             loc: h.location(), body: h.body,
             num: counter(heading).at(h.location())))
           let items = (parts + chaps).sorted(key: it => it.loc.position().page)
           // then for each item: if part, big label; if chapter, indented line
           for it in items {
             let p = counter(page).at(it.loc).first()
             if it.kind == "part" { strong(it.body) } else {
               [#h(1em) #numbering("1", ..it.num) #it.body
                #box(width: 1fr, repeat[.]) #p \ ]
             }
           }
         }
       Sorting a mixed list by page location is the crux; .position().page (or
       comparing .page()) gives a sortable key. Point: query sees the whole doc,
       so parts (non-headings) and chapters (headings) can be merged into one
       ordered contents — something #outline, which only knows headings, cannot
       do. Ties the chapter back to Ch 21. Any merged-and-sorted contents
       that shows parts above their chapters passes.
-->
