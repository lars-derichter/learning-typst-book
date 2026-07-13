# Appendix F · Pandoc, in practice

[Chapter 24](24-pandoc-bridge.md) told the story of how this book typesets
itself — the pipeline, the filter, the head that reuses the Chapter 22 template.
This appendix is the other thing: the reference you keep open in a second
window while you work, plus an idea bank for the workflows a Pandoc-and-Typst
setup makes cheap. The story is there; this is the toolbox.

## What Pandoc is

Pandoc is a universal document converter: one program that reads a few dozen
formats and writes a few dozen more. You hand it a Word file and ask for
Markdown; you hand it Markdown and ask for a PDF; you hand it LaTeX and ask for
HTML. It has been the quiet plumbing under half the web's documentation
toolchains for fifteen years, and since version 3.0 it can write Typst.

The one idea that makes everything else fall into place: Pandoc does not convert
format A straight into format B. It goes through the middle. A **reader** parses
your input into an internal document model — an abstract syntax tree, the AST —
and then a **writer** renders that tree in the target format. The AST is a plain
tree of typed nodes: headings, paragraphs, lists, links, code blocks, emphasis.
It knows nothing about `#` or `\section` or `<h1>`; those are just how the gfm
reader and the LaTeX reader and the HTML writer happen to spell a `Header`.

```text
   input  ──▶  reader  ──▶  AST  ──▶  writer  ──▶  output
   (gfm)                  (Pandoc)               (typst)
```

That "AST in the middle" is not a detail — it's the whole reason the tool
scales. Adding a new input format means writing one reader, and it instantly
converts to every existing output. It is also what makes filters make sense: a
filter is a program that edits the tree *after* the reader and *before* the
writer, so you shape the conversion at the structural level instead of hacking
at text. Hold onto that picture; the filters section leans on it entirely.

For a Typst user, a handful of the formats matter. On the way **in**: `gfm`
(GitHub-flavored Markdown, this book's source dialect — new to it?
[Appendix E](29-appendix-e-markdown.md) is a short primer), `commonmark`, Pandoc's
own extended `markdown`, `latex`, `html`, `docx`, and `epub`. On the way
**out**: `typst`, obviously, but also `latex`, `html`, `docx`, and `epub` when
you need to send the same content somewhere Typst doesn't reach. The rest of
this appendix mostly cares about the diagonal from `gfm` (or `docx`, or `latex`)
in to `typst` out.

Where does Pandoc sit next to Typst? They don't compete; they compose. Pandoc
**converts** — it moves content between representations and never lays out a
page. Typst **typesets** — it takes a document and produces the finished,
paginated PDF. Pandoc gets your words *into* Typst; Typst makes them beautiful.
The moment you internalize that division of labour, the "which tool" question
stops being a question.

## The commands worth knowing

The whole surface you need day to day is small. Here are the flags a Typst user
reaches for, then a set of complete command lines for real jobs.

| Flag | What it does |
| --- | --- |
| `-f`, `--from FORMAT` | Input format. `gfm`, `commonmark`, `markdown`, `latex`, `docx`, `html`, `epub`. |
| `-t`, `--to FORMAT` | Output format. `typst`, `latex`, `html`, `docx`, `epub`. |
| `-o`, `--output FILE` | Write to a file. Omit it and Pandoc prints to stdout. |
| `-s`, `--standalone` | Emit a complete document (preamble, wrapper) rather than a bare fragment. |
| `--lua-filter FILE` | Run a Lua filter on the AST, in-process. Repeatable; they chain in order. |
| `--filter PROG` | Run an external (JSON) filter — any language. Repeatable. |
| `-M`, `--metadata KEY=VAL` | Set one metadata value (title, author, …) on the command line. |
| `--metadata-file FILE` | Read metadata from a YAML file instead. |
| `--extract-media DIR` | Pull embedded images (e.g. out of a `.docx`) into `DIR` and rewrite links to them. |
| `--wrap none\|auto\|preserve` | How to wrap output lines. `none` gives one long line per paragraph. |
| `--toc` | Generate a table of contents (with `-s`). |
| `--resource-path DIR` | Where to look for images and other linked resources. |
| `--list-extensions=FORMAT` | Print every syntax extension for a format and whether it's on by default. |
| `--verbose`, `--trace` | Louder logging; `--trace` narrates the AST transforms for debugging. |

The smallest useful command is the one from Chapter 24 with a file on each end:

```sh
pandoc in.md -o out.typ
```

Pandoc infers `gfm`-ish Markdown from the `.md` and Typst from the `.typ`, so it
often does the right thing with no `-f`/`-t` at all. Say them explicitly when
the extension is ambiguous or when you want a specific dialect:

```sh
pandoc in.md --from gfm --to typst -o out.typ
```

A Word manuscript to Typst, with its embedded images unpacked to a folder and
the links rewritten to point at them:

```sh
pandoc manuscript.docx \
  --from docx --to typst \
  --extract-media media \
  -o manuscript.typ
```

You now have `manuscript.typ` next to a `media/` folder of extracted images,
ready to open and refine. (This is the backbone of the Word workflow in
[Appendix C](27-appendix-c-word-migration.md).)

A whole folder of Markdown notes into one Typst body, in filename order — the
generalization of this book's own trick:

```sh
pandoc chapters/*.md --from gfm --to typst -o body.typ
```

The glob expands alphabetically, so zero-padded numeric prefixes (`01-`, `02-`)
give you deterministic ordering for free. Pandoc concatenates the files into a
single AST before writing, so cross-file references resolve as if it were one
document.

When something converts oddly and you want to see *why*, look at the AST itself.
`-t native` prints Pandoc's internal tree in a readable Haskell-ish form; `-t
json` prints the same tree as JSON, which is what an external filter actually
receives:

```sh
echo '# Hi *there*' | pandoc -f gfm -t native
pandoc in.md -f gfm -t json | jq .        # pipe to jq to explore
```

Reading the native output is the fastest way to learn node names — you'll see
`Header`, `Str`, `Emph`, `Space` — which is exactly what you need before writing
a filter. And when you're unsure which Markdown extensions a format turns on:

```sh
pandoc --list-extensions=gfm
```

Each line is prefixed `+` (enabled) or `-` (disabled); you can flip any of them
inline, like `--from gfm-smart` or `--from commonmark+hard_line_breaks`.

> [!TIP]
> Leaving `-o` off and letting Pandoc print to stdout is the fast way to
> eyeball a conversion. `pandoc in.md -t typst | less` shows you the Typst
> without littering the folder with output files.

## Filters, concisely

A filter is a program that transforms the AST between the reader and the writer.
That is the entire concept, and it is the one from the mental model above made
executable: Pandoc parses your input into the tree, hands the tree to your
filter, your filter edits it, and the writer renders whatever comes back. You
are never doing string surgery on Typst output — you're editing structured
nodes before Typst syntax even exists.

Two kinds, differing only in how they run:

- **Lua filters** run in-process, in the Lua interpreter Pandoc embeds. You
  pass them with `--lua-filter`. No extra install, fast, and they have direct
  access to Pandoc's `pandoc.*` helper library. This is what you want almost
  always, and what this book uses.
- **JSON filters** run as a separate program in any language — Python (via
  `panflute` or `pandocfilters`), Haskell, whatever — communicating with Pandoc
  over JSON on stdin/stdout. You pass them with `--filter`. Reach for these only
  when you need a library Lua can't give you.

Either way, the programming model is the same and it is delightfully small. You
write functions **named after AST node types**, and Pandoc calls your function
once for every matching node it finds while walking the tree. Define a function
called `Header` and it fires on every heading; call one `Link` and it fires on
every link. The node types you'll reach for most: `Str` (a run of text), `Para`
(a paragraph), `Header`, `Link`, `Image`, `CodeBlock`, `Div` (a block
container), `Span` (an inline container), `Math`, and `RawBlock` / `RawInline`
(literal target-format passthrough).

What your function returns is the whole control surface:

- **`nil`** (return nothing) — leave the node exactly as it was.
- **a single node** — replace the node with that one.
- **a list of nodes** (`{a, b, c}`) — splice those in where the node was.
- **`{}`** (an empty list) — delete the node.

Pandoc walks the tree bottom-up and applies your functions as it goes, so a
filter is usually just a few small functions, each minding one node type. The
one special move you'll use constantly for Typst work is injecting raw
target-format text: `pandoc.RawBlock("typst", "…")` and its inline sibling
`pandoc.RawInline("typst", "…")` drop a literal chunk of Typst into the stream
that the writer passes through verbatim. That's how you emit a `#figure(…)` call
or a `#note[…]` wrapper that has no Markdown equivalent.

Here's a small, complete filter — one Chapter 24's filter doesn't do. It turns a
standalone image (a paragraph that is *only* an image) into a Typst `#figure`,
using the image's alt text as the caption:

```lua
-- figure-images.lua
-- Wrap a standalone image in a Typst #figure, captioned with its alt text.

function Para(el)
  -- Act only on a paragraph that is exactly one image and nothing else.
  if #el.content == 1 and el.content[1].t == "Image" then
    local img = el.content[1]
    -- The alt text (the [ ... ] part of ![alt](src)) becomes the caption.
    local caption = pandoc.utils.stringify(img.caption)
    -- %q quotes and escapes the path as a valid Typst string literal.
    local typst = string.format(
      '#figure(image(%q), caption: [%s])',
      img.src, caption)
    return pandoc.RawBlock("typst", typst)
  end
  -- Every other paragraph: return nothing, so Pandoc leaves it untouched.
end
```

Run it like any filter, and every full-width image in your document comes out
as a numbered, captioned figure:

```sh
pandoc in.md --from gfm --to typst --lua-filter figure-images.lua -o out.typ
```

Read it against the return-value rules above: the images-in-paragraphs get
replaced by a raw Typst block; every other paragraph falls through the implicit
`nil` and is written normally. Thirteen lines, one clean structural change.

For the real, book-scale version — alerts to admonitions, math passthrough,
link rewriting, heading numbering, dropped author comments — read
[`book-filter.lua`](../examples/117-pandoc-book-build/book-filter.lua) and the
walkthrough in [Chapter 24](24-pandoc-bridge.md). It's the same handful of
element functions, just more of them.

> [!TIP]
> `pandoc lua` drops you into a REPL with the whole `pandoc.*` library loaded,
> which is the fastest way to check what `pandoc.utils.stringify` or
> `pandoc.RawBlock` actually returns before you wire it into a filter. The full
> reference is the Lua filters documentation at
> <https://pandoc.org/lua-filters.html>.

## Pandoc + Typst: an idea bank

Everything so far was mechanics. This is the part where the mechanics pay off —
concrete workflows worth trying, each one a hinge between a format that's
pleasant to *write* in and Typst's power to *typeset*. Treat these as prompts,
not prescriptions.

- **Author in Word, typeset in Typst.** A co-author who lives in Word (or Google
  Docs, exported as `.docx`) hands you a manuscript; you want a real book out
  of it. `pandoc thesis.docx --to typst --extract-media media -o body.typ`
  converts the prose and unpacks the images in one shot, and you drop the
  result into a Typst template. The seams are predictable — tracked changes and
  comments vanish, complex tables need a look — and [Appendix
  C](27-appendix-c-word-migration.md) walks the whole path.

- **A folder of Markdown into one PDF.** This is the book's own trick,
  generalized to any pile of notes: lecture notes, a research journal, a wiki
  export. Glob the files in order, convert to one Typst body, prepend a head
  that sets the page and imports a template, compile. You keep writing in the
  editor you like and get a typeset PDF whenever you want one.

- **Markdown as a 90%-there starting point.** Even without a template, `pandoc
  notes.md -o notes.typ` gets you readable Typst you can then hand-refine. The
  conversion does the tedious 90% — headings, lists, tables, links — and you
  spend your attention on the last 10% that actually needs judgment: page
  breaks, figure placement, the one table that wants custom columns.

- **Slide decks, via the prose.** Pandoc writes Reveal.js and Beamer, but it
  does **not** write Typst slides — there's no polylux or touying writer. So the
  pattern flips: convert your Markdown prose to Typst *content*, then paste the
  pieces into a slide template (polylux or touying) and mark the slide breaks by
  hand. Pandoc carries the words across; the slide structure is yours to build.

- **Born-digital in, print out.** Have an EPUB or a website you want in print?
  `pandoc book.epub --to typst` or `pandoc page.html --to typst` gives you a
  Typst starting point for a proper print edition of something that only ever
  existed on a screen. Expect to clean up navigation cruft and re-decide the
  layout, but the text arrives intact.

- **LaTeX to Typst, first pass.** `pandoc old-paper.tex --to typst` is a genuine
  head start on a migration — the structure, sections, and plain math often come
  through usably. Be honest about its limits: anything macro-heavy or
  math-dense is a *rough* first pass, not a finished translation, and custom
  `\newcommand` definitions won't survive. Use it to get 60% of the way, then
  follow [Appendix B](26-appendix-b-latex-migration.md) for the rest.

- **One source, two outputs, with math protected.** This book writes its math in
  Typst syntax right in the Markdown and uses a filter to pass it through
  untouched (the `Math` function in Chapter 24). The payoff is that a single
  `.md` file renders as legible math on GitHub *and* compiles to a Typst PDF —
  no second copy, no translation step. If you want one source to serve both a
  web render and a print PDF, this is the move.

- **Rebuild on every push.** A git `pre-commit` hook or a GitHub Action that
  runs your build script turns "the PDF is always current" into something you
  never think about. The Action installs Typst and Pandoc, runs the same
  `build-book.sh` you run locally, and uploads the PDF as an artifact (or
  commits it, or attaches it to a release). No workflow file here — just know
  the shape: the same three commands, on a runner, on every push.

None of this is free of friction, and it's only fair to name the seams. Pandoc's
Typst writer is young — younger than its LaTeX writer by more than a decade — so
some things convert cleanly, some need a filter to come out right, and some need
hand-work no converter can do for you. Tables arrive wrapped in figures.
Fine-grained typography is yours to set. Anything exotic in the source is where
you'll spend your time. But the seams are all findable, and every one of them is
either a small filter or a template tweak away from smooth.

The through-line is the same one Chapter 24 closes on, and it's worth carrying
out of this book: write where writing is pleasant, typeset where typesetting is
powerful, and let Pandoc be the hinge between them. That's the whole trick —
Markdown for the words, Typst for the page, and a converter in the middle so you
never have to choose.
