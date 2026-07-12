# Example 116 · Assembling a book

A small but complete multi-file book that *reuses* the Chapter 22 template
(`examples/115-oreilly-book-template/`) by relative import and demonstrates the
production workflow of Chapter 23. `main.typ` is a pure assembly manifest:
import the template, then list the content in reading order.

- Front matter (`front/`) — a copyright page and a preface, numbered in
  lowercase roman numerals (`i`, `ii`) with their own automatic footer.
- Body (`chapters/`) — three short chapters spliced in with `#include`, the
  page counter restarted at arabic `1`, wrapped in two `#part[...]` dividers.
  `chapters/sun-diagram.svg` is an asset living beside the chapter that uses it.
- Back matter (`appendix/`) — a hand-drawn Appendix A and the generated index.

The result is a 12-page PDF: title, contents, roman front matter, two part
openers, three chapters (with a running head, an admonition, and a figure),
an appendix, and a working index. Used in
[Chapter 23, *Building the book*](../../book/23-building-the-book.md).

Compile from the repository root so the relative import into example 115
resolves:

```sh
typst compile --root . examples/116-assembling-a-book/main.typ out.pdf
```
