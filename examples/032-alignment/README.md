# Example 032 · Alignment by position

`align` as an `(x, y) => …` function: the header row (`y == 0`) is centered,
the first column (`x == 0`) is left-aligned, and every numeric cell is
right-aligned so the prices line up on the decimal. Used in
[Chapter 7, *Tables and grids*](../../book/07-tables-and-grids.md).

```sh
typst compile main.typ out.pdf
```

Rendered preview: [`out.png`](out.png). Full output: [`out.pdf`](out.pdf).
