# Example 055 · A document-wide show rule (a tiny template)

A selector-less show rule, `#show: report`, passes the entire rest of the
document to the `report` function, which applies set rules and a heading color
and returns the styled body. This is exactly how templates work — a first taste
of Chapter 19. Used in
[Chapter 10, *Show rules*](../../book/10-show-rules.md).

```sh
typst compile main.typ out.pdf
```

Rendered preview: [`out.png`](out.png). Full output: [`out.pdf`](out.pdf).
