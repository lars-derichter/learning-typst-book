# Example 053 · Transforming a pattern with regex

Two regex-selector show rules. `#show regex("[A-Z]{2,}"): ...` sets every
all-caps acronym in small caps, and `#show regex("\d{4}"): ...` colors any
four-digit year. The matched text is read off `it.text`. Used in
[Chapter 10, *Show rules*](../../book/10-show-rules.md).

```sh
typst compile main.typ out.pdf
```

Rendered preview: [`out.png`](out.png). Full output: [`out.pdf`](out.pdf).
