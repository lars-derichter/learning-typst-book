# Example 109 · Box and block

`#box` is inline — it rides inside a line of text (the yellow highlight).
`#block` is block-level — it takes its own horizontal band (the bordered
callout). Both accept `fill`, `stroke`, `radius`, and `inset`; a box adds
`outset`. The third block pins a `width`/`height` and sets `clip: true`, so
overrunning text is cut off at the edge.
Used in [Chapter 21, *Advanced layout*](../../book/21-advanced-layout.md).

```sh
typst compile main.typ out.pdf
```

Rendered preview: [`out.png`](out.png). Full output: [`out.pdf`](out.pdf).
