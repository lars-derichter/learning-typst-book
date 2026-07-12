# Example 051 · The show-set form

`#show heading.where(level: 1): set text(...)` applies a set rule only to
level-1 headings, and `#show raw: set text(...)` recolors inline code. The
show-set form tunes matched elements without replacing their appearance
wholesale — the safest, most common show rule. Used in
[Chapter 10, *Show rules*](../../book/10-show-rules.md).

```sh
typst compile main.typ out.pdf
```

Rendered preview: [`out.png`](out.png). Full output: [`out.pdf`](out.pdf).
