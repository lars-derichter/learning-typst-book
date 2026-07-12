# Example 085 · Dictionaries

Building a record, then reading and reshaping it: field access `ada.name`
versus dynamic `ada.at("field")`, `.keys()`/`.values()`/`.pairs()`,
`.insert()`/`.remove()` on a mutable binding, and membership with
`"key" in dict`. Also shows that assignment copies, so mutating a copy leaves
the original intact. From
[Chapter 16, *Arrays, dictionaries, and strings*](../../book/16-arrays-dictionaries-strings.md).

```sh
typst compile main.typ out.pdf
```
