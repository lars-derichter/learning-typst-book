# Example 05 · Document metadata

A small, realistic document that sets its PDF title and author with
`#set document(...)`. The metadata lands in the PDF's properties, not on the
page. Used in
[Chapter 2, *Getting Typst running*](../../book/02-getting-typst-running.md).

Compile it from the repository root so `--root` can resolve absolute paths:

```sh
typst compile --root . examples/05-document-metadata/main.typ out.pdf
```
