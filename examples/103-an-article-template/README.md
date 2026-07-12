# Example 103 · A realistic article template

The centerpiece: an `article` template with configurable `title`, `author`,
`date`, and an optional `abstract`; a styled title block; numbered headings; and
set rules for the page, fonts, and paragraphs. The document is nothing but
`#show: article.with(...)` and content. Used in
[Chapter 19, *Templates*](../../book/19-templates.md).

```sh
typst compile main.typ out.pdf
```
