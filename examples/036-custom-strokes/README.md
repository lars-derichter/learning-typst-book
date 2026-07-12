# Example 036 · Custom strokes (booktabs look)

Turns every automatic border off with `stroke: none`, then draws three
horizontal rules by hand with `table.hline` — a thick top and bottom rule and a
thin one under the header. This is the LaTeX booktabs aesthetic, without the
package. Used in
[Chapter 7, *Tables and grids*](../../book/07-tables-and-grids.md).

```sh
typst compile main.typ out.pdf
```

Rendered preview: [`out.png`](out.png). Full output: [`out.pdf`](out.pdf).
