# Learning Typst — project guide

*Learning Typst* is a book that teaches the [Typst](https://typst.app)
typesetting system in the register of an O'Reilly *Learning* book: warm, a
little funny, thorough. It was written with heavy AI assistance under human
direction, and released under CC BY-NC-SA 4.0. This file is the map for anyone
(human or AI) changing or extending it later.

The book is written in **GitHub-flavored Markdown** and **typesets itself** into
a PDF through a Pandoc → Typst pipeline. The full story of how it was made — the
brief, the plan, the style guide, the workflow — is in
[`writing-this-book/`](writing-this-book/). Read it if you want the *why*.

## Repository layout

- **`book/`** — the book text, one file per chapter: `00-preface.md`, `01-`…
  `24-` (the numbered chapters, six Parts), `25-`…`29-` (Appendices A–E). This
  is the source of truth for the prose.
- **`examples/`** — 117 self-contained, runnable Typst projects, each in
  `NNN-slug/` with a `main.typ`, a short `README.md`, and committed renders
  (`out.pdf` + `out.png`). Every code idea in the book has one. Two are special:
    - `115-oreilly-book-template/` — the reusable O'Reilly-style book template
      (Chapter 22). Its `template/` holds `theme.typ` (colours/fonts/sizes),
      `book.typ` (the `book()` template + `part()` divider), `admonitions.typ`,
      `code.typ`, and `index.typ`.
    - `117-pandoc-book-build/` — the whole-book pipeline (Chapter 24):
      `book-filter.lua` (the Pandoc filter), `head.typ` (imports and applies the
      115 template), and `build.sh`.
- **`scripts/`** — `build-examples.sh` (verify + render every example) and
  `build-book.sh` (typeset the whole book to a PDF).
- **`README.md`** — the blurb and the full table of contents (links into
  `book/`).
- **`writing-this-book/`** — the process case study (prompt, plan, style guide,
  workflow, reflections), plus `07-after-the-first-finish.md`, the running log
  of changes made *after* the book was first completed.
- **`LICENSE`** — CC BY-NC-SA 4.0.

## Conventions (please keep these)

- **Kebab-case** for every file and folder name.
- **Example folders use a three-digit, zero-padded prefix** (`001`…`117`), one
  global running number in the order examples are introduced. Each chapter has a
  disjoint block (see `writing-this-book/04-the-style-guide.md`).
- **Prose wraps at 80 columns.** Code fences and Markdown table rows may exceed.
- **Voice:** conversational, dry humour, second person, sentence-case headings.
  The preface and Chapter 1 are the voice exemplar; the banned "AI tells" are
  listed in the style guide. No emoji in prose.
- **Admonitions** are GitHub alerts (`> [!NOTE]`, `[!TIP]`, `[!IMPORTANT]`,
  `[!WARNING]`, `[!CAUTION]`). "Coming from LaTeX/Word" asides are plain
  blockquotes with a bold lead-in.
- **Exercises:** each chapter ends with 3–5, and keeps its intended answers in a
  trailing `<!-- SOLUTIONS -->` HTML comment. Those comments are invisible in
  every output (GitHub hides them; the pipeline drops them) and are the source
  for **Appendix A** (`book/25-…`). Keep them in sync when you change exercises.
- **Fonts:** examples use only Typst's bundled fonts — Libertinus Serif (body),
  New Computer Modern (headings), DejaVu Sans Mono (code). There is **no bundled
  sans-serif**. Sticking to these keeps examples reproducible and warning-free.
- The book targets **Typst 0.15.0**. Verify against that version.

## Build and verify (run after any change)

Requirements: **Typst 0.15+** always; **Pandoc 3.x** for the whole-book build.

```sh
scripts/build-examples.sh          # compile + render + verify EVERY example
scripts/build-examples.sh 042 043  # only folders starting 042-/043-
scripts/build-book.sh              # whole book -> build/learning-typst.pdf
```

`build-examples.sh` compiles each `examples/NNN-*/main.typ`, writes `out.pdf`
and an `out.png` preview, and **fails loudly** on any breakage. Marker files in
an example folder change its handling:

- `.skip-build` — skip it (used for the two network-fetching package examples,
  104/105, and the pipeline example 117). Render those by hand if needed.
- `.expect-error` — the example is *supposed* to fail compiling (it teaches an
  error message); the script asserts that it fails.

Typst PDFs are deterministic, so re-rendering an unchanged example produces a
byte-identical file (no spurious diffs).

## How to make common changes

- **Edit prose:** change `book/NN-*.md`, keeping the 80-column wrap. Nothing
  else is needed unless you touch examples.
- **Add or change an example:** create `examples/NNN-slug/main.typ` (plus a
  `README.md`); confirm it compiles clean with no warnings via
  `typst compile --root . examples/NNN-slug/main.typ /tmp/x.pdf`; run
  `scripts/build-examples.sh NNN` to render it; and refer to it from the chapter
  as `examples/NNN-slug/`. Prefer bundled fonts.
- **Add a chapter:** take the next `NN`, write `book/NN-slug.md`, add it to the
  README table of contents, give it exercises plus a `<!-- SOLUTIONS -->`
  comment, and add a matching section to Appendix A. Chapter numbering in the
  PDF is automatic.
- **Change the book's look:** edit the files under
  `examples/115-oreilly-book-template/template/` — `theme.typ` for
  colours/fonts/sizes, `book.typ` for layout. The whole-book PDF uses this same
  template (via `examples/117-…/head.typ`), so a design change flows to both the
  sampler and the full book.
- **Change the Markdown→PDF pipeline:** it lives in
  `examples/117-pandoc-book-build/`. `build.sh` (self-contained) and
  `scripts/build-book.sh` run the same steps: convert each `book/*.md` with
  Pandoc + `book-filter.lua`, prepend `head.typ`, then compile. The filter
  handles alerts→admonitions, Typst-math passthrough, thematic breaks, dropping
  the SOLUTIONS comments, unnumbering front/back matter, and rewriting links
  (cross-chapter → internal PDF jumps, `examples/` → GitHub URLs). The build
  runs the filter once per file, passing `CHAPTER_NAME`, so each chapter heading
  gets a label its cross-chapter links can jump to.

## Typst 0.15 gotchas (learned the hard way)

- The default paragraph is **ragged-right**, not justified.
- Inside `$…$` math, a bare `true`/`false`/`none` is read as a variable — use
  `#true` and friends.
- `range`'s step is a **named** argument: `range(0, 10, step: 2)`.
- `#path` was removed; use `#curve` for custom shapes.
- Division always yields a float (`6 / 2` is `3.0`).
- Universe **package versions must be pinned** and compatible with 0.15; a
  package frozen to an old version can break against a newer compiler.

## Keeping this file (and the record) current

Two upkeep habits for whoever changes the book next:

- **Keep this `CLAUDE.md` accurate.** If you change the structure, the
  conventions, the build commands, or the numbering / font / version facts
  above, update this file in the same commit. It is the first thing a new
  session reads, and a stale map is worse than none.
- **Log substantive changes** in
  `writing-this-book/07-after-the-first-finish.md` — a short section on what
  prompted the change, what you did, and what it taught — so the honest record
  of how the book evolved keeps going. A typo fix needs no entry; anything that
  changes the design, the pipeline, or a convention does.
