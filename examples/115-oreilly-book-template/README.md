# Example 115 · An O'Reilly-style book template

A complete, multi-file book template that compiles to a real multi-page book.
`main.typ` is the entry point — metadata, a single `#show: book.with(...)`, part
dividers, `#include`d chapter files, and a generated index. All the design lives
in `template/`:

- `theme.typ` — colours, fonts (bundled only), sizes, spacing constants.
- `book.typ` — the `book()` template: page setup, title page, running heads
  built with `context`/`query`, part and chapter openers, and the `#outline`
  table of contents. Also exports `part()`.
- `admonitions.typ` — note/tip/important/warning/caution boxes.
- `code.typ` — show rules theming `raw` code blocks.
- `index.typ` — `idx()` records a term; `make-index()` builds the index page
  by querying the recorded terms.

Sample chapters live in `chapters/`. The result is an 11-page PDF: title page,
contents, two part openers, three chapters (with admonitions, themed code, a
figure, cross-references), and a working index. Used in
[Chapter 22, *Designing a book template*](../../book/22-designing-a-book-template.md).

```sh
typst compile main.typ out.pdf
```
