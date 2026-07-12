# Example 106 · The anatomy of a package

A minimal, **dependency-free** package layout: a `typst.toml` manifest, an
entrypoint `lib.typ` that exports one function, and a `main.typ` that imports
it through a *relative* path — the local smoke-test you run before submitting
to Typst Universe. No network, no registry. From
[Chapter 20, *Packages*](../../book/20-packages.md).

```sh
typst compile main.typ out.pdf
```
