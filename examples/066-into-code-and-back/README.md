# Example 066 · Into code and back

The round-trip between the two worlds: `#` drops from markup into a single code
expression (`#(2 + 2)`, `#upper("shouting")`), and `[...]` inside a code block
drops back into markup. Used in
[Chapter 13, *From markup to code*](../../book/13-from-markup-to-code.md).

```sh
typst compile main.typ out.pdf
```

Rendered preview: [`out.png`](out.png). Full output: [`out.pdf`](out.pdf).
