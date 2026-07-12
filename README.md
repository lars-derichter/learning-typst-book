# Learning Typst

> A hands-on, cover-to-cover guide to the [Typst](https://typst.app)
> typesetting system — in the spirit of the old O'Reilly *Learning* books:
> readable, occasionally funny, and thorough enough to actually finish the job.

Typst is a markup-based typesetting system — think of it as what you'd get if
you crossed the readability of Markdown with the power of LaTeX, then handed the
result to people who like fast feedback and sensible error messages. This book
teaches it from `= Hello` all the way to writing your own packages, building a
full O'Reilly-style book template, and typesetting an entire manuscript from
Markdown with Pandoc.

You don't need to know LaTeX. You don't need to be a programmer. You need a
computer, some curiosity, and the willingness to run a few examples. Every
code example in this book is a real, self-contained project in
[`examples/`](examples/) that compiles with **Typst 0.15.0** — no hand-waving,
no "left as an exercise"
snippets that don't actually run.

> [!NOTE]
> This book is an experiment: it was written with heavy help from an AI
> assistant, under human direction and quality control, and every example is
> machine-verified against a real Typst compiler. It's shared under a
> non-commercial license (see [Licensing](#licensing)) in case it's useful to
> someone else too.

## The book, chapter by chapter

Start at the [Preface](book/00-preface.md), then read straight through. Each
chapter builds on the last and ends with exercises (solutions in
[Appendix A](book/25-appendix-a-solutions.md)).

### Front matter
- [Preface](book/00-preface.md) — who this is for, how to read it, conventions.

### Part I — Meeting Typst
1. [Why Typst?](book/01-why-typst.md) — the pitch, a little history, and how it
   compares to LaTeX, Word, and friends.
2. [Getting Typst running](book/02-getting-typst-running.md) — the web app, the
   command line, editor setup, watch mode, and your first document.
3. [Markup: the content layer](book/03-markup-content-layer.md) — headings,
   emphasis, lists, links, quotes, and everything you type before you think
   about styling.

### Part II — Everyday documents
4. [Text and fonts](book/04-text-and-fonts.md) — choosing typefaces, sizes,
   weights, and the typographic details that make a page look professional.
5. [Pages and layout](book/05-pages-and-layout.md) — paper sizes, margins,
   headers and footers, page numbers, and columns.
6. [Figures and images](book/06-figures-and-images.md) — placing pictures,
   captions, and numbered figures.
7. [Tables and grids](book/07-tables-and-grids.md) — the deep dive: cells,
   strokes, alignment, spanning, and striping.
8. [Math and equations](book/08-math-and-equations.md) — Typst's standout
   feature, from inline fractions to aligned multi-line derivations.

### Part III — Styling with set and show rules
9. [Set rules](book/09-set-rules.md) — changing the defaults, everywhere, at
   once.
10. [Show rules](book/10-show-rules.md) — intercepting and transforming
    anything the document contains.
11. [References and cross-references](book/11-references-and-cross-references.md)
    — labels, `@` references, and automatic outlines.
12. [Citations and bibliographies](book/12-citations-and-bibliographies.md) —
    Hayagriva, CSL styles, and getting APA exactly right.

### Part IV — Programming Typst
13. [From markup to code](book/13-from-markup-to-code.md) — the two modes,
    values, and Typst's type system.
14. [Functions and closures](book/14-functions-and-closures.md) — defining your
    own, arguments, and returning content.
15. [Control flow](book/15-control-flow.md) — conditionals, loops, and bindings.
16. [Arrays, dictionaries, and strings](book/16-arrays-dictionaries-strings.md)
    — Typst's data structures and the methods that make them sing.
17. [Context, state, and counters](book/17-context-state-counters.md) — the
    tricky, powerful part: computing things that depend on where they land.

### Part V — Reusable design
18. [Your own functions](book/18-your-own-functions.md) — building a personal
    style library.
19. [Templates](book/19-templates.md) — reusable document skeletons you can
    hand to other people.
20. [Packages](book/20-packages.md) — using the Typst Universe ecosystem and
    publishing your own.
21. [Advanced layout](book/21-advanced-layout.md) — `place`, `stack`, the
    box/block model, transforms, and the escape hatches.

### Part VI — The book typesets itself
22. [Designing a book template](book/22-designing-a-book-template.md) — building
    an O'Reilly-style template in Typst: chapter openers, running headers,
    admonition boxes, code theming, and a generated table of contents.
23. [Building the book](book/23-building-the-book.md) — assembling chapters,
    outlines, and an index into a finished PDF.
24. [The Pandoc bridge](book/24-pandoc-bridge.md) — converting Markdown to
    Typst, a Lua filter for GitHub-style alerts, and typesetting *this whole
    book* to PDF.

### Appendices
- [A. Solutions to the exercises](book/25-appendix-a-solutions.md)
- [B. LaTeX → Typst migration map](book/26-appendix-b-latex-migration.md)
- [C. Word / Google Docs → Typst migration map](book/27-appendix-c-word-migration.md)
- [D. Quick-reference cheat sheet](book/28-appendix-d-cheat-sheet.md)
- [E. Resources and where to go next](book/29-appendix-e-resources.md)

## Running the examples

Every example lives in its own numbered folder under [`examples/`](examples/),
with the Typst source (`main.typ`), a short `README.md`, and committed renders
(`out.pdf` and a `out.png` preview). To build one yourself:

```sh
cd examples/001-hello-typesetting
typst compile main.typ out.pdf
```

To (re)build and verify *every* example at once:

```sh
scripts/build-examples.sh
```

The script compiles each example, renders a preview, and fails loudly if
anything is broken — so the promise "every example actually works" is enforced,
not just claimed.

## Building the whole book as a PDF

Chapter 24 is not just talk: the book ships a Pandoc-based pipeline that turns
the Markdown in [`book/`](book/) into a typeset PDF via Typst.

```sh
scripts/build-book.sh          # produces build/learning-typst.pdf
```

You'll need [Pandoc](https://pandoc.org) (3.x) and Typst on your `PATH`.

## What you need

- **Typst 0.15.0** or newer — https://typst.app/docs (web app needs nothing;
  the CLI is a single binary).
- For the whole-book build: **Pandoc 3.x**.
- That's it. Typst bundles its own fonts, so the examples render the same
  everywhere.

## How this book was written

This book was written by a human directing an AI, under human quality control,
with every code example verified against a real Typst compiler. The whole
process is documented openly in [`writing-this-book/`](writing-this-book/) — the
original prompt, the scoping questions, the plan, the style guide the AI held
itself to, and the managing-editor-plus-sub-agents workflow that produced it.
The repository doubles as a small case study in using generative AI in a
deliberate, quality-controlled way.

## Licensing

This book — text and example code — is released under
[Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International](LICENSE)
(CC BY-NC-SA 4.0). In short: share it, remix it, teach from it; just credit the
source, don't sell it, and pass on the same freedoms. The full legal text is in
[LICENSE](LICENSE).
