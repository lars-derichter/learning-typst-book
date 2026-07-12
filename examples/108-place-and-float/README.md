# Example 108 · Place and float

`#place` lifts content out of the normal flow and pins it to a spot on the
page — here a `top + right` tag nudged inward with `dx`/`dy`, and a
`bottom + left` marker. `place(bottom, float: true, ...)` sends a block to
the foot of the page while the body text fills from the top. Placed content
reserves no space, so the flow ignores it.
Used in [Chapter 21, *Advanced layout*](../../book/21-advanced-layout.md).

```sh
typst compile main.typ out.pdf
```

Rendered preview: [`out.png`](out.png). Full output: [`out.pdf`](out.pdf).
