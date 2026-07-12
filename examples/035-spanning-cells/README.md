# Example 035 · Spanning cells

`table.cell(colspan: 3)` stretches the title across all three columns;
`table.cell(rowspan: 2)` makes "Morning" and "Afternoon" cover two rows each.
The remaining cells fill the gaps left over. Used in
[Chapter 7, *Tables and grids*](../../book/07-tables-and-grids.md).

```sh
typst compile main.typ out.pdf
```

Rendered preview: [`out.png`](out.png). Full output: [`out.pdf`](out.pdf).
