# Example 098 · `#include` vs `#import`

Two side files make the contrast concrete. `defs.typ` holds a *definition*
(`signoff`) that `main.typ` pulls in with `#import` and then calls;
`section.typ` holds *content* that `main.typ` splices in with `#include`. Import
brings names; include brings words. Used in
[Chapter 18, *Your own functions*](../../book/18-your-own-functions.md).

```sh
typst compile main.typ out.pdf
```

Rendered preview: [`out.png`](out.png). Full output: [`out.pdf`](out.pdf).
