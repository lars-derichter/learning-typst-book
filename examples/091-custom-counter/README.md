# Example 091 · A custom counter

`counter("theorem")` is a counter you name yourself. `.step()` increments it and
`#context thm.display()` prints it, so a small `theorem` helper numbers each
block automatically: "Theorem 1", "Theorem 2", "Theorem 3". Insert one in the
middle and the rest renumber. Used in
[Chapter 17, *Context, state, and counters*](../../book/17-context-state-counters.md).

```sh
typst compile main.typ out.pdf
```

Rendered preview: [`out.png`](out.png). Full output: [`out.pdf`](out.pdf).
