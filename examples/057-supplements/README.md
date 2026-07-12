# Example 057 · Supplements

The *supplement* is the word before a reference number ("Figure", "Section").
This sets it globally with `#set heading(supplement: [Chapter])` and
`#set figure(supplement: [Illustration])`, then overrides it for a single
reference with `#ref(<fig:plot>, supplement: [Fig.])`. From
[Chapter 11, *References and cross-references*](../../book/11-references-and-cross-references.md).

```sh
typst compile main.typ out.pdf
```
