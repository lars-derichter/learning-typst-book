# Example 092 · State basics

`state("part", ...)` holds a value that varies through the document. `.update()`
changes it; inside `context`, `.get()` reads it — here to drive a running header
that switches from "Part I" to "Part II". A header reads state as of the *top*
of its page, so the `.update()` lands just before `#pagebreak()` to keep page 2's
header correct. Used in
[Chapter 17, *Context, state, and counters*](../../book/17-context-state-counters.md).

```sh
typst compile main.typ out.pdf
```

Rendered preview: [`out.png`](out.png). Full output: [`out.pdf`](out.pdf).
