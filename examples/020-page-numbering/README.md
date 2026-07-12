# Example 020 · Page numbering

The `numbering` pattern on `#set page`: `"1 / 1"` prints "current / total" and
Typst supplies the auto footer. Change the pattern to `"i"` or `"1"` for roman
or bare digits; `number-align` places it. A three-page document. Used in
[Chapter 5, *Pages and layout*](../../book/05-pages-and-layout.md).

```sh
typst compile main.typ out.pdf
```

Rendered preview: [`out.png`](out.png). Full output: [`out.pdf`](out.pdf).
