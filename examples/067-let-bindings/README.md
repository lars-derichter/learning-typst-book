# Example 067 · let bindings

`#let` names a value; the name is then usable as `#name`, and expressions like
`#(seats * price)` compute from it so figures never drift out of sync. Also
shows rebinding — a second `#let price` replaces the value from that point on.
Used in [Chapter 13, *From markup to code*](../../book/13-from-markup-to-code.md).

```sh
typst compile main.typ out.pdf
```

Rendered preview: [`out.png`](out.png). Full output: [`out.pdf`](out.pdf).
