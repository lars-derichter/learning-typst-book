# Example 111 · Transforms

`#rotate`, `#scale`, and `#move` transform content visually without changing
what it is. By default the surrounding layout ignores the transform (the
rotated tag pokes past its line); `reflow: true` makes the layout grow to fit
the transformed shape. The top row shows all three transforms side by side.
Used in [Chapter 21, *Advanced layout*](../../book/21-advanced-layout.md).

```sh
typst compile main.typ out.pdf
```

Rendered preview: [`out.png`](out.png). Full output: [`out.pdf`](out.pdf).
