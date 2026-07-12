# Example 072 · Defining a function with `#let`

`#let greet(name) = [...]` defines a function whose body is content, called
several times with different arguments. `#let shout(word) = { ... }` shows the
block-body form, where the last expression is the function's result. Used in
[Chapter 14, *Functions and closures*](../../book/14-functions-and-closures.md).

```sh
typst compile main.typ out.pdf
```

Rendered preview: [`out.png`](out.png). Full output: [`out.pdf`](out.pdf).
