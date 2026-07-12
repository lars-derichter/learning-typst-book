# Example 105 · A useful package

Uses [physica](https://typst.app/universe/package/physica) — pinned as
`#import "@preview/physica:0.9.4": *` — for compact calculus and vector
notation (`grad`, `pdv`, `dv`, `div`, `vu`, `vb`) inside real equations. From
[Chapter 20, *Packages*](../../book/20-packages.md).

> **Needs the network on the first compile.** Typst downloads `physica:0.9.4`
> into its local package cache the first time; afterwards it compiles offline.
> This folder carries a `.skip-build` marker so the offline example build
> skips it. Verified against Typst 0.15.0 with `physica:0.9.4`.

```sh
typst compile main.typ out.pdf
```
