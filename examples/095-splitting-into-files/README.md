# Example 095 · Splitting code into its own file

A two-file project. `helpers.typ` defines a `callout` component and prints
nothing on its own; `main.typ` does `#import "helpers.typ": callout` and uses
it. Machinery and content, kept apart. Used in
[Chapter 18, *Your own functions*](../../book/18-your-own-functions.md).

```sh
typst compile main.typ out.pdf
```

Rendered preview: [`out.png`](out.png). Full output: [`out.pdf`](out.pdf).
