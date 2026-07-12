# Example 29 · A figure of a table or diagram

Shows that figures wrap more than images: a `#table` figure whose `kind` is
auto-detected (numbered as "Table"), plus two custom `kind: "diagram"` figures
with an explicit `supplement`, which get their own independent counter. From
[Chapter 6, *Figures and images*](../../book/06-figures-and-images.md).

```sh
typst compile main.typ out.pdf
```
