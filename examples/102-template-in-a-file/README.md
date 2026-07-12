# Example 102 · A template in its own file

The `article` template lives in `template.typ`; `main.typ` imports it with
`#import "template.typ": article` and applies it with `#show: article.with(...)`.
The document file stays down to configuration plus content. Two files. Used in
[Chapter 19, *Templates*](../../book/19-templates.md).

```sh
typst compile main.typ out.pdf
```
