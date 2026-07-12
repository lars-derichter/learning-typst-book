# Example 037 · Grid for layout

`#grid` is the table engine with the semantics stripped out: pure layout. Here
it sets two prose blocks side by side in equal `1fr` columns, with a
`grid.cell(colspan: 2)` title across the top and `column-gutter` / `row-gutter`
for breathing room. Reach for `grid` when you want placement, not a data table.
Used in [Chapter 7, *Tables and grids*](../../book/07-tables-and-grids.md).

```sh
typst compile main.typ out.pdf
```

Rendered preview: [`out.png`](out.png). Full output: [`out.pdf`](out.pdf).
