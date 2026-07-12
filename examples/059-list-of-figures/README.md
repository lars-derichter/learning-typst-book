# Example 059 · List of figures

`#outline(target: figure)` builds a list of figures, the same machinery that
`#outline()` uses for headings. Three captioned shape figures are collected
into the list and also referenced from the prose. For a list of tables, use
`target: figure.where(kind: table)`. From
[Chapter 11, *References and cross-references*](../../book/11-references-and-cross-references.md).

```sh
typst compile main.typ out.pdf
```
