# Example 076 · Functions as values, closures

`double` is an arrow function stored in a variable; `twice(f, x)` takes a
function as an argument; `multiplier(n)` returns a function that captures `n` —
a closure. Calling `multiplier(3)` and `multiplier(10)` produces two independent
functions. Used in
[Chapter 14, *Functions and closures*](../../book/14-functions-and-closures.md).

```sh
typst compile main.typ out.pdf
```

Rendered preview: [`out.png`](out.png). Full output: [`out.pdf`](out.pdf).
