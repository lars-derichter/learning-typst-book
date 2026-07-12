# Example 107 · A template package

The **dependency-free** anatomy of a *template* package: a `typst.toml` with a
`[template]` section, an entrypoint `lib.typ` exporting a `report` show-rule
function (the Chapter 19 shape), and two starters — the root `main.typ` is a
local test using a relative import (so this folder compiles offline), while
`template/main.typ` is the file `typst init @preview/tidy-report` would drop
into a new project, importing the published package by name. From
[Chapter 20, *Packages*](../../book/20-packages.md).

```sh
typst compile main.typ out.pdf
```

The root `main.typ` compiles with no network. `template/main.typ` is
illustration only — it needs the published package to resolve its `@preview`
import, so it is not part of the offline build.
