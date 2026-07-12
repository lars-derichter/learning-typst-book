# Example 097 · A small style library

The chapter's centerpiece. `lib.typ` holds theme constants (`brand`, `muted`,
`gap`) and three components (`callout`, `kbd`, `framed`); `main.typ` imports
what it needs by name and assembles a short, consistently styled document.
Change the palette in one place and the whole document follows. Used in
[Chapter 18, *Your own functions*](../../book/18-your-own-functions.md).

```sh
typst compile main.typ out.pdf
```

Rendered preview: [`out.png`](out.png). Full output: [`out.pdf`](out.pdf).
