# Example 090 · Page X of Y

The classic footer: `counter(page).display()` for the current page and
`counter(page).final().first()` for the total. `.final()` returns the counter's
end value (an array), which Typst resolves by laying the document out and
iterating until the total settles. Three pages, so the footer reads "Page 1 of
3", "2 of 3", "3 of 3". Used in
[Chapter 17, *Context, state, and counters*](../../book/17-context-state-counters.md).

```sh
typst compile main.typ out.pdf
```

Rendered preview: [`out.png`](out.png). Full output: [`out.pdf`](out.pdf).
