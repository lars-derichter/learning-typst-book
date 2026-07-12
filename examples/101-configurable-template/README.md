# Example 101 · A configurable template

`report` gains named configuration arguments (`title`, `author`) in front of
its `body` parameter and builds a centered title block from them. It is applied
with `#show: report.with(title: ..., author: ...)`, where `.with` pre-fills the
config and the show rule supplies the body. Used in
[Chapter 19, *Templates*](../../book/19-templates.md).

```sh
typst compile main.typ out.pdf
```
