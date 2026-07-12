# Example 094 · A final total

`counter("exercise").final().first()` reads the counter's *end* value. The
summary line prints "This worksheet has 4 exercises" at the very top — a number
that does not exist yet in source order. Typst lays the document out, reads the
final count, and fills the blank on a later pass. Used in
[Chapter 17, *Context, state, and counters*](../../book/17-context-state-counters.md).

```sh
typst compile main.typ out.pdf
```

Rendered preview: [`out.png`](out.png). Full output: [`out.pdf`](out.pdf).
