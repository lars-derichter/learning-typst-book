# Example 060 · Customizing references

A `#show ref: it => {...}` rule that restyles every cross-reference. It reads
`it.element` to tell a figure reference from a heading reference, wraps figure
references in a grey chip, and colours the rest blue. Because it wraps the
default rendering (`it`), the auto-generated numbers keep working. From
[Chapter 11, *References and cross-references*](../../book/11-references-and-cross-references.md).

```sh
typst compile main.typ out.pdf
```
