# Example 112 · Repeat leaders

`#repeat` tiles content to fill the space it is handed. Wrapped in a
`box(width: 1fr, ...)` between a title and a page number, `repeat[.]` becomes
the dotted leader line of a table of contents — the same trick Typst's own
`#outline` uses. The `1fr` box swallows all the slack, and the dots stretch
to fill it however long or short the title is.
Used in [Chapter 21, *Advanced layout*](../../book/21-advanced-layout.md).

```sh
typst compile main.typ out.pdf
```

Rendered preview: [`out.png`](out.png). Full output: [`out.pdf`](out.pdf).
