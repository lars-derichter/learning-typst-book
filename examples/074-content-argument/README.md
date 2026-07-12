# Example 074 · A component that takes a content block

`#let callout(body, title: "Note", color: blue) = ...` is a reusable box whose
last positional parameter is a content block. `#callout[...]` is the trailing
content-block sugar for `#callout([...])`; adding named options first still
passes the content last. Used in
[Chapter 14, *Functions and closures*](../../book/14-functions-and-closures.md).

```sh
typst compile main.typ out.pdf
```

Rendered preview: [`out.png`](out.png). Full output: [`out.pdf`](out.pdf).
