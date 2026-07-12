# Example 054 · Targeting heading levels with `.where`

`heading.where(level: 1)` and `heading.where(level: 2)` select by field, so one
document can style its two heading levels differently: level 1 gets a large
navy show-set, level 2 a maroon function-form rebuild with a `»` marker. Used
in [Chapter 10, *Show rules*](../../book/10-show-rules.md).

```sh
typst compile main.typ out.pdf
```

Rendered preview: [`out.png`](out.png). Full output: [`out.pdf`](out.pdf).
