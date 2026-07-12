# Example 052 · Replacing a literal string

A string-selector show rule matches literal text anywhere in the document.
`#show "TODO": ...` turns every TODO into a bold red marker, and
`#show "Acme": smallcaps[Acme]` sets the product name in small caps throughout
— no find-and-replace, defined once. Used in
[Chapter 10, *Show rules*](../../book/10-show-rules.md).

```sh
typst compile main.typ out.pdf
```

Rendered preview: [`out.png`](out.png). Full output: [`out.pdf`](out.pdf).
