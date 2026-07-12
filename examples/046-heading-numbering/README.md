# Example 046 · Heading numbering

`#set heading(numbering: "1.")` turns on automatic heading numbers. Top-level
headings become 1, 2, ...; sub-headings nest as 1.1, 2.1, 2.2 without any
manual counting. Used in
[Chapter 9, *Set rules*](../../book/09-set-rules.md).

```sh
typst compile main.typ out.pdf
```

Rendered preview: [`out.png`](out.png). Full output: [`out.pdf`](out.pdf).
