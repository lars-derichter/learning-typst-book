# Building the book

The template is done. Chapter 22 spent its whole length building one: a
`book()` function that draws a title page and a table of contents, a `part()`
divider, running heads that never lie, admonition boxes, themed code, a
generated index — the entire look of a book, decided once and bottled up in a
folder called `template/`. It compiles to a handsome eleven-page sampler.

A sampler is not a book. A book is fifteen chapters, a preface, a copyright
page, two appendices and an index; it is page numbers that turn from roman to
arabic somewhere near the start; it is a diagram that has to sit beside the
chapter that mentions it, and a heading that keeps trying to fall off the bottom
of a page. None of that is design work — the design is finished. It is
*assembly*, and assembly has its own problems, most of which only show up once
the document gets long enough to have them.

This chapter takes the Chapter 22 template and builds an actual book with it.
The whole thing is `examples/116-assembling-a-book/`, and the first thing to
notice is that we do not open the template folder even once. We import it and
use it. That is the entire promise of a template, finally cashed.

## The book as a manifest

Here is the complete `main.typ` for our little book, an almanac of weather. Read
it top to bottom; there is nothing hidden.

```typ
#import "../115-oreilly-book-template/template/book.typ": book, part
#import "../115-oreilly-book-template/template/index.typ": make-index

#show: book.with(
  title: "The Weather Almanac",
  subtitle: "A very small book, assembled from parts",
  author: "M. Cumulus",
)

#part[Fair weather]
#include "chapters/01-a-clear-morning.typ"
#include "chapters/02-the-noon-sun.typ"

#part[Rough weather]
#include "chapters/03-the-gathering-storm.typ"

#make-index()
```

(That is the shape of it — we will add the front and back matter in a moment.)
The first two lines reach *across* to another example folder and pull in the
template by a relative path: `../115-oreilly-book-template/template/book.typ`.
The template is not copied, not vendored, not reimplemented — it is imported,
exactly the way Chapter 18 imported a library. A different book would import the
same file and get the same design. That is what "reusable" means when it is
true and not just claimed.

Everything after the imports is content, and there is almost none of it. A
`#show: book.with(...)` applies the whole design (Chapter 19). Then the file is
nothing but `#part[...]` dividers and `#include` lines. It reads like a table of
contents because that is precisely what it is: a manifest that names the parts
of the book and the order they go in. The writing lives elsewhere; `main.typ`
just says how the pieces fit.

> [!NOTE]
> Because `main.typ` imports a file *outside* its own folder, you compile it
> from the repository root and tell Typst where the root is:
> `typst compile --root . examples/116-assembling-a-book/main.typ book.pdf`.
> The `--root` flag sets the boundary that relative paths may cross. Without it,
> Typst refuses to read files above the input's own directory — a safety fence,
> not a bug.

## One file per chapter

The alternative to this is a single enormous `main.typ` with all fifteen
chapters pasted into it, and you do not want it. A thousand-line file is slow to
scroll, murder to search, and a nightmare the moment two people edit it at once.
Splitting the book into one file per chapter is the same instinct that put the
template's machinery in separate files — keep each thing small enough to hold in
your head — applied to the writing instead of the design.

The tool for the splice is `#include`, and its difference from `#import`
matters. `#import` pulls *definitions* — functions, variables — out of a file so
you can call them. `#include` pulls the *rendered content* of a file and drops
it into the document right there, as if you had typed it. You import the
template because you want its `book()` function; you include a chapter because
you want its words on the page. Chapter 18 drew that line; here is where it
earns its keep.

A chapter file, then, is almost pure content. It imports the components it
happens to use and then just writes:

```typ
#import "../../115-oreilly-book-template/template/admonitions.typ": *
#import "../../115-oreilly-book-template/template/index.typ": idx

= A clear morning

#lorem(45) The technical name for the calm is an #idx("anticyclone"): a broad
region of sinking air where the sky stays clear for days.

#note[ #lorem(24) ]
```

The `=` becomes a full chapter opener, the `#note[...]` becomes an O'Reilly box,
the `#idx("anticyclone")` records an index entry — and the person writing this
chapter thought about none of it. They wrote a heading, a note, and a marked
term. The template did the rest, three folders away.

### Assets live next to the chapter that needs them

Chapter 2 of the almanac has a little diagram of the sun, and the image file
sits right beside the chapter that uses it, in `chapters/`:

```typ
#figure(
  image("sun-diagram.svg", width: 3.5cm),
  caption: [A schematic noon sun. The image file lives beside this chapter.],
)
```

The path `"sun-diagram.svg"` has no folders in it, and that is the point. In
Typst a file path is resolved relative to the file it is *written in*, not
relative to `main.typ` and not relative to wherever the content ends up after
`#include`. So `image("sun-diagram.svg")` inside `chapters/02-the-noon-sun.typ`
looks in `chapters/`, finds the file next to it, and renders it — even though
the figure will land pages away in the finished book. Keep a chapter's images in
its own folder and you can move, rename, or delete the whole chapter without
hunting down assets scattered across the project.

## Front matter, body, and back matter

Open any real book to the first pages and the page numbers are lowercase roman:
i, ii, iii. That run — title page, copyright, preface, contents — is the *front
matter*, and it is numbered separately so that the publisher can add or drop a
foreword at the last minute without renumbering the whole book. Then the body
begins and the numbers restart at a proud arabic **1**. At the end comes the
*back matter*: appendices, the index, a colophon, numbered right along with the
body.

Our template already draws the title page and contents, and it already restarts
the page counter at 1 before the body. What it does not do is give us a roman
front matter of our own — a copyright page, a preface. Adding that is an
assembly job, and it is the one genuinely fiddly thing in this chapter, so we
will take it slowly.

The mechanism is two page settings and a counter reset. To number a run of pages
in roman, you set the page's numbering pattern to `"i"`; to switch to arabic and
start over, you set it to `"1"` and reset the page counter:

```typ
#set page(numbering: "i")     // front matter: i, ii, iii …
// … copyright, preface …
#counter(page).update(1)      // restart the count
#set page(numbering: "1")     // body: 1, 2, 3 …
```

That is the whole idea, and in a book built from scratch it is all you need.
Our book has one wrinkle: the Chapter 22 template installed an *explicit* footer
for the body — it prints the number itself rather than letting the page's
`numbering` field do it. So for the front matter we hand those pages their own
automatic footer with `footer: auto`, which does read the `numbering` field and
prints our roman numeral. We wrap the whole front matter in a `#[...]` block so
that the moment it closes, the template's own header and footer snap back for
the body:

```typ
#show: book.with( /* … title, subtitle, author … */ )

// FRONT MATTER — roman, its own footer, no running head
#[
  #set page(header: none, footer: auto, numbering: "i")
  #counter(page).update(1)
  #include "front/copyright.typ"
  #include "front/preface.typ"
]

// BODY — restart at arabic 1
#set page(numbering: "1")

#part[Fair weather]
#counter(page).update(1)
#include "chapters/01-a-clear-morning.typ"
```

Scoping the front-matter settings inside `#[...]` is the trick that keeps this
honest: a `set` rule lasts only to the end of the block it lives in (Chapter 9),
so the template's running head and arabic footer return untouched afterward, and
we never had to reach into the template to change them. The counter reset just
before Chapter 1 makes the first chapter's page read **1** even though a part
divider sits in front of it — the divider is unnumbered, so the reader's eye
lands on a clean 1 at the top of the body.

Compile it and the numbers behave: the copyright page is *i*, the preface *ii*,
and Chapter 1 opens on *1*. The front-matter pages carry no running head; the
body pages carry the chapter name, drawn by the template's `query`-based header
from Chapter 22. The transition is invisible, which is exactly how a reader
should experience it.

The front-matter files themselves are deliberately plain. A preface is *not* a
chapter, so it must not be a `=` heading — that would trip the chapter-opener
show rule and grow a giant "CHAPTER" masthead. Instead it draws its own modest
title by hand, the same move the template uses for "Contents" and "Index":

```typ
#text(font: font-head, size: 20pt, weight: "bold", fill: ink)[Preface]
#line(length: 100%, stroke: 0.6pt + accent)
#lorem(55)
```

The back matter follows the same rule. Appendix A draws an "APPENDIX A" kicker
and its title by hand rather than as a heading, so it stays out of the chapter
numbering, and then `#make-index()` — imported from the template — queries every
`#idx(...)` marker the chapters left behind and builds the index page. In the
finished almanac the index reads `anticyclone … 1`, `insolation … 2`,
`barometer … 5`, and every one of those numbers was discovered by the compiler,
not typed by us.

> **Coming from LaTeX.** You have met all of this before under other names.
> `#include` is `\include`, and if you want to compile just two chapters while
> you work, you would reach for `\includeonly{...}` — in Typst you comment out
> the `#include` lines you are not using, no separate command needed. The
> roman-then-arabic dance is `\frontmatter`, `\mainmatter`, and `\backmatter`
> from the `book` class, which flip the page numbering and (for `\frontmatter`)
> unnumber the chapters. The difference is that those are opaque commands you
> trust; here the same behavior is three lines of `set page` and a counter
> reset, sitting in plain sight in your own `main.typ`, doing exactly and only
> what they say.

## Building it

The build is one command:

```sh
typst compile --root . examples/116-assembling-a-book/main.typ book.pdf
```

Point Typst at the manifest, name the output, and a few milliseconds later
`book.pdf` exists. That speed is not a party trick; it is the thing that makes a
long document bearable to work on. But you do not want to retype that command
after every edit, so for the actual writing loop you use `watch`:

```sh
typst watch --root . examples/116-assembling-a-book/main.typ book.pdf
```

Now Typst sits in the background and rebuilds the moment you save any file the
book depends on — a chapter, an image, the template, `main.typ` itself. Keep the
PDF open in a viewer that reloads on change and you have a live preview of the
whole book beside your editor.

Here is where Typst's incremental compilation, promised back in Chapter 1, pays
off at scale. When you change one word in Chapter 9, Typst does not re-typeset
Chapters 1 through 8; it recomputes only what your edit touched and reuses the
rest. A three-hundred-page book stays as responsive to edit as a three-page one.
Anyone who has waited out a LaTeX build on a long document, gone to make tea,
and come back to a warning about an underfull box knows exactly how large a
mercy this is.

## Problems that only appear at length

A one-page example never strands a heading or lands a chapter on the wrong side
of a spread, because it has no length for those problems to hide in. A real book
has plenty. Here are the ones you will actually hit, and the one-line fixes.

**Chapters should start on a right-hand page.** Open a printed book and every
chapter begins on a *recto* — the right-hand page, odd-numbered — even when that
leaves the previous left-hand page half empty. To force it, break to the next
odd page before the chapter:

```typ
#pagebreak(to: "odd")
= The gathering storm
```

`pagebreak(to: "odd")` skips to the next odd page number, inserting a blank
left-hand page if it has to. In a `main.typ` you would put it before the
`#include` of any chapter you want on a recto, or fold it into the template's
chapter-opener show rule to make it automatic for every chapter. (For a
screen-only PDF that nobody will print double-sided, leave it off — recto starts
are a courtesy to the binding, and they waste paper you do not have.)

**Headings must not strand at the foot of a page.** A heading that prints as the
last line of a page, with its section starting overleaf, is an orphan, and it
looks like a mistake because it is one. Typst prevents it by default: a heading
is *sticky*, meaning it refuses to be separated from the content beneath it and
drags itself to the next page rather than sit alone at the bottom. The catch is
that a show rule which rebuilds a heading into a plain `block` — as the template
does for chapter openers — can quietly drop that stickiness. If you ever see a
rebuilt heading strand, put the stickiness back explicitly:

```typ
show heading: it => block(sticky: true, it)
```

A `sticky` block clings to whatever block follows it, which is the whole of what
"keep this heading with its text" means.

**The table of contents grows too long.** The template's contents lists
headings down to level 2 (`depth: 2`). That is fine for three chapters and
overwhelming for thirty — a contents page that runs to four pages of
sub-sub-sections is a contents page nobody reads. The fix is one number: set the
outline's `depth` to `1` and list chapters only.

```typ
#outline(title: none, depth: 1)
```

It is worth knowing this lives in the template's contents helper, so changing it
is a one-word edit in one place, and every book built from the template inherits
the shorter contents.

**Assets multiply.** We covered the mechanism above — paths resolve relative to
the file that names them — but the discipline is what matters at length. With
forty figures across fifteen chapters, a flat `images/` folder becomes a swamp
of `figure1.png`, `figure1-final.png`, `figure1-final-v2.png`. Keep each
chapter's assets in the chapter's folder, named for what they are, and the
swamp never forms.

## Where this is going

Notice what we did *not* do in this chapter: write any prose. The almanac's
chapters are `#lorem` filler, because the point was the scaffolding — the
manifest, the includes, the numbering, the build. In a real project you would
now sit down and write, in Typst markup, chapter by chapter, and the book would
grow.

That is one honest way to make a book, and for a book conceived in Typst it is
the right one. But you might already have your chapters written — in Markdown,
say, because that is where the words started, or because a co-author will only
touch Markdown, or because the book has to publish to the web as well as to
print. Retyping all of it into Typst markup would be daft.

You do not have to. In Chapter 24 we close the loop the preface promised: a
pipeline that runs Markdown through Pandoc, converts it to Typst, and pours it
into a template exactly like this one — `#include`, front matter, index and all.
It is how *this* book is built. The assembly you just learned is the target that
pipeline aims at; now we automate the aiming.

## What you've got

You can now take a finished template and build a real book on top of it:

- **A book as a manifest** — a `main.typ` that imports the template by relative
  path and then does nothing but list `#part[...]` dividers and `#include`
  chapter files, so the structure of the book is visible at a glance.
- **One file per chapter** — content split into small files spliced with
  `#include` (rendered content) rather than `#import` (definitions), each
  chapter's images living in the chapter's own folder.
- **Roman front matter and an arabic body** — `set page(numbering: "i")` for the
  front matter, a `counter(page).update(1)` and `set page(numbering: "1")` to
  restart the body, all scoped in a block so the template's own header and
  footer return by themselves.
- **Back matter** — an appendix drawn by hand to stay out of the chapter
  numbering, and an index generated from the markers the chapters left behind.
- **A build loop that scales** — `typst compile` for a one-shot build,
  `typst watch` for live editing, and incremental compilation keeping both fast
  no matter how long the book gets.
- **The at-length fixes** — `pagebreak(to: "odd")` for recto chapter starts,
  `block(sticky: true)` to keep a heading with its text, `depth` to tame a long
  contents, and a folder discipline that keeps assets from breeding.

## Exercises

*Solutions are in [Appendix A](25-appendix-a-solutions.md).*

23.1. Take `examples/116-assembling-a-book/` and add a fourth chapter. Write a
short `chapters/04-the-clearing.typ` with a `=` heading and a paragraph of
`#lorem`, then splice it into `main.typ` with one `#include` line under the
second `#part`. Recompile and confirm it appears as Chapter 4, in the contents,
with the right page number — all from a single added line.

23.2. Add a second front-matter page: a dedication, between the copyright page
and the preface. It must be numbered in roman like its neighbours and must *not*
be a `=` heading (so it grows no chapter masthead). Confirm the preface's page
number shifts from *ii* to *iii* to make room, without you touching any number
by hand.

23.3. Make every chapter start on a right-hand page. Add `#pagebreak(to: "odd")`
before each chapter's `#include` in `main.typ`, recompile, and read the page
numbers: some chapters should now begin on odd pages with a blank left-hand page
inserted before them. Then explain, in a sentence, why you might *not* want this
for a PDF that will only ever be read on screen.

23.4. Shorten the table of contents. In the template's contents helper
(`_contents-page` in `book.typ`), change the outline's `depth` from `2` to `1`
so the contents lists chapters but not their sections. Recompile the almanac and
confirm the change; then note what you would have had to do instead if the
`depth` had been hard-coded in fifteen different places rather than one.

23.5. *(Stretch.)* Give the book a real "half-title then title" opening and a
back-matter colophon. Add a front-matter page before the template's title page
that shows just the book's title in small caps (you will need to place it inside
the front-matter block, and think about whether the template lets you put
anything *before* its own title page — if not, say why, and put your half-title
first in the roman run instead). Then add a colophon as the very last page,
after the index: a short paragraph naming the fonts and the tool, drawn by hand
like the appendix. Compile and page through the result; you now have a book with
a proper front and back, assembled entirely from parts you imported.

<!--
SOLUTIONS (notes for the appendix author):

23.1 - Create chapters/04-the-clearing.typ:
         = The clearing
         #lorem(60)
       (optionally import idx/admonitions like the others). In main.typ, add
         #include "chapters/04-the-clearing.typ"
       under the `#part[Rough weather]` block, after chapter 03's include.
       Recompile with `typst compile --root . examples/116-assembling-a-book/
       main.typ out.pdf`. It appears as Chapter 4 (heading counter continues),
       lands in the #outline automatically, page number discovered by query.
       Point: adding content is a one-line edit to the manifest.

23.2 - Create front/dedication.typ with NO `=` heading, e.g.:
         #v(1fr)
         #set align(center)
         #emph[For everyone who checks the sky before leaving the house.]
         #v(1fr)
       In main.typ, inside the front-matter #[...] block, add
         #include "front/dedication.typ"
       between the copyright and preface includes (add a #pagebreak(weak: true)
       if you want it on its own page — copyright's trailing #v may not force a
       break). Because roman numbering is automatic, the preface renumbers from
       ii to iii on its own. Point: none of the numbers are typed; the counter
       does the bookkeeping.

23.3 - Before each chapter include in main.typ:
         #pagebreak(to: "odd")
         #include "chapters/01-a-clear-morning.typ"
       Recompile; chapters now start on odd (recto) pages, Typst inserting a
       blank verso where needed. On-screen reason not to: a single-column PDF
       read on a phone/laptop has no left/right spread and no binding, so the
       inserted blank pages are just wasted scroll — recto starts are a
       print-binding courtesy. Could also be folded into the template's level-1
       heading show rule (replace pagebreak(weak: true) with
       pagebreak(weak: true, to: "odd")) to make it automatic and still collapse
       when already on an odd page.

23.4 - In book.typ, _contents-page(): change
         outline(title: none, depth: 2, indent: 1.2em)
       to depth: 1. Recompile: contents lists only the level-1 chapter lines,
       no level-2 sections. If depth had been repeated in many places you would
       have had to find and change every one and risk missing some — the whole
       argument for the theme/constants layering of Chapter 22. Here it is one
       edit in one file.

23.5 - Half-title: the template's book() draws its title page as the first thing
       in the front matter, before body, so you cannot inject a page *before* it
       from main.typ without editing the template. Correct answer: acknowledge
       that, and place a half-title as the first page of the roman front-matter
       block instead (it will follow the template's full title page, which is
       the usual order anyway: full title, then… actually half-title
       conventionally
       precedes the title page — so the honest note is that with this template
       the half-title has to come after, OR you add it inside the template; both
       are acceptable if reasoned). Half-title content, no heading:
         #v(2fr)
         #set align(center)
         #smallcaps(text(size: 18pt)[The Weather Almanac])
         #v(3fr)
       Colophon after #make-index(), drawn by hand like the appendix:
         #pagebreak(weak: true)
         #v(1fr)
         #set align(center)
         #set text(size: 9pt, fill: muted)
         Set in Libertinus Serif and New Computer Modern. \
         Typeset with Typst.
         #v(1fr)
       Point: front and back matter are just content you place around the body;
       the template gives you the fonts and colours to make them match. Credit
       any version that reasons correctly about ordering and keeps the extra
       pages out of the chapter numbering (no `=` headings).
-->
