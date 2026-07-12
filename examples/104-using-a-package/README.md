# Example 104 · Using a package

Imports [CeTZ](https://typst.app/universe/package/cetz) from Typst Universe
with a pinned version — `#import "@preview/cetz:0.3.4"` — and draws a labelled
right triangle. From
[Chapter 20, *Packages*](../../book/20-packages.md).

> **Needs the network on the first compile.** Typst downloads `cetz:0.3.4`
> into its local package cache the first time; afterwards it compiles offline.
> This folder carries a `.skip-build` marker so the offline example build
> skips it. Verified against Typst 0.15.0 with `cetz:0.3.4`.

```sh
typst compile main.typ out.pdf
```
