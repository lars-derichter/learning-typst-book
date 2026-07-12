# Example 087 · An array of dictionaries

The dataset shape you meet everywhere: an array of records, each a dictionary.
Loops over the records to pull fields, then reshapes the whole set with
`.filter()`, `.map()`, and `.sorted(key: ...)`. Sets up example 088, which
renders the same data as a table. From
[Chapter 16, *Arrays, dictionaries, and strings*](../../book/16-arrays-dictionaries-strings.md).

```sh
typst compile main.typ out.pdf
```
