# Example 047 · List and enum markers

`#set list(marker: ([--], [·]))` gives bullet lists two markers that alternate
by depth; `#set enum(numbering: "a)")` renumbers enumerations as a), b), c).
Both are set once and apply to every list below. Used in
[Chapter 9, *Set rules*](../../book/09-set-rules.md).

```sh
typst compile main.typ out.pdf
```

Rendered preview: [`out.png`](out.png). Full output: [`out.pdf`](out.pdf).
