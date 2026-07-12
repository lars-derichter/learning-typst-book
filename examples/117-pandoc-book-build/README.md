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
- **`github-alerts.lua`** — a Pandoc filter that (1) rewrites GitHub alert
  blockquotes (`> [!NOTE]`) into `#admonition("note")[…]` calls, (2) passes the
  book's Typst-syntax math through verbatim instead of treating it as LaTeX,
  (3) drops the `<!-- SOLUTIONS -->` comments, and (4) leaves the Preface and
  Appendices unnumbered so the chapters number 1–N cleanly.
- **`book-preamble.typ`** — the Typst book design (page, headings, code theme,
  the `admonition()` function, a title page, and a table of contents) that the
  converted body is appended to.
- **`out.png`** — a preview of the produced book's title page. The full PDF
  (a couple of hundred pages) is written to `out/` and is not committed.

## Requirements

[Pandoc](https://pandoc.org) 3.x and Typst 0.15+ on your `PATH`.

> [!NOTE]
> This example carries a `.skip-build` marker: it isn't a single `main.typ`, it
> drives the whole `book/` directory, so the example build script skips it. Run
> `./build.sh` (or `scripts/build-book.sh`) to produce the book.
