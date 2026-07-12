# Example 050 · Rebuilding headings with a function

A function-form show rule, `#show heading: it => ...`, reads the heading's own
text off `it.body` and returns a colored title with a rule line drawn beneath
it. This replaces a heading's whole appearance, not just its parameters. Used
in [Chapter 10, *Show rules*](../../book/10-show-rules.md).

```sh
typst compile main.typ out.pdf
```

Rendered preview: [`out.png`](out.png). Full output: [`out.pdf`](out.pdf).
