# Example 077 · Partial application with `.with()`

`badge.with(color: green)` pre-fills the `color` argument and returns a new,
preconfigured function — so `ok` and `danger` are just `badge` with a colour
baked in. `text.with(...)` shows the same trick on a built-in. Used in
[Chapter 14, *Functions and closures*](../../book/14-functions-and-closures.md).

```sh
typst compile main.typ out.pdf
```

Rendered preview: [`out.png`](out.png). Full output: [`out.pdf`](out.pdf).
