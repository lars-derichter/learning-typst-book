# Example 048 · Scope of a set rule

A `#set text` rule placed inside a `[ ... ]` content block styles only that
block. The lines before and after keep the document defaults, proving that a
set rule reaches to the end of its enclosing scope and no further. Used in
[Chapter 9, *Set rules*](../../book/09-set-rules.md).

```sh
typst compile main.typ out.pdf
```

Rendered preview: [`out.png`](out.png). Full output: [`out.pdf`](out.pdf).
