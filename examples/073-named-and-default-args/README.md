# Example 073 · Named arguments with defaults

`#let tag(body, color: gray, size: 9pt) = ...` mixes a positional parameter
with two named parameters that carry defaults. The same function is called with
no overrides, one override, and both overrides in any order. Used in
[Chapter 14, *Functions and closures*](../../book/14-functions-and-closures.md).

```sh
typst compile main.typ out.pdf
```

Rendered preview: [`out.png`](out.png). Full output: [`out.pdf`](out.pdf).
