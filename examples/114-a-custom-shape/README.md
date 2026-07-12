# Example 114 · A custom shape

A small "verified" badge assembled from primitives: a `circle` (a shape
function) for the disk, a `curve` of two `curve.line` segments for the white
tick, and a single `curve.cubic` Bézier for the flourish beneath. `#place`
stacks the tick over the disk. In Typst 0.15 the old `#path` function is gone;
`#curve` is the modern path tool that replaces it.
Used in [Chapter 21, *Advanced layout*](../../book/21-advanced-layout.md).

```sh
typst compile main.typ out.pdf
```

Rendered preview: [`out.png`](out.png). Full output: [`out.pdf`](out.pdf).
