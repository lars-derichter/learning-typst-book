# Example 075 · Variadic parameters and spreading

`#let breadcrumbs(..items) = ...` collects any number of arguments into an
`arguments` value and reads them with `.pos()`. `#total(..nums)` sums an
arbitrary count of numbers. The final call spreads an array with `..path` so its
elements arrive as separate arguments. Used in
[Chapter 14, *Functions and closures*](../../book/14-functions-and-closures.md).

```sh
typst compile main.typ out.pdf
```

Rendered preview: [`out.png`](out.png). Full output: [`out.pdf`](out.pdf).
