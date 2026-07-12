# Example 093 · measure and layout

Two ways to ask about layout itself. `context measure(body)` returns a content's
`.width`/`.height` before it is placed — used here to draw a rule exactly as
wide as its text. `layout(size => ...)` hands you the available area, so the same
three tags sit in a row at full width but stack inside a narrow box. Used in
[Chapter 17, *Context, state, and counters*](../../book/17-context-state-counters.md).

```sh
typst compile main.typ out.pdf
```

Rendered preview: [`out.png`](out.png). Full output: [`out.pdf`](out.pdf).
