# Example 065 · Switching styles

One source file, one line to restyle everything. As written it renders APA
(author-date, `(Sweller, 1988)`). Change the last line's `style: "apa"` to
`style: "ieee"` and the identical document becomes numbered (`[1]`, `[2]`) with
an IEEE reference list -- nothing else changes. Other built-in names include
`"chicago-author-date"`, `"mla"`, and `"vancouver"`; a path to a `.csl` file
covers anything not built in. From
[Chapter 12, *Citations and bibliographies*](../../book/12-citations-and-bibliographies.md).

Data file: `refs.yml`.

```sh
typst compile main.typ out.pdf
```
