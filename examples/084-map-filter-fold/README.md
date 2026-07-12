# Example 084 · map, filter, fold

The transformer trio on an array of scores, each driven by an arrow function:
`.map()` curves every score, `.filter()` keeps the passing ones, `.fold()`
sums them (with `.sum()` as the shortcut). Also shows chaining the three,
plus `.zip()` and `.enumerate()`. From
[Chapter 16, *Arrays, dictionaries, and strings*](../../book/16-arrays-dictionaries-strings.md).

```sh
typst compile main.typ out.pdf
```
