# Example 033 · Zebra striping

A `fill: (x, y) => if calc.odd(y) { luma(240) }` function shades alternate
rows, with `stroke: none` and a roomy `inset` for a clean, lines-free look.
Used in [Chapter 7, *Tables and grids*](../../book/07-tables-and-grids.md).

```sh
typst compile main.typ out.pdf
```

Rendered preview: [`out.png`](out.png). Full output: [`out.pdf`](out.pdf).
