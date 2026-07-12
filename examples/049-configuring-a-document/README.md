# Example 049 · Configuring a document

A small styled article whose whole look is set by a stack of set rules at the
top: `#set page`, `#set text`, `#set par`, `#set heading(numbering:)`, and
`#set list(marker:)`. The body is plain markup that inherits all of it. Used
in [Chapter 9, *Set rules*](../../book/09-set-rules.md).

```sh
typst compile main.typ out.pdf
```

Rendered preview: [`out.png`](out.png). Full output: [`out.pdf`](out.pdf).
