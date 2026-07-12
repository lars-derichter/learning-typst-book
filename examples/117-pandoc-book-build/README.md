# Example 117 · The Pandoc book pipeline

This is the capstone: the pipeline that typesets the *entire book you are
reading* from its Markdown source. It's the running example for
[Chapter 24, *The Pandoc bridge*](../../book/24-pandoc-bridge.md).

The book's chapters live in [`book/`](../../book/) as GitHub-flavored Markdown.
This folder turns them into one typeset PDF:

```sh
./build.sh          # -> out/learning-typst.pdf
```

(The repository's [`scripts/build-book.sh`](../../scripts/build-book.sh) runs the
same pipeline from the repo root.)

## What's here

- **`build.sh`** — the three-step pipeline: Pandoc converts every chapter to a
  Typst body, the body is concatenated onto the preamble, and Typst compiles the
  result.
- **`book-filter.lua`** — a Pandoc filter that (1) rewrites GitHub alert
  blockquotes (`> [!NOTE]`) into the template's `#note[…]` / `#tip[…]` / …
  admonition calls, (2) passes the book's Typst-syntax math through verbatim
  instead of treating it as LaTeX, (3) drops the `<!-- SOLUTIONS -->` comments,
  (4) turns Markdown thematic breaks into rules, (5) rewrites in-repo links
  (cross-chapter `.md` links into internal PDF jumps, `examples/` links into
  GitHub URLs), and (6) leaves the Preface and Appendices (and their
  subsections) unnumbered so the chapters number 1–N. The build runs it once
  per chapter file (passing `CHAPTER_NAME`) so each chapter can be labelled for
  those internal jumps.
- **`head.typ`** — imports and applies the **Chapter 22 book template**
  (`../115-oreilly-book-template/`), passing an A4 page and the cover; the
  converted body is concatenated after it, so the same template that Chapter 22
  builds by hand styles the whole Markdown-sourced book, cover to back cover.
- **`cover.typ`** — the front cover: an affectionate homage to the classic
  animal-book covers (framed, teal, its own trade dress), fed to the template's
  `cover:` slot. The creature is an ouroboros — a snake eating its own tail,
  because that is what this book does.
- **`back-matter.typ`** — the closing pages concatenated *after* the body:
  "About the authors", a colophon with the licence and the Creative Commons
  badges, and a back-cover blurb. These make the standalone PDF stand alone.
- **`assets/`** — `cover-animal.png` (the ouroboros engraving on the cover;
  swap this one file to change the cover creature) and `cc/` (the four official
  Creative Commons badge SVGs used on the colophon).
- **`out.png`** — a preview of the produced book's cover. The full PDF
  (a couple of hundred pages) is written to `out/` and is not committed.

## Requirements

[Pandoc](https://pandoc.org) 3.x and Typst 0.15+ on your `PATH`.

> [!NOTE]
> This example carries a `.skip-build` marker: it isn't a single `main.typ`, it
> drives the whole `book/` directory, so the example build script skips it. Run
> `./build.sh` (or `scripts/build-book.sh`) to produce the book.
