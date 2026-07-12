# Example 096 · The three import forms

One `lib.typ`, imported three ways in `main.typ`: namespaced
(`#import "lib.typ"` then `lib.kbd`), named (`#import "lib.typ": accent, kbd`),
and star (`#import "lib.typ": *`). The comments note when each is the right
call. Used in
[Chapter 18, *Your own functions*](../../book/18-your-own-functions.md).

```sh
typst compile main.typ out.pdf
```

Rendered preview: [`out.png`](out.png). Full output: [`out.pdf`](out.pdf).
