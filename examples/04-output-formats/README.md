# Example 04 · Output formats

One short document, compiled to three formats to show that the output format
is chosen by the file extension. Used in
[Chapter 2, *Getting Typst running*](../../book/02-getting-typst-running.md).

```sh
typst compile main.typ out.pdf
typst compile main.typ out.png
typst compile main.typ out.svg
```

PNG and SVG emit one file per page. This document fits on one page, so a plain
name works; a multi-page document would need a `{p}` template, e.g.
`typst compile main.typ page-{p}.png`.
