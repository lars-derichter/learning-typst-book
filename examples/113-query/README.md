# Example 113 · Query

`query` reaches into the finished document and returns the elements matching a
selector. Inside `#context`, `query(heading)` hands back every heading; the
loop reads each one's page number with `counter(page).at(h.location())` and
draws a contents line with a dotted leader. This is, in miniature, how a
custom table of contents is built by hand.
Used in [Chapter 21, *Advanced layout*](../../book/21-advanced-layout.md).

```sh
typst compile main.typ out.pdf
```

Rendered preview: [`out.png`](out.png). Full output: [`out.pdf`](out.pdf).
