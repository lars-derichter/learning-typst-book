# Example 089 · Context basics

The `context` keyword defers a read until Typst knows *where* it is. Inside
`#context`, `counter(page).display()` gives the live page number and `here()`
gives the current location; the same source line prints a different page number
on each page. Outside `context`, those reads are an error. Used in
[Chapter 17, *Context, state, and counters*](../../book/17-context-state-counters.md).

```sh
typst compile main.typ out.pdf
```

Rendered preview: [`out.png`](out.png). Full output: [`out.pdf`](out.pdf).
