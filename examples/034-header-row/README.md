# Example 034 · Header and footer

`table.header` marks the top row so Typst treats it as a heading and repeats it
on every page the table spans; `table.footer` marks a summary row at the
bottom. The header is shaded with a `fill` function on `y == 0`. Used in
[Chapter 7, *Tables and grids*](../../book/07-tables-and-grids.md).

```sh
typst compile main.typ out.pdf
```

Rendered preview: [`out.png`](out.png). Full output: [`out.pdf`](out.pdf).
