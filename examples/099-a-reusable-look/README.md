# Example 099 · A reusable look in one function

`look.typ` bundles page defaults, text defaults, and heading show rules inside a
single `report(body)` function. `main.typ` imports it and applies the whole
look with one line, `#show: report`, which feeds the rest of the document
through the function. This is the bridge to templates in Chapter 19. Used in
[Chapter 18, *Your own functions*](../../book/18-your-own-functions.md).

```sh
typst compile main.typ out.pdf
```

Rendered preview: [`out.png`](out.png). Full output: [`out.pdf`](out.pdf).
